import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile2/models/post.dart';

final postsProvider =
    FutureProvider.family<List<Post>, int>((ref, categoryId) async {
  final response = await http
      .get(Uri.parse('http://localhost:3000/posts?categoryId=$categoryId'));
  if (response.statusCode == 200) {
    final List postsJson = json.decode(response.body) as List;
    return postsJson.map((json) => Post.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load posts');
  }
});
