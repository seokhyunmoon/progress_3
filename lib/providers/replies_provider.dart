// replies_provider.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile2/models/reply.dart'; // Replace with correct path to your Reply model

final repliesProvider =
    FutureProvider.family<List<Reply>, int>((ref, postId) async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/replies?postId=$postId'));
  if (response.statusCode == 200) {
    final List repliesJson = json.decode(response.body) as List;
    return repliesJson.map((json) => Reply.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load replies');
  }
});
