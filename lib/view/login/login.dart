import 'package:assignment/constants/widgets/social_image_button.dart';
import 'package:assignment/core/repo/firebase_authendication.dart';
import 'package:assignment/view/signup/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:assignment/constants/manager/color/color.dart';
import 'package:assignment/constants/manager/sizedbox/sizedbox.dart';
import 'package:assignment/constants/manager/textstyle/textstyle.dart';
import 'package:assignment/constants/widgets/custom_text_field.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign In
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Google SignIn instance

  bool _isLoading = false; // Loading state
  bool _rememberMe = false; // Remember Me state

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // Load saved email and password
  }

  // Load saved email and password if "Remember Me" is checked
  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null) {
      _emailController.text = savedEmail; // Set the email if it exists
    }
    if (savedPassword != null) {
      _passwordController.text = savedPassword; // Set the password if it exists
    }
  }

  // Function to clear text fields
  void clearTextFields() {
    _emailController.clear(); // Clear the email text field
    _passwordController.clear(); // Clear the password text field
  }

  // Function to handle sign in
  void _signIn() async {
    // Validate inputs
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      User? user =
          await _authService.signInWithEmailAndPassword(email, password,clearTextFields);
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'lastLogin': Timestamp.now(),
        });

        // Save credentials if "Remember Me" is checked
        if (_rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);
          await prefs.setString('password', password);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged in successfully!')),
        );

        clearTextFields(); // Clear the text fields after successful login

        Navigator.pushReplacementNamed(context, '/home'); // Navigate to home
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in failed. Please try again.')),
        );
        clearTextFields(); // Clear the text fields after failed login
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      clearTextFields(); // Clear the text fields after an error
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Function for Google Sign-In
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      // Save user data to Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'displayName': user.displayName,
          'lastLogin': Timestamp.now(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in with Google successfully!')),
      );

      Navigator.pushReplacementNamed(context, '/home'); // Navigate to home
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appColor.primarycolor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                    child: Image(image: AssetImage('assets/image/logo.png'))),
                appSpace.height20,
                Text("Welcome Back!", style: appTextStyle.f25w500black),
                appSpace.height5,
                Text("Let's login to explore continues",
                    style: appTextStyle.f16w400grey),
                appSpace.height30,
                const TextbuttonTitle(titletext: 'Email or Phone Number'),
                appSpace.height10,
                CustomTexField(
                  customicon:
                      const Icon(Icons.email_outlined, color: Colors.grey),
                  controller: _emailController,
                  hinttext: 'Email or Phone Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                appSpace.height30,
                const TextbuttonTitle(titletext: 'Password'),
                appSpace.height10,
                CustomTexField(
                  customicon:
                      const Icon(Icons.lock_outline, color: Colors.grey),
                  controller: _passwordController,
                  hinttext: 'Enter your password',
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password functionality
                    },
                    child: Text('Forgot Password?',
                        style: appTextStyle.f14w400orange),
                  ),
                ),
                appSpace.height10,
                // Remember Me
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (newValue) {
                        setState(() {
                          _rememberMe = newValue ?? false;
                        });
                      },
                    ),
                    appSpace.width10,
                    Text('Remember Me', style: appTextStyle.f16w400black),
                  ],
                ),
                appSpace.height30,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColor.buttoncolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Sign In',
                          style: appTextStyle.f20w700buttontxtcolor),
                ),
                appSpace.height40,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('You can Connect with',
                          style: appTextStyle.f18w400grey),
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
                      image: Image.asset('assets/image/facebook.png',
                          height: 40, width: 40, fit: BoxFit.cover),
                      onPressed: () {
                        // TODO: Implement Facebook sign-in
                      },
                    ),
                    SocialImageButton(
                      image: Image.asset('assets/image/google.png',
                          height: 40, width: 40, fit: BoxFit.cover),
                      onPressed: () {
                        _signInWithGoogle(); // Call Google Sign-In
                      },
                    ),
                    SocialImageButton(
                      image: Image.asset(
                        'assets/image/apple.png',
                        height: 40,
                        width: 40,
                      ),
                      onPressed: () {
                        // TODO: Implement Apple sign-in
                      },
                    ),
                  ],
                ),
                appSpace.height40,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: appTextStyle.f16w400black),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: Text('Sign Up', style: appTextStyle.f16w500orange),
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

class TextbuttonTitle extends StatelessWidget {
  final String titletext;
  const TextbuttonTitle({
    super.key,
    required this.titletext,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: titletext,
          style: appTextStyle.f16w400black,
          children: const [
            TextSpan(
              text: '*',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
