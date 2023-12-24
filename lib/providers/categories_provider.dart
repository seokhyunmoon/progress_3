import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '/models/category.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/categories'));
  if (response.statusCode == 200) {
    final List categoriesJson = json.decode(response.body) as List;
    return categoriesJson.map((json) => Category.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
});
