import 'dart:io';

import 'package:assignment/core/logic/bloc/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;
  final String currentProfileImage;
  final String currentUsername;
  final String currentInterest;

  const EditProfileScreen({
    Key? key,
    required this.userId,
    required this.currentProfileImage,
    required this.currentUsername,
    required this.currentInterest,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.currentUsername;
    _interestController.text = widget.currentInterest;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  void _updateProfile() {
    final String username = _usernameController.text;
    final String interest = _interestController.text;

    context.read<ProfileBloc>().add(UpdateProfile(
          userId: widget.userId,
          username: username,
          interest: interest,
          profileImage: _selectedImagePath,
        ));

    Navigator.pop(context); // Navigate back after updating
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _selectedImagePath != null
                    ? FileImage(File(_selectedImagePath!))
                    : NetworkImage(widget.currentProfileImage) as ImageProvider,
                child: _selectedImagePath == null
                    ? const Icon(Icons.camera_alt, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            TextField(
              controller: _interestController,
              decoration: const InputDecoration(labelText: 'Interests'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
