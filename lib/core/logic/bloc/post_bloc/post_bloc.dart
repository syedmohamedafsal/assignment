import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_event.dart';
import 'post_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    // Register the event handler for SubmitPost
    on<SubmitPost>(_onSubmitPost);
  }

  // Event handler for SubmitPost
  Future<void> _onSubmitPost(SubmitPost event, Emitter<PostState> emit) async {
    emit(PostSubmitting());
    try {
      // Upload the image to Firebase Storage
      String imageUrl = await uploadImage(event.image);

      // Save post data to Firestore
      await savePostToFirestore(event.title, event.description, imageUrl);

      // Emit success state
      emit(PostSubmitted(message: 'Post shared successfully!'));
    } catch (e) {
      // Emit error state
      emit(PostError(error: e.toString()));
    }
  }

  // Function to upload image to Firebase Storage
  Future<String> uploadImage(File image) async {
    try {
      // Create a reference to Firebase Storage
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('posts/${image.path.split('/').last}'); // Get file name

      // Upload the image
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Error uploading image: $e");
    }
  }

  // Function to save post data to Firestore
  Future<void> savePostToFirestore(
      String title, String description, String imageUrl) async {
    // Get the current user's UID
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    // Fetch user profile data from the 'signup' collection
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('signup')
        .doc(user.uid) // Use the current user's UID
        .get();

    if (!userDoc.exists) {
      throw Exception("User not found in signup collection");
    }

    // Extract user data from the document
    String username = userDoc['fullName'] ?? "Unknown User"; // Fetch full name
    String userProfileImage =
        userDoc['profileImageUrl'] ?? ""; // Fetch profile image

    // Check if 'intrest' is a list or a string and convert accordingly
    var interestsData = userDoc['intrest'];
    List<String> interests;

    if (interestsData is String) {
      // If it's a single string, create a list with one element
      interests = [interestsData];
    } else if (interestsData is Iterable) {
      // If it's already a list, cast it properly
      interests = List<String>.from(interestsData);
    } else {
      // Fallback: if no interests found or invalid data type, use an empty list
      interests = [];
    }

    // Save post data to Firestore
    await FirebaseFirestore.instance.collection('posts').add({
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'username': username,
      'userProfileImage': userProfileImage,
      'interests': interests,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
