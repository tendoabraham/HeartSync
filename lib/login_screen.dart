import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:heart_sync/Auth/sign_up.dart';
import 'Auth/auth_service.dart';
import 'home.dart';
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
  bool isLoading = false;

  @override
  void dispose() {
    // Reset the status bar style to default when the widget is disposed.
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light, // For iOS devices.
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make the status bar transparent
        statusBarIconBrightness: Brightness.light, // For iOS devices
    ),
      child: Scaffold(
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    const Text(
                      'Hello Love',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "Macondo", color: Colors.white),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const Text(
                      'Login to your account',
                      style: TextStyle(fontWeight: FontWeight.normal, fontFamily: "Macondo", color: Colors.white),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.22,
                    ),
                    TextField(
                      style: const TextStyle(
                          fontFamily: "Macondo",
                          color: Colors.white
                      ),
                      cursorColor: Colors.white,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: const TextStyle(
                          fontFamily: "Macondo",
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
                          fontFamily: "Macondo",
                          color: Colors.white
                      ),
                      cursorColor: Colors.white,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          fontFamily: "Macondo",
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
                              fontFamily: "Macondo",
                              color: Colors.white
                          ),),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: isLoading?
                      SpinKitPumpingHeart(color: Colors.red,)
                          : ElevatedButton(
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
                          setState(() {
                            isLoading = true;
                          });

                          if (_emailController.text.isEmpty) {
                            _showCustomSnackBar(context, 'Please enter your E-mail Address');
                          }else if(_passwordController.text.isEmpty){
                            _showCustomSnackBar(context, 'Please enter your Password');
                          }else{
                            var result = await _authService.signInWithEmailPassword(
                              _emailController.text,
                              _passwordController.text,
                            );
                            setState(() {
                              isLoading = false;
                            });
                            if (result['success']) {
                              var userData = result['userData'];
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen(userData: userData)),
                              );
                              // Navigator.of(context).pushReplacement(
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           Home()),
                              // );
                            } else {
                              _showCustomSnackBar(context, result['error']);
                            }
                          }

                        },
                        child: const Text('Login',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Macondo",
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
                                  fontFamily: "Macondo",
                                  color: Colors.white
                              ),),
                            Text('Sign Up',
                              style: TextStyle(
                                  fontFamily: "Macondo",
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
    ),);
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