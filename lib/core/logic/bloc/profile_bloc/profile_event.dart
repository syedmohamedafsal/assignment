import 'package:equatable/equatable.dart';

// Profile events (e.g., fetching profile data)
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileData extends ProfileEvent {
  final String userId;

  const FetchProfileData(this.userId);

  @override
  List<Object> get props => [userId];
}

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
