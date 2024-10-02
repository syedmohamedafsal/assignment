// post_event.dart
import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitPost extends PostEvent {
  final String title;
  final String description;
  final File image;

  SubmitPost({required this.title, required this.description, required this.image});

  @override
  List<Object> get props => [title, description, image];
}
