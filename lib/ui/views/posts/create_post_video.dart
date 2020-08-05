import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photofilters/photofilters.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
// import 'package:image/image.dart' as imageLib;
// import 'package:path/path.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class CreatePostVideo extends StatefulWidget {
  final File video;
  final MultipartFile file;
  final MultipartFile thumbnail;

  const CreatePostVideo({
    Key key,
    this.video,
    this.file,
    this.thumbnail,
  }) : super(key: key);

  @override
  _CreatePostVideoState createState() => _CreatePostVideoState();
}

class _CreatePostVideoState extends State<CreatePostVideo> {
  TextEditingController _captionController = TextEditingController();
  TextEditingController _decriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _hashTagController = TextEditingController();

  String _caption = '';
  String _description = '';
  String _location = '';
  List hashTags = [];

  bool _isLoading = false;

  Filter _filter;
  List<Filter> filters;

  // String filePath = '';
  // String _filePath = '';
  // void abc() async {
  //   filePath = await FlutterAbsolutePath.getAbsolutePath(widget.video);
  //   print(filePath);
  //   setState(() {
  //     _filePath = filePath;
  //   });
  // }

  // @override
  // void initState() {
  //   abc();

  //   super.initState();
  // }
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.file(widget.video);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  bool showEmojiTitle = false;
  bool showEmojiDescription = false;

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context, isDismissible: false);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF8B66),
        title: Text(
          'Create Post',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
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
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              if (_captionController.text == '') {
                FlutterToast.showToast(
                    msg: 'Please Enter a Caption for your post');
              } else {
                if (!_isLoading) {
                  await pr.show();
                  setState(() {
                    _isLoading = true;
                  });
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  int uid = prefs.getInt('uid');
                  String filename = widget.video.path.split('/').last;
                  // Create post

                  // MultipartFile file = await MultipartFile.fromFile(
                  //     widget.video.path,
                  //     filename: filename);
                  FormData formData = FormData.fromMap({
                    'user_id': uid,
                    'title': _captionController.text,
                    'video': widget.file,
                    'video_thumb': widget.thumbnail,
                    'description': _decriptionController.text,
                    'location': _locationController.text,
                  });
                  const url = 'https://www.mustdiscovertech.co.in/social/v1/';
                  Dio dio = new Dio();
                  try {
                    Response response =
                        await dio.post('${url}post/upload', data: formData);
                    print(response);

                    FlutterToast.showToast(
                        msg: 'Your post is uploaded successfully!');
                    // Reset data
                    _captionController.clear();

                    setState(() {
                      _caption = '';
                      _description = '';
                      _isLoading = false;
                    });
                    await pr.hide();
                    Navigator.pop(context);
                  } on DioError catch (e) {
                    print(e.error);
                    await pr.hide();

                    FlutterToast.showToast(msg: 'Not able to upload your post');

                    throw (e.error);
                  }
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          child: Column(
            children: <Widget>[
              // Expanded(
              //     // child: PageView.builder(
              //     //     itemCount: widget.files.length,
              //     //     itemBuilder: (BuildContext context, int index) {
              //     //       return Padding(
              //     //         padding: const EdgeInsets.all(8.0),
              //     //         child: Stack(
              //     //           children: <Widget>[
              //     //             // FlatButton(
              //     //             //   padding: EdgeInsets.all(0),
              //     //             //   onPressed: () async {
              //     //             //     var image = imageLib.decodeImage(
              //     //             //         widget.files[index].readAsBytesSync());
              //     //             //     image = imageLib.copyResize(image, width: 600);
              //     //             //     String fileName =
              //     //             //         basename(widget.files[index].path);

              //     //             //     Map imagefile = await Navigator.push(
              //     //             //       context,
              //     //             //       new MaterialPageRoute(
              //     //             //         builder: (context) =>
              //     //             //             new PhotoFilterSelector(
              //     //             //           title: Text("Photo Filter Example"),
              //     //             //           image: image,
              //     //             //           filters: presetFiltersList,
              //     //             //           filename: fileName,
              //     //             //           loader: Center(
              //     //             //               child: CircularProgressIndicator()),
              //     //             //           fit: BoxFit.contain,
              //     //             //         ),
              //     //             //       ),
              //     //             //     );
              //     //             //     if (imagefile != null &&
              //     //             //         imagefile.containsKey('image_filtered')) {
              //     //             //       setState(() {
              //     //             //         widget.files[index] =
              //     //             //             imagefile['image_filtered'];
              //     //             //       });
              //     //             //       widget.uploadList[index] =
              //     //             //           await MultipartFile.fromFile(
              //     //             //               widget.files[index].path,
              //     //             //               filename: fileName);
              //     //             //       print(widget.files[index].path);
              //     //             //     }
              //     //             //   },
              //     //             //   child: Image.file(
              //     //             //     widget.files[index],
              //     //             //   ),
              //     //             // ),
              //     //             // IconButton(
              //     //             //   icon: Icon(
              //     //             //     Icons.cancel,
              //     //             //     color: Colors.red,
              //     //             //   ),
              //     //             //   onPressed: () {
              //     //             //     setState(() {
              //     //             //       widget.files.removeAt(index);
              //     //             //       widget.uploadList.removeAt(index);
              //     //             //     });
              //     //             //   },
              //     //             // ),
              //     //           ],
              //     //         ),
              //     //       );
              //     //     },
              //     //     controller: PageController(
              //     //       viewportFraction: 0.85,
              //     //       initialPage: 0,
              //     //     )),
              //     ),
              // widget.files != null
              //     ? Expanded(
              //         flex: 2,
              //         child: GridView.builder(
              //           shrinkWrap: true,
              //           physics: AlwaysScrollableScrollPhysics(),
              //           primary: false,
              //           itemCount: widget.files.length,
              //           gridDelegate:
              //               SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 1,
              //             childAspectRatio: 1,
              //           ),
              //           itemBuilder: (BuildContext context, int index) {
              //             return Padding(
              //               padding: EdgeInsets.all(5.0),
              //               child: Stack(
              //                 children: <Widget>[
              //                   Image.file(widget.files[index]),
              //                   IconButton(
              //                     icon: Icon(
              //                       Icons.cancel,
              //                       color: Colors.red,
              //                       size: 30,
              //                     ),
              //                     onPressed: () {
              //                       setState(() {
              //                         widget.files.removeAt(index);
              //                       });
              //                     },
              //                   ),
              //                 ],
              //               ),
              //             );
              //           },
              //         ),
              //       )
              //     : Container(),

              Chewie(
                controller: _chewieController,
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
                                ? showEmojiDescription = !showEmojiDescription
                                : showEmojiDescription = showEmojiDescription;
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
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: TextField(
                            controller: _hashTagController,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              labelText: 'Hash Tags',
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            hashTags.add(_hashTagController.text);
                            _hashTagController.text = '';
                          });
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Tags(
                      itemCount: hashTags.length,
                      itemBuilder: (int index) {
                        return Tooltip(
                          message: hashTags[index],
                          child: ItemTags(
                            index: 1,
                            title: hashTags[index],

                            removeButton: ItemTagsRemoveButton(
                              onRemoved: () {
                                // Remove the item from the data source.
                                setState(() {
                                  // required
                                  hashTags.removeAt(index);
                                });
                                //required
                                return true;
                              },
                            ), // OR null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
