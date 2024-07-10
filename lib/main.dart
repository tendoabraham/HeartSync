import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heart_sync/splash_screen.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyDOTv5sruma58_8ZGDie0t4-YT6TLW0PiU',
    appId: '1:1021941044645:android:354f9757c95b182bfe844c',
    messagingSenderId: '1021941044645',
    projectId: 'heart-sync-14536',
    storageBucket: 'heart-sync-14536.appspot.com',
  ));

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Make the status bar transparent.
    statusBarIconBrightness: Brightness.dark, // Dark icons for light background.
    statusBarBrightness: Brightness.light, // For iOS devices.
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SplashScreen(),
    );
  }
}
