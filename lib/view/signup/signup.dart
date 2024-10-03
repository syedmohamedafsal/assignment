import 'package:assignment/constants/manager/color/color.dart';
import 'package:assignment/constants/manager/sizedbox/sizedbox.dart';
import 'package:assignment/constants/widgets/custom_checkbox.dart';
import 'package:assignment/constants/widgets/social_image_button.dart';
import 'package:assignment/core/repo/firebase_authendication.dart';
import 'package:assignment/view/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:assignment/constants/manager/textstyle/textstyle.dart';
import 'package:assignment/constants/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _agreeToTerms = false;
  bool _isLoading = false; // Loading state variable

  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appColor.primarycolor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appSpace.height10,
                Center(
                  child: Image.asset(
                    'assets/image/logo.png',
                  ),
                ),
                appSpace.height20,
                Text('Create Account', style: appTextStyle.f25w500black),
                appSpace.height15,
                const TextbuttonTitle(titletext: 'Full Name'),
                appSpace.height10,
                CustomTexField(
                  controller: _fullNameController,
                  hinttext: 'Full Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  obscure: false,
                  customicon: Icon(Icons.person, color: appColor.textgreycolor),
                ),
                appSpace.height15,
                const TextbuttonTitle(titletext: 'Email'),
                appSpace.height10,
                CustomTexField(
                  controller: _emailController,
                  hinttext: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  obscure: false,
                  customicon:
                      Icon(Icons.email_outlined, color: appColor.textgreycolor),
                ),
                appSpace.height15,
                const TextbuttonTitle(titletext: 'Password'),
                appSpace.height10,
                CustomTexField(
                  controller: _passwordController,
                  hinttext: 'Enter your password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  obscure: true,
                  customicon:
                      Icon(Icons.lock_outline, color: appColor.textgreycolor),
                ),
                appSpace.height15,
                const TextbuttonTitle(titletext: 'Confirm Password'),
                appSpace.height10,
                CustomTexField(
                  controller: _confirmPasswordController,
                  hinttext: 'Re-enter your password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  obscure: true,
                  customicon: Icon(Icons.lock_outline_rounded,
                      color: appColor.textgreycolor),
                ),
                appSpace.height20,
                Row(
                  children: [
                    CustomCheckbox(
                      value: _agreeToTerms,
                      onChanged: (newValue) {
                        setState(() {
                          _agreeToTerms = newValue ?? false;
                        });
                      },
                    ),
                    appSpace.width10,
                    Text(
                      'I agree to terms & conditions',
                      style: appTextStyle.f16w400black,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _agreeToTerms
                        ? () async {
                            if (_fullNameController.text.isNotEmpty &&
                                _emailController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty &&
                                _confirmPasswordController.text.isNotEmpty) {
                              setState(() {
                                _isLoading = true; // Show loading indicator
                              });

                              try {
                                // Call the sign-up function
                                User? user = await _authService
                                    .signUpWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                );

                                // Save user details to Firestore
                                if (user != null) {
                                  await _authService.saveUserDetails(
                                    user.uid,
                                    _fullNameController.text,
                                    _emailController.text,
                                    'default_profile_image_url.png',
                                    'intrest'
                                  );
                                }

                                // Show success Snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Successfully signed up!')),
                                );

                                // Navigate to the login screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false; // Hide loading indicator
                                });
                              }
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor.buttoncolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isLoading // Show loading indicator while signing up
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Create Account',
                            style: appTextStyle.f20w700buttontxtcolor,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: appColor.textgreycolor,
                              thickness: 1,
                              height: 2,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'You can Connect with',
                              style: appTextStyle.f18w400grey,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: appColor.textgreycolor,
                              thickness: 1,
                              height: 2,
                            ),
                          ),
                        ],
                      ),
                      appSpace.height20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialImageButton(
                            image: Image.asset(
                              'assets/image/facebook.png',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                            onPressed: () async {
                              // Implement Facebook sign-in logic here
                            },
                          ),
                          appSpace.width10,
                          SocialImageButton(
                            image: Image.asset(
                              'assets/image/google.png',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                            onPressed: () async {
                              // Implement Google sign-in logic here
                            },
                          ),
                          appSpace.width10,
                          SocialImageButton(
                            image: Image.asset(
                              'assets/image/apple.png',
                              height: 40,
                              width: 40,
                            ),
                            onPressed: () async {
                              // Implement Apple sign-in logic here
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                appSpace.height10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: appTextStyle.f16w400black),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: appTextStyle.f16w500orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
