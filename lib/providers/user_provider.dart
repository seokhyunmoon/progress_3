import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile2/models/user.dart'; // Import your User model

final userProvider = FutureProvider<User>((ref) async {
  // Replace with your actual endpoint to fetch user data
  final response = await http.get(Uri.parse('http://localhost:3000/users'));
  if (response.statusCode == 200) {
    final List<User> users = (json.decode(response.body) as List)
        .map((userJson) => User.fromJson(userJson))
        .toList();
    return users
        .first; // or users.singleWhere((user) => user.id == YOUR_USER_ID);
  } else {
    throw Exception('Failed to fetch user info');
  }
});
