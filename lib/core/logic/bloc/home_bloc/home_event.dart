import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

// Event to fetch all posts
class FetchHomePosts extends HomeEvent {}
