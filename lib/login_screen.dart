import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heart_sync/Auth/sign_up.dart';
import 'Auth/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () async {
            //     var result = await _authService.signInWithEmailPassword(
            //       _emailController.text,
            //       _passwordController.text,
            //     );
            //
            //     if (result['success']) {
            //       var userData = result['userData'];
            //       Navigator.of(context).pushReplacement(
            //         MaterialPageRoute(builder: (context) => HomeScreen(userData: userData)),
            //       );
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(content: Text(result['error'])),
            //       );
            //     }
            //   },
            //   child: Text('Login'),
            // ),
            ElevatedButton(
              onPressed: () async {
                var result = await _authService.signInWithEmailPassword(
                  _emailController.text,
                  _passwordController.text,
                );

                if (result['success']) {
                  var userData = result['userData'];
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen(userData: userData)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result['error'])),
                  );
                }
              },
              child: Text('Login'),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
