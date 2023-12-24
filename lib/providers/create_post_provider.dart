import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile2/models/user.dart'; // Replace with the correct path to your User model
import 'package:mobile2/providers/user_provider.dart'; // Replace with the correct path to your userProvider

final createPostProvider =
    FutureProvider.autoDispose.family<void, Map<String, dynamic>>(
  (ref, postToCreate) async {
    final newPost = {
      'title': postToCreate['title'],
      'content': postToCreate['content'],
      'userId': postToCreate['userId'], // 현재 로그인한 사용자의 ID
      'categoryId': postToCreate['categoryId'], // 여기서 categoryId를 사용합니다
      'upvotes': 0,
      'downvotes': 0,
      'createdAt': DateTime.now().toIso8601String(),
    };

    final response = await http.post(
      Uri.parse('http://localhost:3000/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newPost),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create post: ${response.body}');
    }
  },
);

