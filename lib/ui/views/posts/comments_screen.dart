import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/posts/listComments.dart';
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

  String pic = '';
  bool _isLoading = false;
  ListComments _listComments;

  void listComments() async {
    setState(() {
      _isLoading = true;
    });
    FormData formData = FormData.fromMap({
      'user_id': widget.uid,
      'post_id': widget.post_id,
    });
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    try {
      Response response =
          await dio.post('${url}post/comment/listing', data: formData);
      _listComments = ListComments.fromJson(response.data);
      print(response);
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

  void addUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // name = prefs.getString('name');
      // bio = prefs.getString('bio');
      pic = prefs.getString('pic');
    });
  }

  bool postLoading = false;

  void postComment() async {
    setState(() {
      postLoading = true;
    });
    FormData formData = FormData.fromMap({
      'user_id': widget.uid,
      'post_id': widget.post_id,
      'comment': _commentController.text,
    });
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    try {
      Response response = await dio.post('${url}post/comment', data: formData);
      setState(() {
        _listComments = ListComments.fromJson(response.data);
      });
      setState(() {
        postLoading = false;
      });
      print(response);
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

  bool showEmoji = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addUserDetails();
    listComments();
    print(widget.uid);
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
          Expanded(
            child: _isLoading == false
                ? _listComments.result.length == 0
                    ? Center(
                        child: Text(
                          'No Comments yet!',
                          style: GoogleFonts.poppins(),
                        ),
                      )
                    : ListView.builder(
                        reverse: false,
                        itemCount: _listComments.result.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    _listComments.result[index].commentBy[1],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _listComments
                                              .result[index].commentBy[0],
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.73,
                                          child: Text(
                                            _listComments.result[index].comment,
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      DateTimeFormat.format(
                                          _listComments.result[index].updatedAt,
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
                      )
                : Center(
                    child: SpinKitThreeBounce(
                      color: Color(0xFFFF8B66),
                    ),
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
                      icon: postLoading
                          ? SpinKitThreeBounce(
                              color: Color(0xFFFF8B66),
                              size: 15,
                            )
                          : Icon(
                              Icons.send,
                              color: Colors.blue,
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
                      _commentController.text =
                          _commentController.text + emoji.emoji;
                    });
                    print(emoji);
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
