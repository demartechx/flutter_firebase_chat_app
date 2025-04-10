import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat_app/api/apis.dart';
import 'package:firebase_chat_app/helper/my_date_util.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/models/message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
   MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId ? _greenMessage() : _blueMessage();
  }


  // sender or another user message
  Widget _blueMessage(){

    //update last read message if sender and receiver are different 
    if(widget.message.read.isEmpty){
      APIs.updateMessageReadStatus(widget.message);
      print('message read updated');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .03 : mq.width * .04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 210, 230, 246),
              border: Border.all(color: Colors.lightBlue),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30))
            ),
            child: 
            widget.message.type == Type.text ?
            //show text
            Text(widget.message.msg, style: TextStyle(fontSize: 15, color: Colors.black87),) : 

            //show image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.message.msg,
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2,),
                ),
                errorWidget:
                    (context, url, error) =>
                        Icon(Icons.image, size: 70,),
              ),
            ),
          ),
        ),


        //message time
        Padding(
          padding:  EdgeInsets.only(right: mq.width * .04),
          child: Text(MyDateUtil.getFormattedTime(context:context, time:  widget.message.sent), style: TextStyle(fontSize: 13, color: Colors.black54),),
        ),

    
      ],
    );
  }

  // our  user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Row(
          children: [

            SizedBox(width: mq.width * .04,),
            //double tick blue icon for message read
            if(widget.message.read.isNotEmpty)
              Icon(Icons.done_all_rounded, color: Colors.blue, size: 20,),

            //for adding some space
            SizedBox(width: 2,),

            //sent time
            Text(MyDateUtil.getFormattedTime(context:context, time:  widget.message.sent), style: TextStyle(fontSize: 13, color: Colors.black54),),
          ],
        ),

        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .03 : mq.width * .04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 205, 245, 213),
              border: Border.all(color: Colors.lightGreen),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.circular(30))
            ),

            child: 
            
        widget.message.type == Type.text ?
            //show text
            Text(widget.message.msg, style: TextStyle(fontSize: 15, color: Colors.black87),) : 

            //show image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.message.msg,
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2,),
                ),
                errorWidget:
                    (context, url, error) =>
                        Icon(Icons.image, size: 70,),
              ),
            ),
          ),
        ),


        

    
      ],
    );
  }


}