import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {

  final ChatUserModel user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){},
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
        //color: Colors.blue.shade100,
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child:  ListTile(
        leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
        title: Text(widget.user.name),
        subtitle: Text(widget.user.about, maxLines: 1,),
        trailing: Text('12:00 PM', style: TextStyle(color: Colors.black54),),
      )),
    );
  }
}