

import 'dart:developer';
import 'package:firebase_chat_app/api/apis.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/screens/auth/login_screen.dart';
import 'package:firebase_chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), (){
      //exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      if(APIs.auth.currentUser != null){
        log('\nuser: ${APIs.auth.currentUser}');

        //navigate to home screen

             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeScreen()));


      }else{
        //navigate to login screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
      }

    //   //go to login screen
    //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
     mq = MediaQuery.of(context).size;
    return Scaffold(
      
      //app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
       title:  Text('Welcome To chat'),
   
      
      ),
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            right: mq.width * .25  ,
            width: mq.width * .5,
   
            child: Image.asset(
              'assets/images/chat.png'
            ),
          ),

          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: Text('Made in Nigeria by Demartechx', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black87, letterSpacing: .5),)
          )
        ],
      ),

    );
  }
}