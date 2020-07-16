import 'dart:async';

import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/posts/lists_posts.dart';

class CommentsScreen extends StatefulWidget {
  final ListPosts listPosts;
  final int index;
  final int uid;
  final int post_id;

  const CommentsScreen({
    Key key,
    this.listPosts,
    this.index,
    this.uid,
    this.post_id,
  }) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();
  StreamController _commentListController = new StreamController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  String pic = '';

  void listComments() async {
    FormData formData = FormData.fromMap({
      'user_id': widget.uid,
      'post_id': widget.post_id,
      'comment': _commentController.text,
    });
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    try {
      Response response =
          await dio.post('${url}post/listcomment', data: formData);
      _commentListController.add(response);
      print(response);
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

  void addUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // name = prefs.getString('name');
      // bio = prefs.getString('bio');
      pic = prefs.getString('pic');
    });
  }

  void postComment() async {
    FormData formData = FormData.fromMap({
      'user_id': widget.uid,
      'post_id': widget.post_id,
      'comment': _commentController.text,
    });
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    try {
      Response response = await dio.post('${url}post/comment', data: formData);
      print(response);
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
        title: Text(
          'Comments',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
              stream: _commentListController.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Expanded(
                  child: ListView.builder(
                    itemCount:
                        widget.listPosts.result[widget.index].comments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(widget
                                  .listPosts
                                  .result[widget.index]
                                  .comments[index]
                                  .commentBy[1]),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      widget.listPosts.result[widget.index]
                                          .comments[index].commentBy[0],
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.listPosts.result[widget.index]
                                          .comments[index].comment,
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  DateTimeFormat.format(
                                      widget.listPosts.result[widget.index]
                                          .comments[index].updatedAt,
                                      format: DateTimeFormats.american),
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey[500],
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
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
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment',
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
                FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    'Post',
                    style: GoogleFonts.poppins(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () async {
                    if (_commentController.text != '') {
                      postComment();
                      _commentController.text = '';
                    } else
                      FlutterToast.showToast(msg: 'Please Enter a Comment');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
