import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUpWithEmailPassword(String email, String password, String name, String phone, String pic) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(user?.uid).set({
        'name': name,
        'phone': phone,
        'email': email,
        'userPic': pic
      });

      return null; // No error
    } on FirebaseAuthException catch (e) {
      return e.message; // Return the error message
    } catch (e) {
      return 'An unknown error occurred'; // Handle other errors
    }
  }


  // Future<Map<String, dynamic>> signInWithEmailPassword(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     User? user = userCredential.user;
  //
  //     if (user != null) {
  //       DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
  //       if (userDoc.exists) {
  //         var userData = userDoc.data() as Map<String, dynamic>;
  //         userData['uid'] = user.uid;
  //
  //         // Get and save FCM token
  //         String? token = await FirebaseMessaging.instance.getToken();
  //         await _firestore.collection('users').doc(user.uid).update({
  //           'fcmToken': token,
  //         });
  //
  //         return {
  //           'success': true,
  //           'userData': userData,
  //         };
  //       } else {
  //         return {
  //           'success': false,
  //           'error': 'User data not found',
  //         };
  //       }
  //     } else {
  //       return {
  //         'success': false,
  //         'error': 'User authentication failed',
  //       };
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     return {
  //       'success': false,
  //       'error': e.message,
  //     };
  //   } catch (e) {
  //     return {
  //       'success': false,
  //       'error': 'An unknown error occurred',
  //     };
  //   }
  // }

  // Future<Map<String, dynamic>> signInWithEmailPassword(String email, String password) async {
  //   try {
  //     print('Attempting to sign in with email: $email');
  //
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     User? user = userCredential.user;
  //
  //     print('User signed in successfully with UID: ${user?.uid}');
  //
  //     if (user != null) {
  //       DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
  //       print('User document fetched: ${userDoc.exists}');
  //
  //       if (userDoc.exists) {
  //         var userData = userDoc.data() as Map<String, dynamic>;
  //         userData['uid'] = user.uid; // Add the document ID to userData
  //
  //         // Get and save FCM token
  //         String? token = await FirebaseMessaging.instance.getToken();
  //         print('FCM token fetched: $token');
  //
  //         if (token != null) {
  //           await _firestore.collection('users').doc(user.uid).update({
  //             'fcmToken': token,
  //           });
  //         }
  //
  //         return {
  //           'success': true,
  //           'userData': userData,
  //         };
  //       } else {
  //         return {
  //           'success': false,
  //           'error': 'User data not found',
  //         };
  //       }
  //     } else {
  //       return {
  //         'success': false,
  //         'error': 'User authentication failed',
  //       };
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     print('FirebaseAuthException: ${e.message}');
  //     return {
  //       'success': false,
  //       'error': e.message,
  //     };
  //   } catch (e) {
  //     print('Exception: $e');
  //     return {
  //       'success': false,
  //       'error': 'An unknown error occurred',
  //     };
  //   }
  // }


  // Future<Map<String, dynamic>> signInWithEmailPassword(String email, String password) async {
  //   try {
  //     print('Attempting to sign in with email: $email');
  //
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     User? user = userCredential.user;
  //
  //     print('User signed in successfully with UID: ${user?.uid}');
  //
  //     if (user != null) {
  //       DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
  //       print('User document fetched: ${userDoc.exists}');
  //
  //       if (userDoc.exists) {
  //         var userData = userDoc.data() as Map<String, dynamic>;
  //         userData['uid'] = user.uid; // Add the document ID to userData
  //
  //         // Get and save FCM token
  //         String? token = await FirebaseMessaging.instance.getToken();
  //         print('FCM token fetched: $token');
  //
  //         if (token != null) {
  //           await _firestore.collection('users').doc(user.uid).update({
  //             'fcmToken': token,
  //           });
  //         }
  //
  //         return {
  //           'success': true,
  //           'userData': userData,
  //         };
  //       } else {
  //         return {
  //           'success': false,
  //           'error': 'User data not found',
  //         };
  //       }
  //     } else {
  //       return {
  //         'success': false,
  //         'error': 'User authentication failed',
  //       };
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     print('FirebaseAuthException: ${e.message}');
  //     return {
  //       'success': false,
  //       'error': e.message,
  //     };
  //   } catch (e) {
  //     print('Exception: $e');
  //     return {
  //       'success': false,
  //       'error': 'An unknown error occurred',
  //     };
  //   }
  // }

  Future<Map<String, dynamic>> signInWithEmailPassword(String email, String password) async {
    try {
      print('Attempting to sign in with email: $email');

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      print('User signed in successfully with UID: ${user?.uid}');

      if (user != null) {
        DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
        DocumentSnapshot userDoc = await userDocRef.get();
        print('User document fetched: ${userDoc.exists}');

        if (!userDoc.exists) {
          // If the user document doesn't exist, create it
          await userDocRef.set({
            'email': user.email,
            // Add other necessary fields here if needed
          });
        }

        // Get and save FCM token
        String? token = await FirebaseMessaging.instance.getToken();
        print('FCM token fetched: $token');

        if (token != null) {
          await userDocRef.update({
            'fcmToken': token,
          });
        }

        var userData = (await userDocRef.get()).data() as Map<String, dynamic>; // Fetch the updated document
        userData['uid'] = user.uid; // Add the document ID to userData

        return {
          'success': true,
          'userData': userData,
        };
      } else {
        return {
          'success': false,
          'error': 'User authentication failed',
        };
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      return {
        'success': false,
        'error': e.message,
      };
    } catch (e) {
      print('Exception: $e');
      return {
        'success': false,
        'error': 'An unknown error occurred',
      };
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>> pairWithUser(String currentUserId, String email) async {
    try {
      // Find the user by email
      QuerySnapshot querySnapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isEmpty) {
        return {
          'success': false,
          'error': 'User not found',
        };
      }

      DocumentSnapshot userDoc = querySnapshot.docs.first;
      String pairedUserId = userDoc.id;

      // Add a new document in the 'pairings' collection
      await _firestore.collection('pairings').add({
        'user1': currentUserId,
        'user2': pairedUserId,
      });

      return {
        'success': true,
        'pairedUserId': pairedUserId,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An unknown error occurred',
      };
    }
  }

  // Future<void> sendNotification(String pairedUserId, String message) async {
  //   try {
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(pairedUserId).get();
  //     if (userDoc.exists) {
  //       String? token = userDoc['fcmToken'];
  //       if (token != null) {
  //         // Send the notification using the FCM token
  //         await FirebaseMessaging.instance.sendMessage(
  //           to: token,
  //           data: {
  //             'message': message,
  //           },
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     print('Error sending notification: $e');
  //   }
  // }

  // Future<void> sendNotification(String recipientUid, String title, String body) async {
  //   try {
  //     DocumentSnapshot recipientDoc = await _firestore.collection('users').doc(recipientUid).get();
  //
  //     if (!recipientDoc.exists) {
  //       throw Exception('Recipient user document does not exist');
  //     }
  //
  //     var recipientData = recipientDoc.data() as Map<String, dynamic>;
  //     if (recipientData.containsKey('fcmToken')) {
  //       String fcmToken = recipientData['fcmToken'];
  //
  //       // Send the notification
  //       await http.post(
  //         Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           'Authorization': 'key=YOUR_SERVER_KEY', // Replace with your FCM server key
  //         },
  //         body: jsonEncode(<String, dynamic>{
  //           'to': fcmToken,
  //           'notification': <String, dynamic>{
  //             'title': title,
  //             'body': body,
  //           },
  //         }),
  //       );
  //       print('Notification sent successfully');
  //     } else {
  //       print('Error sending notification: fcmToken does not exist');
  //     }
  //   } catch (e) {
  //     print('Error sending notification: $e');
  //   }
  // }

  Future<void> sendNotification(String recipientUid, String title, String body) async {
    try {
      DocumentSnapshot recipientDoc = await FirebaseFirestore.instance.collection('users').doc(recipientUid).get();

      if (!recipientDoc.exists) {
        throw Exception('Recipient user document does not exist');
      }

      var recipientData = recipientDoc.data() as Map<String, dynamic>;
      if (recipientData.containsKey('fcmToken')) {
        String fcmToken = recipientData['fcmToken'];

        // Send the notification
        var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=YOUR_SERVER_KEY', // Replace with your FCM server key
          },
          body: jsonEncode(<String, dynamic>{
            'to': fcmToken,
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
            },
          }),
        );

        if (response.statusCode == 200) {
          print('Notification sent successfully');
        } else {
          print('Failed to send notification: ${response.body}');
        }
      } else {
        print('Error sending notification: fcmToken does not exist');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
