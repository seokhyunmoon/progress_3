import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile2/presentations/categories_screen.dart';
import 'package:mobile2/presentations/login_page.dart'; // Replace with your actual login page import
import 'package:mobile2/presentations/main_screen.dart';
import 'package:mobile2/presentations/profile_screen.dart'; // Replace with your main screen import


void main() {
  runApp(
    const ProviderScope(
      // Riverpod provider scope
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '응정 게시판',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(), // Assuming the login page is the first screen
      routes: {
        '/main': (context) => MainScreen(), // Main screen route
        '/post': (context) => CategoriesScreen(),
        '/account': (context) => ProfileScreen(),
        // Define other routes here
      },
    );
  }
}

