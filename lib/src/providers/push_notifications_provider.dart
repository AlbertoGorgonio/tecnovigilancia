import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  initNotifications() {
    _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((token) {
      print('=====FCM Token');
      print(token);


    // fmj4FtTyRResM8xn-cy9Jr:APA91bHSWZM76nQveDIRSScTbMk3NVUPiBCNZjJBwYcd5HNRsiY0SPR8BZQluGSh7__DKEojdUtCes8deFTzLRUCJKw-bZEJ_Fbm7svIa929wkT_d4BloY9GIe1q0aAZOr8fM8TVIN9n
    });
    
  }
}
