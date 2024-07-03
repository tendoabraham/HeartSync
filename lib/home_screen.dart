import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  HomeScreen({required this.userData});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  String? _pairedUserName;
  String? _pairedUserId;
  late FirebaseMessaging _messaging;
  TextEditingController _pairEmailController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkForPairing();
    _setupFirebaseMessaging();
  }


  void _setupFirebaseMessaging() async {
    _messaging = FirebaseMessaging.instance;

    // Request permissions for iOS
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // Get the token each time the application loads
      String? token = await _messaging.getToken();
      print("FCM Token: $token");

      // Save the token to Firestore
      // Assuming you have a user ID available
      String userId =  widget.userData['uid']; // Replace with actual user ID
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': token,
      });

      // Listen for token updates
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        FirebaseFirestore.instance.collection('users').doc(userId).update({
          'fcmToken': newToken,
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _checkForPairing() async {
    try {
      QuerySnapshot pairings = await FirebaseFirestore.instance
          .collection('pairings')
          .where('user1', isEqualTo: widget.userData['uid'])
          .get();

      if (pairings.docs.isEmpty) {
        pairings = await FirebaseFirestore.instance
            .collection('pairings')
            .where('user2', isEqualTo: widget.userData['uid'])
            .get();
      }

      if (pairings.docs.isNotEmpty) {
        var pairingDoc = pairings.docs.first.data() as Map<String, dynamic>;
        String pairedUserId = pairingDoc['user1'] == widget.userData['uid'] ? pairingDoc['user2'] : pairingDoc['user1'];

        DocumentSnapshot pairedUserDoc = await FirebaseFirestore.instance.collection('users').doc(pairedUserId).get();
        var pairedUserData = pairedUserDoc.data() as Map<String, dynamic>;

        setState(() {
          _pairedUserId = pairedUserId;
          _pairedUserName = pairedUserData['name'];
        });
      }
    } catch (e) {
      print('Error checking for pairing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.exit_to_app),
      //       onPressed: () async {
      //         await _authService.signOut();
      //         Navigator.of(context).pushReplacement(
      //           MaterialPageRoute(builder: (context) => LoginScreen()),
      //         );
      //       },
      //     )
      //   ],
      // ),
      body: Stack(
          fit: StackFit.expand,
          children: [
      ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Image.asset(
        'assets/images/bg4.jpg',
        fit: BoxFit.cover,
      ),
    ),
    SafeArea(
    child: SingleChildScrollView(
      child:  Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 32),
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/bh2.png',
                                  height: 30,
                                  width: 30,
                                ),
                                const Text("Logout",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                )
                              ],
                            )
                        ))),
              ],
            ),
            Text('Welcome, ${widget.userData['name']}'),
            Text('UserID, ${widget.userData['uid']}'),
            Text('Email: ${widget.userData['email']}'),
            Text('Phone: ${widget.userData['phone']}'),
            SizedBox(
              height: 300,
            ),
            if (_pairedUserName == null) ...[
              TextField(
                style: const TextStyle(
                    color: Colors.white
                ),
                controller: _pairEmailController,
                decoration: InputDecoration(labelText: 'Pair with your love (email)',
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
                  ),),
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: isLoading?
                  const SpinKitPumpingHeart(color: Colors.red,)
                      :
                  ElevatedButton(
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
                      var result = await _authService.pairWithUser(
                        widget.userData['uid'],
                        _pairEmailController.text,
                      );
                      setState(() {
                        isLoading = false;
                      });
                      if (result['success']) {
                        var pairedUserDoc = await FirebaseFirestore.instance.collection('users').doc(result['pairedUserId']).get();
                        var pairedUserData = pairedUserDoc.data() as Map<String, dynamic>;

                        setState(() {
                          _pairedUserId = result['pairedUserId'];
                          _pairedUserName = pairedUserData['name'];
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['error'])),
                        );
                      }
                    },
                    child: const Text('Pair',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        )),
                  )),
            ] else ...[
              ElevatedButton(
                onPressed: () {
                  if (_pairedUserId != null) {
                    _authService.sendNotification(_pairedUserId!, 'Baby...' ,'Hello from your pair!');
                  }
                },
                child: Text('Send Notification to $_pairedUserName'),
              ),
            ],
          ],
        ),
      ),
    ),
    )])
    );
  }

}
