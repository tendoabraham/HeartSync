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
      body: SafeArea(
        child: SingleChildScrollView(
          child:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 25.0, // Set the desired size of the profile picture
                        height: 25.0,
                        // decoration: BoxDecoration(
                        //   shape: BoxShape.circle,
                        //   border: Border.all(color: Colors.black, width: 4.0), // White ring
                        // ),
                        child: Image.asset(
                          'assets/images/menu.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Spacer(),

                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Text("Good Morning,",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "Itim",
                      fontWeight: FontWeight.normal
                  ),),
                Text(widget.userData['name'],
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Itim"
                  ),),
                // const SizedBox(
                //   height: 16,
                // ),
                // Container(
                //   height: 2,
                //   width: double.infinity,
                //   color: Colors.black,
                // ),
                // Padding(padding: const EdgeInsets.only(left: 24),
                //   child: Text("Pair to Continue",
                //     style: const TextStyle(
                //         color: Colors.black,
                //         fontSize: 24,
                //         fontWeight: FontWeight.bold
                //     ),),),
                // const Padding(padding: EdgeInsets.only(left: 24),
                //   child: Text("Use form below to pair with your love",
                //     style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 16,
                //         fontWeight: FontWeight.normal
                //     ),),),
                // Text('UserID, ${widget.userData['uid']}'),
                // Text('Email: ${widget.userData['email']}'),
                // Text('Phone: ${widget.userData['phone']}'),
                if (_pairedUserName == null) ...[
                  // Container(
                  //   width: double.infinity, // Make the container take the full width
                  //   margin: const EdgeInsets.all(0),
                  //   child: Card(
                  //     color: Colors.black.withOpacity(0.7),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(15.0),
                  //     ),
                  //     margin: const EdgeInsets.all(20.0),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(20.0),
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const SizedBox(
                  //             height: 16,
                  //           ),
                  //           GestureDetector(
                  //               onTap: () {
                  //                 Navigator.pop(context);
                  //               },
                  //               child: Align(
                  //                   alignment: Alignment.center,
                  //                   child: Padding(
                  //                     padding: EdgeInsets.zero,
                  //                     child: Container(
                  //                       width: 60.0, // Set the desired size of the profile picture
                  //                       height: 60.0,
                  //                       decoration: BoxDecoration(
                  //                         shape: BoxShape.circle,
                  //                         border: Border.all(color: Colors.black, width: 1.0), // White ring
                  //                       ),
                  //                       child: Padding(
                  //                         padding: const EdgeInsets.all(4),
                  //                         child: ClipOval(
                  //                           child: Image.asset(
                  //                             'assets/images/user.png',
                  //                             fit: BoxFit.cover,
                  //                             errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  //                               return const Icon(
                  //                                 Icons.person,
                  //                                 size: 30,
                  //                                 color: Colors.grey,
                  //                               );
                  //                             },
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     // child: Column(
                  //                     //   children: [
                  //                     //     Image.asset(
                  //                     //       'assets/images/bh2.png',
                  //                     //       height: 30,
                  //                     //       width: 30,
                  //                     //     ),
                  //                     //     const Text("Logout",
                  //                     //       style: TextStyle(
                  //                     //           color: Colors.black
                  //                     //       ),
                  //                     //     )
                  //                     //   ],
                  //                     // )
                  //                   ))),
                  //           // Padding(padding: const EdgeInsets.only(left: 24),
                  //           //   child: Text(widget.userData['name'],
                  //           //     style: const TextStyle(
                  //           //         color: Colors.black,
                  //           //         fontSize: 24,
                  //           //         fontWeight: FontWeight.bold
                  //           //     ),),),
                  //           const SizedBox(
                  //             height: 24,
                  //           ),
                  //           Text("You are currently not paired \nwith anyone!",
                  //             style: const TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 24,
                  //                 fontFamily: "Itim",
                  //                 fontWeight: FontWeight.bold
                  //             ),),
                  //           const SizedBox(
                  //             height: 8,
                  //           ),
                  //           Text("Enter your love's Username / E-mail",
                  //             style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 16,
                  //                 fontFamily: "Itim",
                  //                 fontWeight: FontWeight.normal
                  //             ),),
                  //           SizedBox(
                  //             height: 24,
                  //           ),
                  //           TextField(
                  //             style: const TextStyle(
                  //                 color: Colors.black
                  //             ),
                  //             controller: _pairEmailController,
                  //             decoration: InputDecoration(labelText: 'Username / E-mail',
                  //               labelStyle: const TextStyle(
                  //                 fontFamily: "Itim",
                  //                 color: Colors.black,
                  //               ),
                  //               floatingLabelBehavior: FloatingLabelBehavior.auto,
                  //               border: OutlineInputBorder(
                  //                 borderSide: const BorderSide(color: Colors.black),
                  //                 borderRadius: BorderRadius.circular(10.0),
                  //               ),
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderSide: const BorderSide(color: Colors.black),
                  //                 borderRadius: BorderRadius.circular(10.0),
                  //               ),),
                  //           ),
                  //           const SizedBox(height: 20),
                  //           SizedBox(
                  //               width: MediaQuery.of(context).size.width,
                  //               height: 50,
                  //               child: isLoading?
                  //               const SpinKitPumpingHeart(color: Colors.red,)
                  //                   :
                  //               ElevatedButton(
                  //                 style: ButtonStyle(
                  //                   shape: MaterialStateProperty.all<
                  //                       RoundedRectangleBorder>(
                  //                     const RoundedRectangleBorder(
                  //                       borderRadius: BorderRadius.zero,
                  //                       side: BorderSide(
                  //                           color: Colors.red),
                  //                     ),
                  //                   ),
                  //                   backgroundColor:
                  //                   MaterialStateProperty.all(
                  //                       Colors.red
                  //                   ),
                  //                 ),
                  //                 onPressed: () async {
                  //                   setState(() {
                  //                     isLoading = true;
                  //                   });
                  //                   var result = await _authService.pairWithUser(
                  //                     widget.userData['uid'],
                  //                     _pairEmailController.text,
                  //                   );
                  //                   setState(() {
                  //                     isLoading = false;
                  //                   });
                  //                   if (result['success']) {
                  //                     var pairedUserDoc = await FirebaseFirestore.instance.collection('users').doc(result['pairedUserId']).get();
                  //                     var pairedUserData = pairedUserDoc.data() as Map<String, dynamic>;
                  //
                  //                     setState(() {
                  //                       _pairedUserId = result['pairedUserId'];
                  //                       _pairedUserName = pairedUserData['name'];
                  //                     });
                  //                   } else {
                  //                     ScaffoldMessenger.of(context).showSnackBar(
                  //                       SnackBar(content: Text(result['error'])),
                  //                     );
                  //                   }
                  //                 },
                  //                 child: const Text('Pair',
                  //                     style: TextStyle(
                  //                         fontSize: 18,
                  //                         fontFamily: "Itim",
                  //                         color: Colors.black
                  //                     )),
                  //               )),
                  //           const SizedBox(height: 28),
                  //           Row(
                  //             children: [
                  //               Expanded(
                  //                 child: Container(
                  //                   height: 1,
                  //                   color: Colors.grey,
                  //                 ),
                  //               ),
                  //               Text('  OR  ',
                  //                 style: TextStyle(
                  //                     color: Colors.black,
                  //                     fontFamily: "Itim"
                  //                 ),),
                  //               Expanded(
                  //                 child: Container(
                  //                   height: 1,
                  //                   color: Colors.grey,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           SizedBox(
                  //             height: 4,
                  //           ),
                  //           Align(
                  //             alignment: Alignment.center,
                  //             child: TextButton(
                  //               onPressed: () {
                  //                 // Navigator.of(context).pushReplacement(
                  //                 //   MaterialPageRoute(builder: (context) => SignUp()),
                  //                 // );
                  //               },
                  //               child: const Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Text('Pair Using ',
                  //                     style: TextStyle(
                  //                         color: Colors.black,
                  //                         fontFamily: "Itim",
                  //                         fontSize: 16
                  //                     ),),
                  //                   Text('Generated Link',
                  //                     style: TextStyle(
                  //                         color: Colors.red,
                  //                         fontFamily: "Itim",
                  //                         fontSize: 16
                  //                     ),),
                  //                 ],
                  //               ),
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: Container(
                                width: 100.0, // Set the desired size of the profile picture
                                height: 100.0,
                                // decoration: BoxDecoration(
                                //   shape: BoxShape.circle,
                                //   border: Border.all(color: Colors.black, width: 1.0), // White ring
                                // ),
                                child: Image.asset(
                                  'assets/images/lonely.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              // child: Column(
                              //   children: [
                              //     Image.asset(
                              //       'assets/images/bh2.png',
                              //       height: 30,
                              //       width: 30,
                              //     ),
                              //     const Text("Logout",
                              //       style: TextStyle(
                              //           color: Colors.black
                              //       ),
                              //     )
                              //   ],
                              // )
                            )),
                        // GestureDetector(
                        //     onTap: () {
                        //       // Navigator.pop(context);
                        //     },
                        //     child: Align(
                        //         alignment: Alignment.center,
                        //         child: Padding(
                        //           padding: EdgeInsets.zero,
                        //           child: Container(
                        //             width: 100.0, // Set the desired size of the profile picture
                        //             height: 100.0,
                        //             decoration: BoxDecoration(
                        //               shape: BoxShape.circle,
                        //               border: Border.all(color: Colors.black, width: 1.0), // White ring
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.all(12),
                        //               child: ClipOval(
                        //                 child: Image.asset(
                        //                   'assets/images/user.png',
                        //                   fit: BoxFit.cover,
                        //                   errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        //                     return const Icon(
                        //                       Icons.person,
                        //                       size: 30,
                        //                       color: Colors.grey,
                        //                     );
                        //                   },
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           // child: Column(
                        //           //   children: [
                        //           //     Image.asset(
                        //           //       'assets/images/bh2.png',
                        //           //       height: 30,
                        //           //       width: 30,
                        //           //     ),
                        //           //     const Text("Logout",
                        //           //       style: TextStyle(
                        //           //           color: Colors.black
                        //           //       ),
                        //           //     )
                        //           //   ],
                        //           // )
                        //         ))),
                        // Padding(padding: const EdgeInsets.only(left: 24),
                        //   child: Text(widget.userData['name'],
                        //     style: const TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 24,
                        //         fontWeight: FontWeight.bold
                        //     ),),),
                        const SizedBox(
                          height: 32,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("You are currently not paired \nwith anyone!",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: "Itim",
                                fontWeight: FontWeight.bold
                            ),),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Enter your love's Username / E-mail",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "Itim",
                              fontWeight: FontWeight.normal
                          ),),),
                        SizedBox(
                          height: 16,
                        ),
                        TextField(
                          style: const TextStyle(
                              color: Colors.black
                          ),
                          controller: _pairEmailController,
                          decoration: InputDecoration(labelText: 'Username / E-mail',
                            labelStyle: const TextStyle(
                              fontFamily: "Itim",
                              color: Colors.black,
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(8),
                              child: Image.asset(
                                'assets/images/users.png',
                                fit: BoxFit.cover,
                                height: 2,
                                width: 2,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),),
                        ),
                        const SizedBox(height: 16),
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
                                      fontFamily: "Itim",
                                      color: Colors.white
                                  )),
                            )),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ),
                            Text('  OR  ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Itim"
                              ),),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              // Navigator.of(context).pushReplacement(
                              //   MaterialPageRoute(builder: (context) => SignUp()),
                              // );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Pair Using ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Itim",
                                      fontSize: 16
                                  ),),
                                Text('Generated Link',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: "Itim",
                                      fontSize: 16
                                  ),),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                  // TextField(
                  //   style: const TextStyle(
                  //       color: Colors.black
                  //   ),
                  //   controller: _pairEmailController,
                  //   decoration: InputDecoration(labelText: 'Pair with your love (email)',
                  //     labelStyle: const TextStyle(
                  //       color: Colors.black,
                  //     ),
                  //     floatingLabelBehavior: FloatingLabelBehavior.auto,
                  //     border: OutlineInputBorder(
                  //       borderSide: const BorderSide(color: Colors.black),
                  //       borderRadius: BorderRadius.circular(10.0),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: const BorderSide(color: Colors.black),
                  //       borderRadius: BorderRadius.circular(10.0),
                  //     ),),
                  // ),
                  // const SizedBox(height: 20),
                  // SizedBox(
                  //     width: MediaQuery.of(context).size.width,
                  //     height: 50,
                  //     child: isLoading?
                  //     const SpinKitPumpingHeart(color: Colors.red,)
                  //         :
                  //     ElevatedButton(
                  //       style: ButtonStyle(
                  //         shape: MaterialStateProperty.all<
                  //             RoundedRectangleBorder>(
                  //           const RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.zero,
                  //             side: BorderSide(
                  //                 color: Colors.red),
                  //           ),
                  //         ),
                  //         backgroundColor:
                  //         MaterialStateProperty.all(
                  //             Colors.red
                  //         ),
                  //       ),
                  //       onPressed: () async {
                  //         setState(() {
                  //           isLoading = true;
                  //         });
                  //         var result = await _authService.pairWithUser(
                  //           widget.userData['uid'],
                  //           _pairEmailController.text,
                  //         );
                  //         setState(() {
                  //           isLoading = false;
                  //         });
                  //         if (result['success']) {
                  //           var pairedUserDoc = await FirebaseFirestore.instance.collection('users').doc(result['pairedUserId']).get();
                  //           var pairedUserData = pairedUserDoc.data() as Map<String, dynamic>;
                  //
                  //           setState(() {
                  //             _pairedUserId = result['pairedUserId'];
                  //             _pairedUserName = pairedUserData['name'];
                  //           });
                  //         } else {
                  //           ScaffoldMessenger.of(context).showSnackBar(
                  //             SnackBar(content: Text(result['error'])),
                  //           );
                  //         }
                  //       },
                  //       child: const Text('Pair',
                  //           style: TextStyle(
                  //               fontSize: 18,
                  //               color: Colors.black
                  //           )),
                  //     )),
                ] else ...[
                  Row(
                    children: [
                      Column(
                        children: [
                          Card(
                              color: Colors.black.withOpacity(0.7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              margin: const EdgeInsets.all(20.0),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    const Text('Pair Using ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Itim",
                                          fontSize: 16
                                      ),),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.zero,
                                          child: Container(
                                            width: 30.0, // Set the desired size of the profile picture
                                            height: 30.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.black, width: 1.0), // White ring
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: ClipOval(
                                                child: Image.asset(
                                                  'assets/images/love.png',
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                    return const Icon(
                                                      Icons.person,
                                                      size: 30,
                                                      color: Colors.grey,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                  ],),)
                          )
                        ],
                      ),
                    ],),
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
      )
    );
  }

}

class ModeCard extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;

  ModeCard({required this.color, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                icon,
                color: Colors.black,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
