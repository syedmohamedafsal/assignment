import 'dart:io';

import 'package:assignment/constants/manager/color/color.dart';
import 'package:assignment/constants/manager/sizedbox/sizedbox.dart';
import 'package:assignment/constants/manager/textstyle/textstyle.dart';
import 'package:assignment/core/logic/bloc/post_bloc/post_bloc.dart';
import 'package:assignment/core/logic/bloc/post_bloc/post_event.dart';
import 'package:assignment/core/logic/bloc/post_bloc/post_state.dart';
import 'package:assignment/view/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Image picker function
  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 1,
                    dashPattern: const [8, 4],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _image == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload_outlined,
                                      size: 40, color: appColor.iconcolor),
                                  appSpace.height10,
                                  Text(
                                    'Upload an Image here',
                                    style: appTextStyle.f22w400black,
                                  ),
                                  appSpace.height5,
                                  Text('JPG or PNG file size no more than 10MB',
                                      style: appTextStyle.f16w400grey),
                                ],
                              ),
                            )
                          : Image.file(_image!, fit: BoxFit.cover),
                    ),
                  ),
                ),
                appSpace.height20,
                const TextbuttonTitle(titletext: 'Event Title'),
                appSpace.height20,
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Post Title',
                    labelStyle: appTextStyle.f14w400grey,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: appColor.btnbgcolor100),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the post title';
                    }
                    return null;
                  },
                ),
                appSpace.height30,
                const TextbuttonTitle(titletext: 'Description'),
                appSpace.height10,
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Write your description...',
                    labelStyle: appTextStyle.f14w400grey,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: appColor.btnbgcolor100),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the post description';
                    }
                    return null;
                  },
                ),
                appSpace.height130,
                BlocListener<PostBloc, PostState>(
                  listener: (context, state) {
                    if (state is PostSubmitting) {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(
                            child: CircularProgressIndicator(
                          color: appColor.btnbgcolor,
                        )),
                      );
                    } else if (state is PostSubmitted) {
                      Navigator.pop(context); // Close loading indicator
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      Navigator.pop(context); // Close the CreatePostScreen
                    } else if (state is PostError) {
                      Navigator.pop(context); // Close loading indicator
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.error}')),
                      );
                    }
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _image != null) {
                        // Create the SubmitPost event
                        final postEvent = SubmitPost(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          image: _image!,
                        );

                        // Dispatch the event to the Bloc
                        context.read<PostBloc>().add(postEvent);
                      } else if (_image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please select an image')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor.buttoncolor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Share',
                        style: appTextStyle.f20w700buttontxtcolor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
