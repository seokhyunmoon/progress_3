import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/login_user_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginUserProvider);
    final loginNotifier = ref.read(loginUserProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: loginState.when(
          data: (_) {
            // If the state has user data, then login was successful
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/main');
            });
            return const Text('Login Successful, redirecting...');
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
      // If loading or error, show the form to allow user login
      floatingActionButton: loginState.maybeWhen(
        data: (_) => null, // If logged in, do not show the login button
        orElse: () => FloatingActionButton(
          onPressed: () => _showLoginDialog(context, loginNotifier),
          child: const Icon(Icons.login),
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context, LoginNotifier loginNotifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login'),
        content: LoginForm(loginNotifier: loginNotifier),
      ),
    );
  }
}

// LoginForm is a stateful widget to handle the text editing and form submission
class LoginForm extends StatefulWidget {
  final LoginNotifier loginNotifier;

  const LoginForm({Key? key, required this.loginNotifier}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Call the login method from the notifier
    await widget.loginNotifier.login(username, password);
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
          onPressed: _handleLogin,
          child: const Text('Login'),
        ),
      ],
    );
  }
}
