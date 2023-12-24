// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile2/providers/signup_user_notifier.dart.dart';

class SignupPage extends ConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupState = ref.watch(signupUserProvider);
    final signupNotifier = ref.read(signupUserProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: signupState.when(
          data: (_) {
            // If the state has user data, then signup was successful
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
            return const Text('Signup Successful, redirecting...');
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
      // If loading or error, show the form to allow user signup
      floatingActionButton: signupState.maybeWhen(
        data: (_) => null, // If signed up, do not show the signup button
        orElse: () => FloatingActionButton(
          onPressed: () => _showSignupDialog(context, signupNotifier),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showSignupDialog(
      BuildContext context, SignupUserNotifier signupNotifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Up'),
        content: SignupForm(signupNotifier: signupNotifier),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final SignupUserNotifier signupNotifier;

  const SignupForm({super.key, required this.signupNotifier});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      await widget.signupNotifier.signup(username, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        ElevatedButton(
          onPressed: _handleSignup,
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
