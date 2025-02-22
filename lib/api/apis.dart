import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/models/chat_user.dart';

class APIs{
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  // for checking if user exists or not
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(auth.currentUser!.uid).get()).exists;
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUserModel(isOnline: false, image: user.photoURL.toString(), email: user.email.toString(), about: "Hey, I'm using We Chat", name: user.displayName.toString(), id: user.uid, createdAt: time, lastActive: time, pushToken: '');
    
    
    return await firestore.collection('users').doc(user.uid).set(chatUser.toJson());
  }


} 