import 'dart:developer';
import 'package:firebase_chat_app/api/apis.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/models/chat_user.dart';
import 'package:firebase_chat_app/screens/profile_screen.dart';
import 'package:firebase_chat_app/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    
    APIs.getSelfInfo();

        // WidgetsBinding.instance.addObserver(this);
    SystemChannels.lifecycle.setMessageHandler((message) async {

      if(message.toString().contains('resume')) APIs.updateActiveStatus(true);
      if(message.toString().contains('pause')) APIs.updateActiveStatus(false);

      //print('Message: $message');
      return Future.value(message);

    });

  //    SystemChannels.lifecycle.setMessageHandler((message) async {
  //   print('🔄 Lifecycle Event: $message'); // Prints to terminal
  //   return message;
  // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        // or else simple close current screen on back button click
        onWillPop: (){
          if(_isSearching){
            setState(() {
              
              _isSearching = !_isSearching;
            });
             return Future.value(false);
          }else{
               return Future.value(true);
          }
         
        },
        child: Scaffold(
          //app bar
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title: _isSearching ? TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText:  'Name, Email, ...'
              ),
              autofocus: true,
              style:  TextStyle(fontSize: 17, letterSpacing: 0.5),
              // when search text changes then updated the search list
              onChanged: (val) {
                _searchList.clear();
                for(var i in _list){
                    if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase()) ){
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
        
                }
              },
        
        
            ) : Text('We chat'),
            actions: [
              //search user button
              IconButton(onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),
        
              //more features buton
              IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=> ProfileScreen(user: APIs.me,)));
        
              }, icon: Icon(Icons.more_vert)),
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
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator());
        
                // if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                 
                  final data = snapshot.data?.docs;
                  
                  _list = data?.map((e)=> ChatUser.fromJson(e.data())).toList() ?? [];
        
        
                  if (_list.isNotEmpty){
                    return ListView.builder(
                    itemCount: _isSearching ? _searchList.length : _list.length,
                    padding: EdgeInsets.only(top: mq.height * .01),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatUserCard(user: _isSearching ? _searchList[index] : _list[index],);
                    },
                  );
                  }else{
                    return Center(child: Text('No connections found!', style: TextStyle(fontSize: 20),));
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
