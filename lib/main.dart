import 'package:firebase_chat_app/screens/auth/login_screen.dart';
import 'package:firebase_chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

//glocal object for accessing device screen size
late Size mq;

void main() {
  runApp(const MyApp());
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
      home: LoginScreen(),
    );
  }
}
