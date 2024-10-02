// Social Image Button Widget
import 'package:assignment/constants/manager/color/color.dart';
import 'package:flutter/material.dart';

class SocialImageButton extends StatelessWidget {
  final Image image;
  final VoidCallback onPressed;

  const SocialImageButton({
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: IconButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(appColor.btnbgcolor),
        ),
        onPressed: onPressed,
        icon: image,
        iconSize: 40, // Adjust icon size according to your design
      ),
    );
  }
}
