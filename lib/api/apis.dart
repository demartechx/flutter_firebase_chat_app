import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/models/chat_user.dart';
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

  static User get user => auth.currentUser!;

  // for checking if user exists or not
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(auth.currentUser!.uid).get()).exists;
  }

  // for checking if user exists or not
  static Future<void> getSelfInfo() async {
   await firestore.collection('users').doc(user.uid).get().then((user){
    if(user.exists){
      me = ChatUser.fromJson(user.data()!);
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


  // for updating user information
  static Future<void> updateUserInfo() async {
     await firestore.collection('users').doc(user.uid).update({'name': me.name, 'about': me.about});
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {

    print('I am here');

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


} 