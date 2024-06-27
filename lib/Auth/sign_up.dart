import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_screen.dart';
import '../login_screen.dart';
import 'auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  bool isObscured = true;
  bool isObscured2 = true;

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
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Create your new account',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.11,
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
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
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.white,
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
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
                    style: const TextStyle(color: Colors.white),
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
                    style: const TextStyle(color: Colors.white),
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
                        icon: Icon(isObscured
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        },
                      ),
                    ),
                    obscureText: isObscured,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
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
                        icon: Icon(isObscured2
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isObscured2 = !isObscured2;
                          });
                        },
                      ),
                    ),
                    obscureText: isObscured2,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(color: Colors.red),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () async {
                        if (_nameController.text.isEmpty) {
                          _showCustomSnackBar(context, 'Please enter your Name');
                        } else if(_phoneController.text.isEmpty){
                          _showCustomSnackBar(context, 'Please enter your Phone Number');
                        }else if(_emailController.text.isEmpty){
                          _showCustomSnackBar(context, 'Please enter your E-mail Address');
                        }else if(_passwordController.text.isEmpty){
                          _showCustomSnackBar(context, 'Please enter Password');
                        }else if(_confirmPasswordController.text.isEmpty){
                          _showCustomSnackBar(context, 'Please confirm Password');
                        }
                        else {
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            _showCustomSnackBar(context, 'Passwords do not match');
                            return;
                          }

                          String? errorMessage =
                              await _authService.signUpWithEmailPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                  _nameController.text,
                                  _phoneController.text,
                                  "image place holder");

                          if (errorMessage == null) {
                            // Sign up successful, navigate to the home screen
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          } else {
                            _showCustomSnackBar(context, errorMessage);
                          }
                        }
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Login',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
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
            style: TextStyle(fontSize: 18.0), // Adjust font size if needed
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
