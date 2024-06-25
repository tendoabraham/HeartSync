import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await _authService.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Welcome, ${widget.userData['name']}'),
            Text('UserID, ${widget.userData['uid']}'),
            Text('Email: ${widget.userData['email']}'),
            Text('Phone: ${widget.userData['phone']}'),
            if (_pairedUserName == null) ...[
              TextField(
                controller: _pairEmailController,
                decoration: InputDecoration(labelText: 'Pair with user (email)'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var result = await _authService.pairWithUser(
                    widget.userData['uid'],
                    _pairEmailController.text,
                  );

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
                child: Text('Pair'),
              ),
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
    );
  }
}
