import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String title;
  final String description;
  final String imageUrl;
  final String username;
  final String userProfileImage;
  final List<String> interests;
  final DateTime? timestamp;

  PostModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.username,
    required this.userProfileImage,
    required this.interests,
    this.timestamp,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return PostModel(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      username: data['username'] ?? '',
      userProfileImage: data['userProfileImage'] ?? '',
      interests: List<String>.from(data['interests'] ?? []),
      timestamp: data['timestamp']?.toDate(),
    );
  }
}
