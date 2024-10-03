import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'dart:io';
import 'package:path/path.dart'; // Ensure you have this import for basename

class UpdateProfile extends ProfileEvent {
  final String userId;
  final String? username;
  final String? interest;
  final String? profileImage;

  UpdateProfile({
    required this.userId,
    this.username,
    this.interest,
    this.profileImage,
  });
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileBloc({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _storage = storage,
        super(ProfileInitial()) {
    on<FetchProfileData>(_onFetchProfileData);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onFetchProfileData(
      FetchProfileData event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final userDoc =
          await _firestore.collection('signup').doc(event.userId).get();

      if (!userDoc.exists) {
        emit(const ProfileError("User not found"));
        return;
      }

      final username = userDoc.data()?['fullName'] ?? 'Anonymous User';
      final profileImage = userDoc.data()?['profileImageUrl'] ??
          'https://firebasestorage.googleapis.com/v0/b/assignment-45974.appspot.com/o/posts%2Fdefault.jpg?alt=media&token=f4a2576a-2274-43b6-9ee8-63e6bfe9fcef';
      final interest = userDoc.data()?['intrest'] ?? 'No interests specified';

      final postsQuery = await _firestore
          .collection('posts')
          .where('username', isEqualTo: username)
          .get();

      final postImages =
          postsQuery.docs.map((doc) => doc['imageUrl'] as String).toList();

      emit(ProfileLoaded(
        username: username,
        profileImage: profileImage,
        interest: interest,
        postImages: postImages,
        postCount: postImages.length,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      String? imageUrl;

      // Fetch the existing user document
      final userDoc =
          await _firestore.collection('signup').doc(event.userId).get();
      if (!userDoc.exists) {
        emit(ProfileError("User not found"));
        return;
      }

      final currentUsername = userDoc.data()?['fullName'] ?? '';

      // If there's a new profile image, upload it to Firebase Storage
      if (event.profileImage != null) {
        // Upload image and handle any potential errors
        try {
          imageUrl =
              await _uploadImageToFirebase(event.profileImage!, event.userId);
        } catch (e) {
          emit(ProfileError('Failed to upload image: $e'));
          return; // Stop further processing if image upload fails
        }
      }

      // Create the data map for Firestore update
      Map<String, dynamic> data = {};
      if (event.username != null) data['fullName'] = event.username;
      if (event.interest != null) data['intrest'] = event.interest;
      if (imageUrl != null) {
        data['profileImageUrl'] =
            imageUrl; // Ensure imageUrl is only updated when it's not null
      }

      // Only update Firestore if there's something to update
      if (data.isNotEmpty) {
        await _firestore.collection('signup').doc(event.userId).update(data);
      }

      // Update posts if username, profile image, or interest changed
      if (event.username != null ||
          imageUrl != null ||
          event.interest != null) {
        // Fetch all posts by the user using the old username
        final postsQuery = await _firestore
            .collection('posts')
            .where('username', isEqualTo: currentUsername)
            .get();

        // Update relevant fields in each post document
        for (var post in postsQuery.docs) {
          Map<String, dynamic> postData = {};
          if (imageUrl != null) postData['userProfileImage'] = imageUrl;
          if (event.username != null) postData['username'] = event.username;
          if (event.interest != null) postData['interests'] = event.interest;

          if (postData.isNotEmpty) {
            await post.reference.update(postData);
          }
        }
      }

      // Emit success state
      emit(ProfileUpdated());

      // Optionally refetch profile data after the update
      add(FetchProfileData(event.userId));
    } catch (error) {
      emit(ProfileError('Failed to update profile: ${error.toString()}'));
    }
  }

  Future<String> _uploadImageToFirebase(String imagePath, String userId) async {
    File file = File(imagePath);

    // Store the image in the "profile" folder in Firebase Storage
    String fileName =
        'profile_images/${userId}/${basename(file.path)}'; // Ensure unique filenames
    Reference storageRef = _storage.ref().child(fileName);

    UploadTask uploadTask = storageRef.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref
        .getDownloadURL(); // Get the download URL after upload

    return downloadUrl; // Return the download URL
  }
}
