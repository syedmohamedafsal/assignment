import 'package:assignment/constants/manager/color/color.dart';
import 'package:assignment/constants/manager/sizedbox/sizedbox.dart';
import 'package:assignment/constants/manager/textstyle/textstyle.dart';
import 'package:assignment/view/add_post/add_post.dart';
import 'package:assignment/view/bottom_nav/bottom_navbar.dart';
import 'package:assignment/view/chat/chat.dart';
import 'package:assignment/view/profile/profile.dart';
import 'package:assignment/view/search/search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens for bottom navigation bar
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeContentScreen(), // Home screen (with AppBar)
    const SearchScreen(), // Search screen (no AppBar)
    CreatePostScreen(), // AddPostScreen (Will navigate separately)
    const ChatScreen(), // Chat screen (no AppBar)
    ProfileScreen(), // Profile screen (no AppBar)
  ];

  // Handle item tap
  void _onItemTapped(int index) {
    if (index == 2) {
      // If Add icon is tapped, navigate to AddPostScreen separately
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreatePostScreen()),
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
      backgroundColor: Colors.white, // Set the background color to 100% white
      body: _widgetOptions
          .elementAt(_selectedIndex), // Display the selected screen
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// Home Content (with AppBar)
class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure the body background is also white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          width: 200, // Desired width
          height: 200, // Desired height
          child: Image.asset(
            'assets/image/logo.png',
            fit: BoxFit.contain, // Ensure it scales correctly
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: appColor.textcolor),
            onPressed: () {},
          ),
          Image(
            image: AssetImage('assets/image/icon.png'),
            height: 30,
            width: 40,
          ),
          appSpace.width5
        ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              PostWidget(
                profileImage:
                    'assets/image/apple.png', // First user's profile image
                name: 'Peter Thornton',
                activity: 'Walking | Running | Cycling',
                content:
                    'I\'d love to #share that I\'ve been walking with my neighbor...',
                postImage: 'assets/image/google.png', // First post image
              ),
              PostWidget(
                profileImage:
                    'assets/image/facebook.png', // Second user's profile image
                name: 'Ryan Lipshutz',
                activity: 'Interested in marathons',
                content: '#Happy to announce that I\'ve completed a 2...',
                postImage: 'assets/image/facebook.png', // Second post image
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// PostWidget encapsulated in a Card
class PostWidget extends StatelessWidget {
  final String profileImage;
  final String name;
  final String activity;
  final String content;
  final String postImage;

  const PostWidget({
    Key? key,
    required this.profileImage,
    required this.name,
    required this.activity,
    required this.content,
    required this.postImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
          vertical: 10), // Adds spacing between cards
      elevation: 0, // No elevation for a flat look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      color: Colors.grey[50], // Set the background color of the card to grey
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Padding inside the card
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    AssetImage(profileImage), // User's profile image
              ),
              title: Text(name, style: appTextStyle.f18w500black),
              subtitle: Text(activity),
              trailing: Icon(
                Icons.more_vert,
                color: appColor.textcolor,
                size: 30,
              ),
            ),
            // Row for content and "See All" button
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: RichText(
                      text: TextSpan(
                        style: appTextStyle.f16w400black, // Default style
                        children: _buildTextWithHashtags(content),
                      ),
                      maxLines:
                          2, // Controls the number of lines before truncating
                      overflow: TextOverflow
                          .ellipsis, // Ensures that text overflows with ellipsis
                    ),
                  ),
                ),
              ],
            ),
            appSpace.height10,
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(20), // Border radius for the image
              child: Image.asset(
                postImage,
                width: 200, // Set the width of the image
                height: 200, // Set the height of the image
                fit: BoxFit.cover, // Cover the entire area
              ),
            ),
            appSpace.height10,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.bookmark_outline),
                  onPressed: () {},
                ),
              ],
            ),
            // Comment section without shadow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Colors.white, // White background for the comment section
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                child: Row(
                  children: [
                    appSpace.width20,
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage(profileImage),
                    ),
                    appSpace.width10,
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle:
                              appTextStyle.f14w400grey, // Set hint text color
                          border: InputBorder.none, // No border
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build TextSpan with highlighted hashtags
  List<TextSpan> _buildTextWithHashtags(String content) {
    final List<TextSpan> textSpans = [];
    final List<String> words = content.split(' ');

    for (var word in words) {
      if (word.startsWith('#')) {
        // Highlight hashtags with blue color
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              color: Colors.blue, // Hashtag color
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle hashtag tap if necessary
              },
          ),
        );
      } else {
        // Normal text
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: appTextStyle.f16w400black,
          ),
        );
      }
    }

    return textSpans;
  }
}
