import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/api/apis.dart';
import 'package:firebase_chat_app/helper/dialogs.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), (){
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick(){
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);
      
      if(user!=null){
      log('\nuser: ${user.user}');
      log('\nuserAdditionalUserInfo: ${user.additionalUserInfo}');

      if(( await APIs.userExist())){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));

      }else{
        APIs.createUser().then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));


        });
      }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
  try{
    await InternetAddress.lookup('google.com');
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await APIs.auth.signInWithCredential(credential);

  }catch(e){
     log('\n_signInWithGoogle: $e');
     Dialogs.showSnackBar(context, 'Something went wrong (Check internet)');
     return null;

  }
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
          AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5 ,
            width: mq.width * .5,
            duration: Duration(seconds: 1),
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
              onPressed: (){
                _handleGoogleBtnClick();
                
              }, icon: Image.asset( 'assets/images/google.png', height: mq.height * .03,),
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