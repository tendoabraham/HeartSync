import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:heart_sync/login_screen.dart';
import 'main.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    startAnimation();
  }

  @override
  void dispose() {
    // Re-enable system UI when disposing the widget
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  void startAnimation() async {
    // Delay for the animation duration
    await Future.delayed(2500.milliseconds);

    // Navigate to another widget (replace MyHomeWidget with your target widget)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make the status bar transparent
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/heartsync2.jpg",
              fit: BoxFit.cover,
            ),
            // Center(
            //   child: const Image(
            //     image: AssetImage("assets/images/heartsync.jpg"),
            //     width: 150,
            //     height: 150,
            //   ).animate(
            //     onPlay: (controller) => controller.repeat(), // loop
            //   ).shimmer(duration: 1500.ms),
            // ),
          ],
        ),
      ),
    );
  }
}