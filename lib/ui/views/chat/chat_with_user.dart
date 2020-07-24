import 'dart:async';

import 'package:dio/dio.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/chat/chat_list.dart';

int uid;
ChatListing chatListing;

class ChatWithUser extends StatefulWidget {
  final userName;
  final user_id;
  final String pic;

  const ChatWithUser({Key key, this.userName, this.user_id, this.pic})
      : super(key: key);

  @override
  _ChatWithUserState createState() => _ChatWithUserState();
}

class _ChatWithUserState extends State<ChatWithUser> {
  bool _isLoading = false;

  void getChatList() async {
    setState(() {
      _isLoading = true;
    });
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    uid = prefs.getInt('uid');
    FormData formData = FormData.fromMap({
      'chat_by': uid,
      'chat_to': widget.user_id,
    });

    try {
      Response response = await dio.post('${url}chat/listing', data: formData);
      print(response);

      chatListing = ChatListing.fromJson(response.data);
      setState(() {
        _isLoading = false;
      });
    } on DioError catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.error);
      throw (e.error);
    }
  }

  void getChatListEverySecond() async {
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    uid = prefs.getInt('uid');
    FormData formData = FormData.fromMap({
      'chat_by': uid,
      'chat_to': widget.user_id,
    });

    try {
      Response response = await dio.post('${url}chat/listing', data: formData);
      print(response);
      setState(() {
        chatListing = ChatListing.fromJson(response.data);
      });
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

  Timer timer;

  @override
  void initState() {
    super.initState();
    getChatList();
    timer = Timer.periodic(
        Duration(seconds: 4), (Timer t) => getChatListEverySecond());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // @override
  // void dispose() {
  //   // DO STUFF
  //   super.dispose();
  // }

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
        body: _isLoading == false
            ? ChatScreen(
                user_id: widget.user_id,
                pic: widget.pic,
                // chatListing: chatListing,
              )
            : Center(
                child: SpinKitThreeBounce(
                  color: Color(0xFFFF8B66),
                ),
              ));
  }
}

class ChatScreen extends StatefulWidget {
  final int user_id;
  final String pic;
  // final ChatListing chatListing;

  const ChatScreen({Key key, this.user_id, this.pic}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isLoading = false;
  final _chatController = TextEditingController();
  // ChatListing _chatListing;

  void sendChat() async {
    setState(() {
      _isLoading = true;
    });
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();

    FormData formData = FormData.fromMap({
      'chat_by': uid,
      'chat_to': widget.user_id,
      'chat': _chatController.text
    });

    try {
      Response response = await dio.post('${url}chat', data: formData);
      print(response);

      setState(() {
        chatListing = ChatListing.fromJson(response.data);
      });
      setState(() {
        _isLoading = false;
      });
    } on DioError catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.error);
      throw (e.error);
    }
  }

  String pic = '';
  void addUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // name = prefs.getString('name');
      // bio = prefs.getString('bio');
      pic = prefs.getString('pic');
    });
  }

  @override
  void initState() {
    super.initState();

    addUserDetails();
  }

  bool showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: chatListing.result.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[400],
                            offset: Offset(0.0, 1.0),
                            blurRadius: 3.0,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: chatListing.result[index].userId == uid
                            ? EdgeInsets.only(
                                left: 10.0,
                                right: 5,
                                top: 12,
                                bottom: 12,
                              )
                            : EdgeInsets.only(
                                left: 40.0,
                                right: 5,
                                top: 12,
                                bottom: 12,
                              ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Container(
                            //   child: Text(
                            //     chatListing.result[index].chat,
                            //     style: GoogleFonts.poppins(
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.w500,
                            //     ),
                            //   ),
                            // ),
                            Container(
                              child: Text(
                                chatListing.result[index].chat,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              '${chatListing.result[index].createdAt}',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    chatListing.result[index].userId == uid
                        ? Positioned(
                            left: 300,
                            top: 9,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage:
                                  NetworkImage(chatListing.result[index].pic),
                            ),
                          )
                        : Positioned(
                            left: -10,
                            top: 9,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage:
                                  NetworkImage(chatListing.result[index].pic),
                            ),
                          ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: pic != null ? NetworkImage(pic) : null,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextFormField(
                  controller: _chatController,
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showEmoji = !showEmoji;
                      });
                    },
                    icon: Icon(Icons.insert_emoticon),
                  ),
                  IconButton(
                    icon: _isLoading == false
                        ? Icon(
                            Icons.send,
                            color: Colors.blue,
                          )
                        : Center(
                            child: SpinKitThreeBounce(
                              color: Color(0xFFFF8B66),
                              size: 15,
                            ),
                          ),
                    onPressed: () async {
                      if (_chatController.text != '') {
                        sendChat();

                        _chatController.text = '';
                      } else
                        FlutterToast.showToast(msg: 'Please Enter something');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        showEmoji
            ? EmojiPicker(
                rows: 3,
                columns: 7,
                // recommendKeywords: ["racing", "horse"],
                numRecommended: 10,
                onEmojiSelected: (emoji, category) {
                  setState(() {
                    _chatController.text = _chatController.text + emoji.emoji;
                  });
                  print(emoji);
                },
              )
            : Container(),
      ],
    );
  }
}
