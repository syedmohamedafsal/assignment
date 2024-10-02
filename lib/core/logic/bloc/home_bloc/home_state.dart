import 'package:assignment/core/model/post_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

// State when posts are loading
class HomeLoading extends HomeState {}

// State when posts are successfully fetched
class HomeLoaded extends HomeState {
  final List<PostModel> posts;

  const HomeLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

// State when there's an error while fetching posts
class HomeError extends HomeState {
  final String error;

  const HomeError({required this.error});

  @override
  List<Object> get props => [error];
}
