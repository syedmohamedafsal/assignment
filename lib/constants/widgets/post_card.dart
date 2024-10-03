import 'package:assignment/constants/manager/color/color.dart';
import 'package:assignment/constants/manager/sizedbox/sizedbox.dart';
import 'package:assignment/constants/manager/textstyle/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostWidget extends StatefulWidget {
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
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isLiked = false; // State for like button
  bool _isBookmarked = false; // State for bookmark button
  bool _showComments = false; // State to show/hide comments section
  final TextEditingController _commentController = TextEditingController();
  List<String> _comments = []; // List to store comments
  bool _isExpanded = false; // Track if the content is expanded

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user ID
  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid; // Get current user ID
  }

  // Function to store bookmark data in Firebase
  Future<void> _storeBookmarkData(
      String postImageUrl, String description) async {
    String? userId = getCurrentUserId();
    if (userId == null) {
      // Handle user not logged in case
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    // Create a document for the bookmark in the user's bookmarks collection
    try {
      await _firestore.collection('bookmarks').add({
        'userId': userId,
        'postImageUrl': postImageUrl,
        'description': description,
        'username': widget.name, // Include username
        'userProfileImage': widget.profileImage, // Include profile image
        'timestamp': FieldValue.serverTimestamp(), // To sort bookmarks later
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark saved successfully!')),
      );
    } catch (error) {
      print('Error saving bookmark: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving bookmark: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        margin: const EdgeInsets.symmetric(
            vertical: 10), // Adds spacing between cards
        elevation: 0, // No elevation for a flat look
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        color: appColor
            .btnbgcolor50, // Set the background color of the card to grey
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Padding inside the card
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.profileImage), // User's profile image
                ),
                title: Text(widget.name, style: appTextStyle.f18w500black),
                subtitle: Text(widget.activity),
                trailing: Icon(
                  Icons.more_vert,
                  color: appColor.textcolor,
                  size: 30,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sharing Experience',
                    style: appTextStyle.f20w500black,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: RichText(
                        text: TextSpan(
                          style: appTextStyle.f16w400black,
                          children: _buildTextWithHashtags(widget.content),
                        ),
                        maxLines:
                            _isExpanded ? null : 2, // Show full or limited text
                        overflow: _isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded; // Toggle the expanded state
                    });
                  },
                  child: Text(_isExpanded ? "See Less" : "See More",
                      style: appTextStyle.f16w400greydec),
                ),
              ),
              appSpace.height10,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.postImage,
                    width: 400,
                    height: 200, // Set the height of the image
                    fit: BoxFit.cover, // Cover the entire area
                  ),
                ),
              ),
              appSpace.height10,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Heart icon button
                  IconButton(
                    icon: Icon(
                      _isLiked
                          ? FontAwesomeIcons
                              .solidHeart // Solid heart when liked
                          : FontAwesomeIcons.heart, // Regular heart otherwise
                      color:
                          _isLiked ? appColor.heartcolor : appColor.iconcolor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isLiked = !_isLiked; // Toggle heart icon and color
                      });
                    },
                  ),
                  // Comment icon button
                  IconButton(
                    icon: Icon(FontAwesomeIcons.commentDots,
                        color: appColor.iconcolor),
                    onPressed: () {
                      setState(() {
                        _showComments =
                            !_showComments; // Toggle the comments section visibility
                      });
                    },
                  ),
                  // Send icon button
                  IconButton(
                    icon: Icon(FontAwesomeIcons.paperPlane,
                        color: appColor.iconcolor),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Successfully sent!',
                              style: appTextStyle.f16w500orange),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  // Bookmark icon button
                  IconButton(
                    icon: Icon(
                      _isBookmarked
                          ? FontAwesomeIcons
                              .solidBookmark // Solid when bookmarked
                          : FontAwesomeIcons.bookmark, // Regular otherwise
                      color: _isBookmarked
                          ? appColor.buttoncolor
                          : appColor.iconcolor,
                    ),
                    onPressed: () async {
                      setState(() {
                        _isBookmarked = !_isBookmarked; // Toggle bookmark icon
                      });
                      // Store bookmark data if bookmarked
                      if (_isBookmarked) {
                        await _storeBookmarkData(
                            widget.postImage, widget.content);
                      } else {
                        // Handle removal of the bookmark if needed (optional)
                        // You can implement a method to remove the bookmark from Firestore if necessary.
                      }
                    },
                  ),
                ],
              ),
              // Conditionally display the comments section based on _showComments
              if (_showComments) _buildCommentsSection(),
              // Display the comment field (always visible)
              _buildCommentField(),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build the comment input field (always visible)
  Widget _buildCommentField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30), // Rounded corners
            ),
            child: Row(
              children: [
                appSpace.width20,
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(widget.profileImage),
                ),
                appSpace.width10,
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle:
                          appTextStyle.f14w400grey, // Set hint text color
                      border: InputBorder.none, // No border
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: appColor.buttoncolor),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      setState(() {
                        _comments.add(
                            _commentController.text); // Add comment to list
                        _commentController.clear(); // Clear input field
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build the comments section
  Widget _buildCommentsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: _comments.map((comment) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(widget.profileImage),
                ),
                appSpace.width10,
                Expanded(
                  child: Text(
                    comment,
                    style: appTextStyle.f14w400black,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
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
