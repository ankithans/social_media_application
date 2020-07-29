import 'package:dio/dio.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/posts/single_post_view.dart';

class UpdatePost extends StatefulWidget {
  final int post_id;

  const UpdatePost({Key key, this.post_id}) : super(key: key);
  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  bool _isLoading = false;
  GetSinglePost getSinglePost;
  TextEditingController _captionController = TextEditingController();
  TextEditingController _decriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  String _caption = '';
  String _description = '';
  String _location = '';
  bool showEmojiTitle = false;
  bool showEmojiDescription = false;

  void getPost() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int uid = prefs.getInt('uid');
    print(uid);
    FormData formData = FormData.fromMap({
      'user_id': uid,
      'post_id': widget.post_id,
    });
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    try {
      Response response = await dio.post('${url}post/single', data: formData);
      print(response);

      getSinglePost = GetSinglePost.fromJson(response.data);

      _captionController.text = getSinglePost.result.title;
      _decriptionController.text = getSinglePost.result.description;
      _locationController.text = getSinglePost.result.location;

      setState(() {
        _isLoading = false;
      });
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

  @override
  void initState() {
    getPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        title: Text('Update Post'),
        backgroundColor: Color(0xFFFF8B66),
      ),
      body: _isLoading
          ? Center(
              child: SpinKitThreeBounce(
                color: Color(0xFFFF8B66),
              ),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: PageView.builder(
                      controller: PageController(
                        viewportFraction: 0.85,
                        initialPage: 0,
                      ),
                      itemCount: getSinglePost.result.images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: <Widget>[
                            Container(
                              child: Image.network(
                                  getSinglePost.result.images[index].original),
                            ),
                            Positioned(
                              top: 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextField(
                                controller: _captionController,
                                style: TextStyle(fontSize: 18.0),
                                decoration: InputDecoration(
                                  labelText: 'Caption',
                                ),
                                onChanged: (input) => _caption = input,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.insert_emoticon),
                            onPressed: () {
                              setState(() {
                                showEmojiTitle = !showEmojiTitle;
                                showEmojiDescription == true
                                    ? showEmojiDescription =
                                        !showEmojiDescription
                                    : showEmojiDescription =
                                        showEmojiDescription;
                              });
                            },
                          ),
                        ],
                      ),
                      showEmojiTitle
                          ? EmojiPicker(
                              rows: 3,
                              columns: 7,
                              // recommendKeywords: ["racing", "horse"],
                              numRecommended: 10,
                              onEmojiSelected: (emoji, category) {
                                setState(() {
                                  _captionController.text =
                                      _captionController.text + emoji.emoji;
                                });
                                print(emoji);
                              },
                            )
                          : Container(),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextField(
                                controller: _decriptionController,
                                style: TextStyle(fontSize: 18.0),
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                ),
                                onChanged: (input) => _description = input,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.insert_emoticon),
                            onPressed: () {
                              setState(() {
                                showEmojiDescription = !showEmojiDescription;
                                showEmojiTitle == true
                                    ? showEmojiTitle = !showEmojiTitle
                                    : showEmojiTitle = showEmojiTitle;
                              });
                            },
                          ),
                        ],
                      ),
                      showEmojiDescription
                          ? EmojiPicker(
                              rows: 3,
                              columns: 7,
                              // recommendKeywords: ["racing", "horse"],
                              numRecommended: 10,
                              onEmojiSelected: (emoji, category) {
                                setState(() {
                                  _decriptionController.text =
                                      _decriptionController.text + emoji.emoji;
                                });
                                print(emoji);
                              },
                            )
                          : Container(),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextField(
                                controller: _locationController,
                                style: TextStyle(fontSize: 18.0),
                                decoration: InputDecoration(
                                  labelText: 'Location',
                                ),
                                onChanged: (input) => _location = input,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
