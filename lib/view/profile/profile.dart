import 'package:assignment/constants/manager/color/color.dart';
import 'package:assignment/constants/manager/sizedbox/sizedbox.dart';
import 'package:assignment/constants/manager/textstyle/textstyle.dart';
import 'package:assignment/core/logic/bloc/profile_bloc/profile_bloc.dart';
import 'package:assignment/core/logic/bloc/profile_bloc/profile_event.dart';
import 'package:assignment/core/logic/bloc/profile_bloc/profile_state.dart';
import 'package:assignment/view/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final String userId; // Pass userId to the screen

  const ProfileScreen({super.key, required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0; // Posts view by default
  double _indicatorPosition = 0.0; // To move the indicator

  @override
  void initState() {
    super.initState();
    // Fetch user profile data when the screen is initialized
    context.read<ProfileBloc>().add(FetchProfileData(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor.primarycolor,
        title: const Image(
          image: AssetImage('assets/image/logo.png'),
          height: 200,
          width: 200,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
            color: appColor.iconcolor,
            iconSize: 30,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProfileLoaded) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(state.profileImage),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.username,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.interest,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatsSection(state.postCount),
                      appSpace.height20,
                      _buildButtons(state),
                      appSpace.height10,
                      _buildIconRow(),
                      appSpace.height10,
                      _buildPostsOrSavedView(state.postImages),
                    ],
                  );
                } else if (state is ProfileError) {
                  return Center(
                    child: Text('Error: ${state.message}'),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Build the stats section for posts, followers, and following
  Widget _buildStatsSection(int postCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '$postCount', // Use the actual post count here
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text('Posts'),
            ],
          ),
          const Column(
            children: [
              Text(
                '150', // Placeholder for followers count
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Followers'),
            ],
          ),
          const Column(
            children: [
              Text(
                '98', // Placeholder for following count
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Following'),
            ],
          ),
        ],
      ),
    );
  }

  // Build the buttons (Edit Profile, Create Postcard)
  Widget _buildButtons(ProfileLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Edit Profile Button
          Container(
            decoration: BoxDecoration(
              color: appColor.btnbgcolor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: appColor.btnbgcolor300,
                width: 1,
              ),
            ),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      userId: widget.userId,
                      currentProfileImage: state.profileImage,
                      currentUsername: state.username,
                      currentInterest: state.interest,
                    ),
                  ),
                );
              },
              icon: const Image(
                image: AssetImage('assets/image/edit.png'),
                height: 20,
                width: 20,
              ),
              label: Text(
                'Edit Profile',
                style: appTextStyle.f16w400black,
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
              ),
            ),
          ),
          // Create Postcard Button
          Container(
            decoration: BoxDecoration(
              color: appColor.btnbgcolor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: appColor.btnbgcolor300,
                width: 1,
              ),
            ),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Image(
                image: AssetImage('assets/image/create_postcardicon.png'),
                height: 26,
                width: 25,
              ),
              label: Text(
                'Create Postcard',
                style: appTextStyle.f16w400black,
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // Build the icon row (Grid and Bookmark view)
  // Build the icon row (Grid and Bookmark view)
  Widget _buildIconRow() {
    return Stack(
      alignment: Alignment.bottomCenter, // Center the indicator horizontally
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.grid_view,
                  color: _selectedIndex == 0
                      ? appColor.buttoncolor
                      : appColor.textgreycolor),
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                  _indicatorPosition = 0.0; // Set position for grid view
                });
              },
            ),
            appSpace.width5,
            IconButton(
              iconSize: 22,
              icon: Icon(FontAwesomeIcons.bookmark,
                  color: _selectedIndex == 1
                      ? appColor.buttoncolor
                      : appColor.textgreycolor),
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                  _indicatorPosition = 60.0; // Set position for bookmark view
                });
              },
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: _indicatorPosition + 160,
          child: Container(
            width: 40,
            height: 2,
            color: appColor.buttoncolor,
          ),
        ),
      ],
    );
  }

  // Build the posts or saved view based on the selected index
  Widget _buildPostsOrSavedView(List<String> postImages) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: _selectedIndex == 0
            ? _buildPostsGrid(postImages)
            : const Text('Saved posts view'),
      ),
    );
  }

  // Build the posts grid view
  Widget _buildPostsGrid(List<String> postImages) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: postImages.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: appColor.btnbgcolor300, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(postImages[index], fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
