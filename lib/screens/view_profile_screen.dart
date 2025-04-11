import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat_app/helper/my_date_util.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
          ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
SizedBox(height: mq.height * .02,),
            //user profile picture
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .25),
                child: CachedNetworkImage(
                  width: mq.width * .4,
                  fit: BoxFit.cover,
              
                  imageUrl: user.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget:
                      (context, url, error) =>
                          CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
            ),

            SizedBox(height: mq.height * .02,),

            Align(
              alignment: Alignment.center,
              child: Text(user.email, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)),
              SizedBox(height: mq.height * .01,),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('About: ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                  Text(user.about, style: const TextStyle(fontSize: 14),),
                ],
              )),


Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Joined On: ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                  Text(user.createdAt!, style: const TextStyle(fontSize: 14),),
                //MyDateUtil.getLastActiveTime(context: context, lastActive: user.createdAt!)
                ],
              ),

              SizedBox(height: mq.height * .05,),

          
          ],
        ),
    );
  }
}