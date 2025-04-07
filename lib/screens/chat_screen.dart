

import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat_app/api/apis.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/models/chat_user.dart';
import 'package:firebase_chat_app/models/message.dart';
import 'package:firebase_chat_app/widgets/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  //for storing all messages
  List<Message> _list = [];

  // for handling message text changes
  final _textController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, flexibleSpace: _appBar(),),
        backgroundColor: Color.fromARGB(255, 234, 248, 255),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
              stream: APIs.getAllMessages(widget.user),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    //return Center(child: CircularProgressIndicator());
                      
                  // if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                   
                    final data = snapshot.data?.docs;
                    //  print(jsonEncode(data![0].data()));

                     //_list = [];
                    
                    _list = data?.map((e)=> Message.fromJson(e.data())).toList() ?? [];
                    
                    //   final _list = [];

                    // _list.add(Message(toId: 'xyz', type: Type.text, msg: 'Hi!', read: '', fromId: APIs.user.uid, sent: '12:00 AM'));
                    // _list.add(Message(toId: APIs.user.uid, type: Type.text, msg: 'Hello', read: '', fromId: 'xyz', sent: '12:05 AM'));
                      
                    if (_list.isNotEmpty){
                      return ListView.builder(
                      itemCount: _list.length,
                      padding: EdgeInsets.only(top: mq.height * .01),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MessageCard(message: _list[index],);
                      },
                    );
                    }else{
                      return Center(child: Text('Say hi! 👋', style: TextStyle(fontSize: 20),));
                    }
                }
              },
                        ),
            ),
            _chatInput()
          ],
        ),
      ),
    );
  }

  Widget _appBar(){

    return InkWell(
      onTap: ()=> Navigator.pop(context),
      child: Row(
        children: [
          IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          )),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              width: mq.height * .04,
              height: mq.height * .04,
            
            imageUrl: widget.user.image,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person)),
                 ),
          ),
      
          SizedBox(width: 10,),
      
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name, style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),),
              Text('Last seen not available', style: TextStyle(fontSize: 13, color: Colors.black54),),
            ],
          ),
          
        ],
      ),
    );
  }

  Widget _chatInput(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
      
          //input field & button
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(children: [
                //emoji button
                IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: 26,
                    )),
              
                    Expanded(child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type Something...', hintStyle: TextStyle(color: Colors.blueAccent), border: InputBorder.none
                      ),
                    )),
              
                //pick image from gallery
                IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 26,
                    )),
              
                //take image from camera button
                IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                      size: 26,
                    )),

                    SizedBox(width: mq.width * .02,)
              ],),
            ),
          ),
          //send message button
          MaterialButton(onPressed: (){
            if(_textController.text.isNotEmpty){
              APIs.sendMessage(widget.user, _textController.text);
              _textController.text = '';
            }
          }, 
          minWidth: 0,
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
      
          shape: CircleBorder(),
          color: Colors.green,
          
          child: Icon(Icons.send, color: Colors.white, size: 28,),)
        
        ],
      ),
    );

  }
}