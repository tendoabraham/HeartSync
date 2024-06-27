import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heart_sync/Auth/sign_up.dart';
import 'Auth/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Image.asset(
              'assets/images/heartsync2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    const Text(
                      'Hello Love',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const Text(
                      'Login to your account',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.22,
                    ),
                    TextField(
                      style: const TextStyle(
                          color: Colors.white
                      ),
                      cursorColor: Colors.white,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      style: const TextStyle(
                          color: Colors.white
                      ),
                      cursorColor: Colors.white,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIconColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              isObscured = !isObscured;
                            });
                          },
                        ),
                      ),
                      obscureText: isObscured,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: const Text('Forgot Password?',
                          style: TextStyle(
                              color: Colors.white
                          ),),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(
                                  color: Colors.red),
                            ),
                          ),
                          backgroundColor:
                          MaterialStateProperty.all(
                              Colors.red
                          ),
                        ),
                        onPressed: () async {
                          if (_emailController.text.isEmpty) {
                            _showCustomSnackBar(context, 'Please enter your E-mail Address');
                          }else if(_passwordController.text.isEmpty){
                            _showCustomSnackBar(context, 'Please enter your Password');
                          }else{
                            var result = await _authService.signInWithEmailPassword(
                              _emailController.text,
                              _passwordController.text,
                            );

                            if (result['success']) {
                              var userData = result['userData'];
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen(userData: userData)),
                              );
                            } else {
                              _showCustomSnackBar(context, result['error']);
                            }
                          }

                        },
                        child: const Text('Login',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
                          ),),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Don\'t have an account? ',
                              style: TextStyle(
                                  color: Colors.white
                              ),),
                            Text('Sign Up',
                              style: TextStyle(
                                  color: Colors.red
                              ),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
        ],
      ),
    );
  }

  void _showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: 25.0, // Increase the height
          alignment: Alignment.center, // Center align the content
          child: Text(
            message,
            style: const TextStyle(fontSize: 18.0), // Adjust font size if needed
          ),
        ),
        behavior: SnackBarBehavior.fixed, // Use fixed behavior
        backgroundColor: Colors.teal[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
      ),
    );
  }

}