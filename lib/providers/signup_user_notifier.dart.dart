import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final signupUserProvider =
    StateNotifierProvider<SignupUserNotifier, AsyncValue<void>>((ref) {
  return SignupUserNotifier();
});

class SignupUserNotifier extends StateNotifier<AsyncValue<void>> {
  SignupUserNotifier() : super(const AsyncValue.data(null));

  Future<void> signup(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (response.statusCode == 201) {
        // Assuming a status code of 201 means the user was successfully created
        state = const AsyncValue.data(null);
      } else {
        // If the server responds with a different status code, treat it as an error
        state = AsyncValue.error(
            'Failed to sign up. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // If the request throws an exception, treat it as an error state
      state = AsyncValue.error(e.toString());
    }
  }
}
