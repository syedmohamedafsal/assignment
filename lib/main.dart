import 'package:assignment/core/logic/bloc/home_bloc/home_bloc.dart';
import 'package:assignment/core/logic/bloc/post_bloc/post_bloc.dart';
import 'package:assignment/core/logic/bloc/profile_bloc/profile_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assignment/view/login/login.dart';
import 'package:assignment/view/home/home_screen.dart';
import 'package:assignment/view/search/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:assignment/core/repo/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (context) => PostBloc(), // Provide the PostBloc here
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(), // Provide the PostBloc here
        ),
        BlocProvider(
          create: (context) =>
              ProfileBloc(storage: FirebaseStorage.instance, firestore: FirebaseFirestore.instance),
        ),

        // Add other BlocProviders here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          'search': (context) => const SearchScreen(),
          // Add more routes here as needed
        },
      ),
    );
  }
}
