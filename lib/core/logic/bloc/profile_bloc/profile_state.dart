import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String username;
  final String profileImage;
  final String interest;
  final List<String> postImages;
  final int postCount;

  const ProfileLoaded({
    required this.username,
    required this.profileImage,
    required this.interest,
    required this.postImages,
    required this.postCount,
  });
  @override
  List<Object> get props => [username, profileImage, interest, postImages, postCount];
}

class ProfileUpdated extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
