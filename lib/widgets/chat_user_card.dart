import 'package:cached_network_image/cached_network_image.dart';
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

        //leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
        //leading: CircleAvatar(child: Icon(CupertinoIcons.person),),

        leading: ClipRRect(
          borderRadius: BorderRadius.circular(mq.height * .3),
          child: CachedNetworkImage(
            width: mq.height * .055,
            height: mq.height * .055,
          
          imageUrl: widget.user.image,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person)),
               ),
        ),
        //user name
        title: Text(widget.user.name),

        //last message
        subtitle: Text(widget.user.about, maxLines: 1,),

        //last message time
        trailing: Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: Colors.greenAccent.shade400,
            borderRadius: BorderRadius.circular(10)
          ),
     
        )
        
        //Text('12:00 PM', style: TextStyle(color: Colors.black54),),
      )),
    );
  }
}