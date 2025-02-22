import 'dart:developer';

import 'package:firebase_chat_app/api/apis.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/models/chat_user.dart';
import 'package:firebase_chat_app/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<ChatUserModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text('We chat'),
        actions: [
          //search user button
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          //more features buton
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),

      //floating button to add new user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: Icon(Icons.add_comment_rounded),
        ),
      ),

      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());

            // if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
             

              final data = snapshot.data?.docs;
              
              list = data?.map((e)=> ChatUserModel.fromJson(e.data())).toList() ?? [];


              if (list.isNotEmpty){
                return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: mq.height * .01),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUserCard(user: list[index],);
                },
              );
              }else{
                return Center(child: Text('No connections found!', style: TextStyle(fontSize: 20),));
              }
          }
        },
      ),
    );
  }
}
