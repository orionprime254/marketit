import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:marketit/main.dart';

class FirebaseApi {
  //create instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  //function to initialize notification
  Future<void> initNotifications() async {
    //request permissio from user(will prompt)
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.subscribeToTopic('admin_notifications');
    //fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();
    //print token(normally youd send it to your server
    print('Token $fCMToken'); //
    //initializze further settings for psuh notifivations
    initPushNotifications();
  }

  //function to handle received messages
  void handleMessage(RemoteMessage? message) {
    //if message is null do nohing
    if (message == null) return;
    //navigate to new screen when message is received and user taps notifications
    navigatorKey.currentState
        ?.pushNamed('/notification_screen', arguments: message);
  }

  //function to initialize fpreground and background settinfgs
  Future initPushNotifications() async {
    //handle notificatipns if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    //attach event listeners fpr when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received: ${message.notification?.title}');
      // Handle foreground notifications here
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked: ${message.notification?.title}');
      // Handle notification tap here
    });
  }
  }


