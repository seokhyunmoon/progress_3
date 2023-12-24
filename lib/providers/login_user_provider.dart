import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '/models/user.dart'; // Make sure the path to your User model is correct

final loginUserProvider =
    StateNotifierProvider<LoginNotifier, AsyncValue<User?>>((ref) {
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<AsyncValue<User?>> {
  LoginNotifier()
      : super(const AsyncValue.data(null)); // Initial state: no user logged in

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      // Replace with your actual endpoint and ensure the use of HTTPS
      final response = await http.post(
        Uri.parse('http://localhost:3000/users'), //원래는 login
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      switch (response.statusCode) {
        case 200: // OK
          final user = User.fromJson(json.decode(response.body));
          // Here you should also handle the storage of the auth token
          state = AsyncValue.data(user);
          break;
        case 401: // Unauthorized
          state = const AsyncValue.error('Invalid username or password');
          break;
        case 403: // Forbidden
          state = const AsyncValue.error('Account is disabled.');
          break;
        default:
          state = AsyncValue.error('Unexpected error: ${response.statusCode}');
          break;
      }
    } on Exception catch (e) {
      state = AsyncValue.error('An error occurred: $e');
    }
  }
}
