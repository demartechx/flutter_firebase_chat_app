

import 'package:firebase_chat_app/main.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            left: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset(
              'assets/images/chat.png'
            ),
          ),

          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .07,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 151, 245, 43), shape: StadiumBorder(), elevation: 1),
              onPressed: (){}, icon: Image.asset( 'assets/images/google.png', height: mq.height * .03,),
            label: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  TextSpan(text: 'Sign In With '),
                  TextSpan(text: 'Google', style: TextStyle(fontWeight: FontWeight.w500)),
                ]
              ),
            ),),
          )
        ],
      ),

    );
  }
}