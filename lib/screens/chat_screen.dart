import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_chat_app/api/apis.dart';
import 'package:firebase_chat_app/helper/my_date_util.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/models/chat_user.dart';
import 'package:firebase_chat_app/models/message.dart';
import 'package:firebase_chat_app/screens/view_profile_screen.dart';
import 'package:firebase_chat_app/widgets/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  // for storing value of showing or hiding emoji
  bool _showEmoji = false, _isuploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
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

                          _list =
                              data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          //   final _list = [];

                          // _list.add(Message(toId: 'xyz', type: Type.text, msg: 'Hi!', read: '', fromId: APIs.user.uid, sent: '12:00 AM'));
                          // _list.add(Message(toId: APIs.user.uid, type: Type.text, msg: 'Hello', read: '', fromId: 'xyz', sent: '12:05 AM'));

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: mq.height * .01),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(message: _list[index]);
                              },
                            );
                          } else {
                            return Center(
                              child: Text(
                                'Say hi! 👋',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),

                //progress indicator for showing uploading
                if (_isuploading)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20,
                      ),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                //chat input field
                _chatInput(),

                //show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: Offstage(
                      offstage: !_showEmoji,
                      child: EmojiPicker(
                        textEditingController: _textController,
                        config: Config(
                          height: 256,
                          checkPlatformCompatibility: true,
                          viewOrderConfig: const ViewOrderConfig(),
                          emojiViewConfig: EmojiViewConfig(
                            emojiSizeMax: 28 * (Platform.isIOS ? 1.2 : 1.0),
                          ),
                          skinToneConfig: const SkinToneConfig(),
                          categoryViewConfig: const CategoryViewConfig(),
                          bottomActionBarConfig: const BottomActionBarConfig(),
                          searchViewConfig: const SearchViewConfig(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: StreamBuilder(
        stream: APIs.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;

          final list =
              data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

          return Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.black54),
              ),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(user: widget.user)))
,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    width: mq.height * .04,
                    height: mq.height * .04,
                
                    imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) =>
                            CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),

              SizedBox(width: 10),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.isNotEmpty ? list[0].name : widget.user.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    list.isNotEmpty
    ? (list[0].isOnline ? 'Online' : (MyDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive!)))
    : (MyDateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive!))
,
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: mq.height * .01,
        horizontal: mq.width * .025,
      ),
      child: Row(
        children: [
          //input field & button
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),

                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      onTap: () {
                        if (_showEmoji)
                          setState(() {
                            _showEmoji = !_showEmoji;
                          });
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  //pick image from gallery
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      //picking multiple images
                      final List<XFile> images = await picker.pickMultiImage(
                        imageQuality: 70,
                      );

                      //uploading one after the other
                      for (var image in images) {
                        setState(() {
                          _isuploading = true;
                        });
                        await APIs.sendChatImage(
                          widget.user,
                          File(image.path),
                          Type.image,
                        );
                        setState(() {
                          _isuploading = false;
                        });
                      }
                    },
                    icon: Icon(Icons.image, color: Colors.blueAccent, size: 26),
                  ),

                  //take image from camera button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 70,
                      );
                      if (image != null) {
                        //log("Image Path: ${image.path} -- MimeType: ${image.mimeType}");

                        setState(() {
                          _isuploading = true;
                        });
                        await APIs.sendChatImage(
                          widget.user,
                          File(image.path),
                          Type.image,
                        );
                        setState(() {
                          _isuploading = false;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),

                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ),
          //send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if(_list.isEmpty){
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(widget.user, _textController.text, Type.text);
                }else{
                  //simply send message
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),

            shape: CircleBorder(),
            color: Colors.green,

            child: Icon(Icons.send, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}
