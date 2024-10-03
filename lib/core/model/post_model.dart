import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String userProfileImage;
  final String username;
  final List<String> interests;
  final String description;
  final String imageUrl;

  PostModel({
    required this.userProfileImage,
    required this.username,
    required this.interests,
    required this.description,
    required this.imageUrl,
  });

  // Factory method to create a PostModel from Firestore data
  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PostModel(
      userProfileImage: data['userProfileImage'] ?? '',
      username: data['username'] ?? '',
      // Handle 'interests' field which can be stored as a String or List<String>
      interests: data['interests'] is String
          ? [data['interests']] // Convert single String to List
          : List<String>.from(data['interests'] ?? []), // Handle List<String>
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
