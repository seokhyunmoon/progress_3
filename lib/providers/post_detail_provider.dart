import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile2/models/post_detail.dart'; // Import your PostDetail model

final postDetailProvider =
    FutureProvider.family<PostDetail, int>((ref, postId) async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/posts/$postId'));
  if (response.statusCode == 200) {
    return PostDetail.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post details');
  }
});
