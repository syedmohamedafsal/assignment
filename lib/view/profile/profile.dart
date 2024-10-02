import 'package:assignment/constants/manager/color/color.dart';
import 'package:assignment/constants/manager/sizedbox/sizedbox.dart';
import 'package:assignment/constants/manager/textstyle/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex =
      0; // To track the selected index (0 for Posts, 1 for Saved)
  double _indicatorPosition = 0.0; // To track the position of the indicator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.primarycolor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/image/logo.png', // Use actual logo here
              height: 40,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: appColor.iconcolor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  // Profile picture
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/image/google.png', // Placeholder image URL
                    ),
                  ),
                  SizedBox(height: 12),
                  // User name and bio
                  Text(
                    'Wilson Saris',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Interested in Running',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Stats section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '15',
                        style: appTextStyle.f18w500black,
                      ),
                      Text('Post', style: appTextStyle.f14w400grey),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '150',
                        style: appTextStyle.f18w500black,
                      ),
                      Text('Followers', style: appTextStyle.f14w400grey),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '98',
                        style: appTextStyle.f18w500black,
                      ),
                      Text('Following', style: appTextStyle.f14w400grey),
                    ],
                  ),
                ],
              ),
            ),
            appSpace.height20,
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Image(
                      image: AssetImage('assets/image/edit.png'),
                      height: 20,
                      width: 20,
                    ),
                    label: Text(
                      'Edit Profile',
                      style: appTextStyle.f14w500black,
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: appColor.btnbgcolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Set border radius to 20
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Image(
                      image:
                          AssetImage('assets/image/create_postcardicon.png'),
                      height: 20,
                      width: 20,
                    ),
                    label: Text(
                      'Create Postcard',
                      style: appTextStyle.f14w500black,
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: appColor.btnbgcolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Set border radius to 20
                      ),
                    ),
                  ),
                ],
              ),
            ),
            appSpace.height20,

            // Row for Icon Buttons
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 26,
                      icon: Icon(Icons.grid_view,
                          color: _selectedIndex == 0
                              ? Colors.orange
                              : Colors.black),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0; // Select the Posts view
                          _indicatorPosition = 0.0; // Move indicator to grid
                        });
                      },
                    ),
                    appSpace.width15,
                    IconButton(
                      iconSize: 21,
                      icon: Icon(FontAwesomeIcons.bookmark,
                          color: _selectedIndex == 1
                              ? Colors.orange
                              : Colors.black),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1; // Select the Saved view
                          _indicatorPosition =
                              60.0; // Move indicator to bookmark
                        });
                      },
                    ),
                  ],
                ),
                // Indicator
                Container(
                  margin: const EdgeInsets.only(
                      top: 2.0, right: 57), // Space above the indicator
                  height: 2.0, // Height of the indicator
                  width: 55.0, // Width of the indicator
                  decoration: BoxDecoration(
                    color: Colors.orange, // Color of the indicator
                    borderRadius: BorderRadius.circular(4.0), // Rounded corners
                  ),
                  transform: Matrix4.translationValues(_indicatorPosition, 0,
                      0), // Move the indicator based on selected index
                ),
              ],
            ),
            appSpace.height10,
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.5, // Adjust height as needed
                child: _selectedIndex == 0 ? PostsView() : SavedPostsView(),
              ),
            ),
            appSpace.height20,
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget PostsView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: appColor.btnbgcolor100, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/image/sample.png',
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget SavedPostsView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: 5, // Number of saved posts
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: appColor.btnbgcolor100, width: 2), // Grey border
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://via.placeholder.com/400.png', // Replace with actual image URLs for saved posts
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
