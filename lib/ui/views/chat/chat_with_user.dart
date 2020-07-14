import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/ui/views/posts/home_feeds.dart';
import 'package:social_media_application/utils/data.dart';
import 'package:uuid/uuid.dart';

class ChatWithUser extends StatefulWidget {
  final userName;
  final uid;
  final String pic;

  const ChatWithUser({Key key, this.userName, this.uid, this.pic})
      : super(key: key);

  @override
  _ChatWithUserState createState() => _ChatWithUserState();
}

class _ChatWithUserState extends State<ChatWithUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Row(
          children: <Widget>[
            SizedBox(
              width: 25,
            ),
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(widget.pic),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.userName,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFF8B66),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ChatScreen(
        username: widget.userName,
        uid: uid.toString(),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String username;
  final String uid;

  ChatScreen({this.username, this.uid});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatUser user = ChatUser();
  String groupChatId;

  int user_id;
  void getUser_id() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user_id = prefs.getInt('uid');
  }

  @override
  void initState() {
    user.name = widget.username;
    user.uid = widget.uid;
    super.initState();
    getUser_id();
  }

  void onSend(ChatMessage message) {
    // if (user_id.hashCode <= widget.uid.hashCode) {
    //   groupChatId = '${user_id}-${widget.uid}';
    // } else {
    //   groupChatId = '${widget.uid}-${user_id}';
    // }
    var documentReference = Firestore.instance
        .collection('messages')
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
  }

  void uploadFile() async {
    File result = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxHeight: 400,
      maxWidth: 400,
    );

    if (result != null) {
      String id = Uuid().v4().toString();

      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child("chat_images/$id.jpg");

      StorageUploadTask uploadTask = storageRef.putFile(
        result,
        StorageMetadata(
          contentType: 'image/jpg',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;

      String url = await download.ref.getDownloadURL();

      ChatMessage message = ChatMessage(text: "", user: user, image: url);

      var documentReference = Firestore.instance
          .collection('messages')
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          message.toJson(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          } else {
            List<DocumentSnapshot> items = snapshot.data.documents;
            var messages =
                items.map((i) => ChatMessage.fromJson(i.data)).toList();
            return DashChat(
              user: user,
              messages: messages,
              inputDecoration: InputDecoration(
                hintText: "Message here...",
                border: InputBorder.none,
              ),
              onSend: onSend,
              trailing: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: uploadFile,
                )
              ],
            );
          }
        },
      ),
    );
  }
}
