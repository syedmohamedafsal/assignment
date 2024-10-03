import 'package:assignment/constants/manager/color/color.dart';
import 'package:assignment/constants/manager/sizedbox/sizedbox.dart';
import 'package:assignment/core/model/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assignment/core/logic/bloc/home_bloc/home_bloc.dart';
import 'package:assignment/core/logic/bloc/home_bloc/home_event.dart';
import 'package:assignment/core/logic/bloc/home_bloc/home_state.dart';
import 'package:assignment/constants/widgets/post_card.dart';
import 'package:assignment/view/add_post/add_post.dart';
import 'package:assignment/view/chat/chat.dart';
import 'package:assignment/view/profile/profile.dart';
import 'package:assignment/view/search/search.dart';
import 'package:assignment/view/bottom_nav/bottom_navbar.dart'; // Import the BottomNavBar

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Selected index for bottom navigation

  // Handle item tap
  void _onItemTapped(int index) {
    if (index == 2) {
      // If Add icon is tapped, navigate to AddPostScreen separately
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreatePostScreen()),
      );
    } else {
      // Otherwise, update the selected index to switch the screen
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  'assets/image/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              actions: [
                IconButton(
                  iconSize: 28,
                  icon: Icon(Icons.notifications_outlined,
                      color: appColor.iconcolor),
                  onPressed: () {},
                ),
                const Image(
                  image: AssetImage('assets/image/icon.png'),
                  height: 30,
                  width: 30,
                ),
                appSpace.width10,
              ],
            )
          : null, // No AppBar for other screens
      body: _buildBody(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return BlocProvider(
          create: (context) => HomeBloc()..add(FetchHomePosts()),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeLoaded) {
                return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    PostModel post = state.posts[index];
                    return PostWidget(
                      profileImage: post.userProfileImage,
                      name: post.username,
                      activity: post.interests.join(', '),
                      content: post.description,
                      postImage: post.imageUrl,
                    );
                  },
                );
              } else if (state is HomeError) {
                return Center(child: Text('Error: ${state.error}'));
              } else {
                return const Center(child: Text('No posts available'));
              }
            },
          ),
        );
      case 1:
        return const SearchScreen(); // Show Search screen
      case 3:
        return const ChatScreen(); // Show Chat screen
      case 4:
        String? userId =
            FirebaseAuth.instance.currentUser?.uid; // Get current user ID
        if (userId != null) {
          return ProfileScreen(
              userId:
                  userId); // Pass the current user's ID to the ProfileScreen
        } else {
          return const Center(child: Text('User not logged in'));
        }

      default:
        return const Center(child: Text('No Screen Available'));
    }
  }
}
