import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat_app/api/apis.dart';
import 'package:firebase_chat_app/helper/my_date_util.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/models/chat_user.dart';
import 'package:firebase_chat_app/models/message.dart';
import 'package:firebase_chat_app/screens/chat_screen.dart';
import 'package:firebase_chat_app/widgets/dialogs/show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(

       margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: 4,
            ),
            //color: Colors.blue.shade100,
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)),
          );
        },
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;

            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
      
            if (list.isNotEmpty) _message = list[0];
            
      
            return ListTile(
              //leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
              //leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
              leading: InkWell(
                onTap: () {
                  showDialog(context: context, builder: (_) => ProfileDialog(user: widget.user));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    width: mq.height * .055,
                    height: mq.height * .055,
                            
                    imageUrl: widget.user.image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) =>
                            CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),
              //user name
              title: Text(widget.user.name),
            
              //last message
              subtitle: Text(_message != null ?
              
                _message!.type == Type.image ? 'image' :
               _message!.msg : widget.user.about, maxLines: 1),
            
              //last message time
              trailing: _message == null ? null : 
              
              _message!.read.isEmpty && _message!.fromId != APIs.user.uid ?
              
              //show for unread message
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ) : 
              //message sent time
              Text(MyDateUtil.getLastMessageTime(context: context, time: _message!.sent), style: TextStyle(color: Colors.black54),),
            
              //Text('12:00 PM', style: TextStyle(color: Colors.black54),),
            );
          },
        ),
      ),
    );
  }
}
