import 'package:assignment/core/model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assignment/core/logic/bloc/home_bloc/home_event.dart';
import 'package:assignment/core/logic/bloc/home_bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchHomePosts>(_onFetchHomePosts);
  }

  Future<void> _onFetchHomePosts(
      FetchHomePosts event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      List<PostModel> posts = snapshot.docs.map((doc) {
        return PostModel.fromFirestore(doc);
      }).toList();

      emit(HomeLoaded(posts: posts));
    } catch (e) {
      emit(HomeError(error: e.toString()));
    }
  }
}
