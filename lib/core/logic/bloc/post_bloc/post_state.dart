// post_state.dart
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostSubmitting extends PostState {}

class PostSubmitted extends PostState {
  final String message;

  PostSubmitted({required this.message});

  @override
  List<Object> get props => [message];
}

class PostError extends PostState {
  final String error;

  PostError({required this.error});

  @override
  List<Object> get props => [error];
}
