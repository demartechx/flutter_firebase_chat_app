import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat_app/api/apis.dart';
import 'package:firebase_chat_app/helper/dialogs.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/models/chat_user.dart';
import 'package:firebase_chat_app/screens/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        //app bar
        appBar: AppBar(
          // leading: Icon(CupertinoIcons.home),
          title: Text('Profile Screen'),
          // actions: [
          //   //search user button
          //   IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          //   //more features buton
          //   IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          // ],
        ),
      
        //floating button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            
            onPressed: () async {
              Dialogs.showProgressBar(context);
      
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value){
                    // for hiding progress dialog
                    Navigator.pop(context); 
      
                    //for moving to home screen
                    Navigator.pop(context); 
      
                    //replacing home screen with login screen
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                });
                
              });
              
            },
            icon: Icon(Icons.logout, color: Colors.white),
            label: Text('Logout', style: TextStyle(color: Colors.white),),
          ),
        ),
      
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  SizedBox(width: mq.width, height: mq.height * .03),
                    
                  //user profile picture
                  Stack(
                    children: [
                      _image != null ? 
                      //local image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: Image.file(
                          File(_image!),
                          width: mq.height * .2,
                          height: mq.height * .2,
                          fit: BoxFit.cover,
                      
                       
                        ),
                      ) :

                      //image from server
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: CachedNetworkImage(
                          width: mq.height * .2,
                          height: mq.height * .2,
                          fit: BoxFit.cover,
                      
                          imageUrl: widget.user.image,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget:
                              (context, url, error) =>
                                  CircleAvatar(child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(onPressed: (){
                          _showBottomSheet();
                        }, 
                        elevation: 1,
                        color: Colors.white,
                        shape: CircleBorder(),
                        child: Icon(Icons.edit, color: Colors.blue,),),
                      )
                    ],
                  ),
                    
                  // for adding some space
                  SizedBox(height: mq.height * .03),
                    
                  Text(widget.user.email, style: TextStyle(color: Colors.black54, fontSize: 16),),
                    
                  // for adding some space
                  SizedBox(height: mq.height * .05),
                    
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field' ,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color:  Colors.blue,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      
                      hintText: 'eg Happy Singh',
                      label: Text('Name')
                    ),
                  ),
                    
                   // for adding some space
                  SizedBox(height: mq.height * .02),
                    
                    
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field' ,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info_outline, color:  Colors.blue,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      
                      hintText: 'eg Feeling fly',
                      label: Text('About')
                    ),
                  ),
                    
                  // for adding some space
                  SizedBox(height: mq.height * .05),
                    
                  //update profile button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(shape: StadiumBorder(), fixedSize: Size(mq.width * .4, mq.height * .06)),
                    onPressed: (){

                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value){
                          Dialogs.showSnackBar(context, 'Profile updated successfully');
                        }); 
                        log('inside validator');
                      }
                    }, icon: Icon(Icons.edit, size: 28,), label: Text('Update', style: TextStyle(fontSize: 16),),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


// bottom sheet for picking a profile picture for user
void _showBottomSheet(){

  showModalBottomSheet(context: context, 
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  
  builder: (_){
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .03),
      children: [
        Text('Pick profile picture', textAlign: TextAlign.center, style: TextStyle(
          
          fontSize: 20, fontWeight: FontWeight.w500),),

        //for adding some space
        SizedBox(height: mq.height * .02,),

        // buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: CircleBorder(),
                fixedSize: Size(mq.width * .3, mq.height * .15)
              ),
              
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image.
                final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                if(image != null){
                  log("Image Path: ${image.path} -- MimeType: ${image.mimeType}");

                  setState(() {
                    _image = image.path;
                  });

                   APIs.updateProfilePicture(File(_image!));

                  //for hiding bottom sheet
                Navigator.pop(context);

                }
                

              }, child: Image.asset('assets/images/add_image2.png')),

              ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: CircleBorder(),
                fixedSize: Size(mq.width * .3, mq.height * .15)
              ),
              
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image.
                final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                if(image != null){
                  log("Image Path: ${image.path}");

                  setState(() {
                    _image = image.path;
                  });


                  APIs.updateProfilePicture(File(_image!));

                  //for hiding bottom sheet
                Navigator.pop(context);

                }
                
              }, child: Image.asset('assets/images/camera2.png'))

          ],
        )
      ],
    );
  });
}

}