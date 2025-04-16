import 'package:firebase_chat_app/api/firebase_messenger.dart';
import 'package:firebase_chat_app/screens/auth/login_screen.dart';
import 'package:firebase_chat_app/screens/home_screen.dart';
import 'package:firebase_chat_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';


//glocal object for accessing device screen size
late Size mq;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  //enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await SharedPreferences.getInstance(); 

  // final deviceToken = 'dbawzzkVSByzJlxNAkdAwM:APA91bEMOFA6mfQYQoroxJFMCtsFWjXZVKqoEC8cFIVGIC7vpvkWbBLcsrtjgHc8rYI_rmDuoBJDwo7e-hWS_2kzJH99trFx6qgXJiSK2NrTIer2q_mlwwY';
  
  // final messenger = FirebaseMessenger(deviceToken);

  // final notificationTitle = 'Testing2 ';
  // final notificationBody = 'This notification was sent using Dart and the provided Service Account key.';

  // final customData = {
  //   'dart_library': 'http',
  //   'timestamp': DateTime.now().toIso8601String(),
  // };

  // await messenger.sendNotification(notificationTitle, notificationBody, customData);
  

  //for setting orientation to potriat only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((value){
    _initializeFirebase();
    runApp(const MyApp());
  });



}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      title: 'We Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
          centerTitle: true,
        elevation: 1,
        titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
      backgroundColor: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.black
        )
      ),
      home: SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

);


var result = await FlutterNotificationChannel().registerNotificationChannel(
    description: 'For Showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
    // visibility: NotificationVisibility.VISIBILITY_PUBLIC,
    // allowBubbles: true,
    // enableVibration: true,
    // enableSound: true,
    // showBadge: true,
);
print(result);
}