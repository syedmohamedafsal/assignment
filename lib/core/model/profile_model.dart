// profile_model.dart
class ProfileModel {
  final String userId;
  final String username;
  final String interest;
  final String profileImage;
  final int postCount;

  ProfileModel({
    required this.userId,
    required this.username,
    required this.interest,
    required this.profileImage,
    required this.postCount,
  });

  factory ProfileModel.fromDocument(Map<String, dynamic> data, String userId) {
    return ProfileModel(
      userId: userId,
      username: data['username'] ?? '',
      interest: data['interest'] ?? '',
      profileImage: data['profileImage'] ?? '',
      postCount: data['postCount'] ?? 0,
    );
  }
}
