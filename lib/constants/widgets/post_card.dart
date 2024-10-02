import 'package:assignment/constants/manager/color/color.dart';
import 'package:assignment/constants/manager/sizedbox/sizedbox.dart';
import 'package:assignment/constants/manager/textstyle/textstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
                    NetworkImage(profileImage), // User's profile image
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
              child: Image.network(
                postImage,
                width: 400,
                height: 200, // Set the height of the image
                fit: BoxFit.cover, // Cover the entire area
              ),
            ),
            appSpace.height10,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: appColor.iconcolor,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.chat_bubble_outline,
                      color: appColor.iconcolor),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.send, color: appColor.iconcolor),
                  onPressed: () {},
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.bookmark_outline, color: appColor.iconcolor),
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
                      backgroundImage: NetworkImage(profileImage),
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
