import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:irlandes_app/main.dart';
import 'package:irlandes_app/ui/page/notifications/notification_screen.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

}

class FirebaseApi {
  final _firebaseMessaging=FirebaseMessaging.instance;

  // void handleMessage(RemoteMessage? message){
  //   if (message==null) return;
  //   navigatorKey.currentState?.pushNamed(
  //     //NotificationScreen.route,
  //     '/notification_screen',
  //     arguments:message,
  //   );
  // }

  Future initPushNotifications() async{
    await FirebaseMessaging.instance
    .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    //FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken= await _firebaseMessaging.getToken();
    print('Token: $FCMToken');
    initPushNotifications();
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

Future<String> getUserToken() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken= await _firebaseMessaging.getToken();
    print('Token: $FCMToken');
    return FCMToken.toString();
  }
}
