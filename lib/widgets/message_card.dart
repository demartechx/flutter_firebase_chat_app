import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat_app/api/apis.dart';
import 'package:firebase_chat_app/helper/dialogs.dart';
import 'package:firebase_chat_app/helper/my_date_util.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageCard extends StatefulWidget {
  MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;

    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  // sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      print('message read updated');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
              widget.message.type == Type.image
                  ? mq.width * .03
                  : mq.width * .04,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 210, 230, 246),
              border: Border.all(color: Colors.lightBlue),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child:
                widget.message.type == Type.text
                    ?
                    //show text
                    Text(
                      widget.message.msg,
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    )
                    :
                    //show image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        placeholder:
                            (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        errorWidget:
                            (context, url, error) =>
                                Icon(Icons.image, size: 70),
                      ),
                    ),
          ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
              context: context,
              time: widget.message.sent,
            ),
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
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
            SizedBox(width: mq.width * .04),
            //double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            //for adding some space
            SizedBox(width: 2),

            //sent time
            Text(
              MyDateUtil.getFormattedTime(
                context: context,
                time: widget.message.sent,
              ),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        Flexible(
          child: Container(
            padding: EdgeInsets.all(
              widget.message.type == Type.image
                  ? mq.width * .03
                  : mq.width * .04,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 205, 245, 213),
              border: Border.all(color: Colors.lightGreen),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),

            child:
                widget.message.type == Type.text
                    ?
                    //show text
                    Text(
                      widget.message.msg,
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    )
                    :
                    //show image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        placeholder:
                            (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        errorWidget:
                            (context, url, error) =>
                                Icon(Icons.image, size: 70),
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),

      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: mq.height * .03,
            bottom: mq.height * .03,
          ),
          children: [
            //black divider
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                vertical: mq.height * .015,
                horizontal: mq.width * .4,
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            //copy option
             widget.message.type == Type.text?
            _OptionItem(
              icon: Icon(Icons.copy_all_rounded, color: Colors.blue, size: 26),
              name: 'Copy Text',
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: widget.message.msg)).then((value){
                  Navigator.pop(context);
                  Dialogs.showSnackBar(context, 'Text Copied');
                });
              },
            ):_OptionItem(
              icon: Icon(Icons.download_rounded, color: Colors.blue, size: 26),
              name: 'Save Image',
              onTap: () {},
            ),


           

            //separator divider
            if(isMe)
            Divider(color: Colors.black54, endIndent: mq.width * .04, indent: mq.width * .04,),

            if(widget.message.type == Type.text && isMe)
            //edit option
            _OptionItem(
              icon: Icon(Icons.edit, color: Colors.blue, size: 26),
              name: 'Edit Message',
              onTap: () {},
            ),

            //delete option
            if(isMe)
            _OptionItem(
              icon: Icon(Icons.delete_forever, color: Colors.red, size: 26),
              name: 'Delete Message',
              onTap: () async {
                await APIs.deleteMessage(widget.message).then((value)=> Navigator.pop(context));
              },
            ),

            //separator divider
            Divider(color: Colors.black54, endIndent: mq.width * .04, indent: mq.width * .04,),

            //sent time
            _OptionItem(
              icon: Icon(Icons.remove_red_eye, color: Colors.blue, size: 26),
              name: 'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
              onTap: () {},
            ),

            //read time
            _OptionItem(
              icon: Icon(Icons.remove_red_eye, color: Colors.green, size: 26),
              name: widget.message.read.isEmpty ? 'Read At: Not seen yet' :
              'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
              onTap: () {},
            ),
          ],
        );
      },
    );
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
          left: mq.width * .05,
          top: mq.height * .015,
          bottom: mq.height * .015,
        ),
        child: Row(
          children: [
            icon,
            Flexible(
              child: Text(
                '     $name',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
