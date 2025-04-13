import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/models/chat_user.dart';
import 'package:firebase_chat_app/models/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs{
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing cloud firestore database
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for storing self information
  static late ChatUser me;

  //for accessing firebase messaging (push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {

    NotificationSettings settings = await fMessaging.requestPermission();


    await fMessaging.getToken().then((t){
      if (t!= null){
        me.pushToken = t;
        print('token: $t');
      }
    });
    // 
print('User granted permission: ${settings.authorizationStatus}');


  }

  static User get user => auth.currentUser!;

  // for checking if user exists or not
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(auth.currentUser!.uid).get()).exists;
  }

  // for checking if user exists or not
  static Future<void> getSelfInfo() async {
   await firestore.collection('users').doc(user.uid).get().then((user) async {
    if(user.exists){
      me = ChatUser.fromJson(user.data()!);
      await getFirebaseMessagingToken();

    //for setting user status to active
     APIs.updateActiveStatus(true);
    }else{
      createUser().then((value)=> getSelfInfo());
    }
   });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(isOnline: false, image: user.photoURL.toString(), email: user.email.toString(), about: "Hey, I'm using We Chat", name: user.displayName.toString(), id: user.uid, createdAt: time, lastActive: time, pushToken: '');
    
    
    return await firestore.collection('users').doc(user.uid).set(chatUser.toJson());
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return firestore.collection('users').where('id', isNotEqualTo: user.uid).snapshots();
  }

  //update user active status
  static Future<void> updateActiveStatus(bool isOnline) async {
    await firestore.collection('users').doc(user.uid).update({'is_online': isOnline, 'last_active': DateTime.now().millisecondsSinceEpoch.toString(), 'push_token': me.pushToken});
  }


  // for updating user information
  static Future<void> updateUserInfo() async {
     await firestore.collection('users').doc(user.uid).update({'name': me.name, 'about': me.about});
  }

// for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUser chatUser){
    return firestore.collection('users').where('id', isEqualTo: chatUser.id).snapshots();
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {

    //print('I am here');

    //getting image file extension
    final ext = file.path.split('.').last;
    //log('Extension; $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0){
      // log('Data trabsferred: ${p0.bytesTransferred / 1000} kb');

    });

    // updating image in firestore database
    me.image = await ref.getDownloadURL();
               await firestore.collection('users').doc(user.uid).update({'image': me.image});

  }

  // chats (collection) --> collection_id (doc) --> messages (collection) --> message (doc)

  //for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  // for getting all specific conversation form firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user){
    return firestore.collection('chats/${getConversationID(user.id)}/messages/').orderBy('sent', descending: true).snapshots();
  }

  //for sending message
  static Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(toId: chatUser.id, type: type, msg: msg, read: '', fromId: user.uid, sent: time);

    final ref = firestore.collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async { 
   firestore.collection('chats/${getConversationID(message.fromId)}/messages/').doc(message.sent).update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
 }

   //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser user) { 
    return firestore.collection('chats/${getConversationID(user.id)}/messages/')
    .orderBy('sent', descending: true)
    .limit(1)
    .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file, Type type) async {
     //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child('images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0){
      print('Data trabsferred: ${p0.bytesTransferred / 1000} kb');

    });

    // updating image in firestore database
    final imageUrl = await ref.getDownloadURL();

      sendMessage(chatUser, imageUrl, Type.image);
  }









} 