import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photofilters/photofilters.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/posts/single_post_view.dart';
import 'package:social_media_application/ui/views/posts/video_player.dart';

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
  TextEditingController _hashTagController = TextEditingController();

  String _caption = '';
  String _description = '';
  String _location = '';
  bool showEmojiTitle = false;
  bool showEmojiDescription = false;
  List hashTags = [];

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

      setState(() {
        getSinglePost = GetSinglePost.fromJson(response.data);
      });
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

  List<File> _files = [];
  List<MultipartFile> uploadList = [];
  List<Asset> assets = [];
  String fileName;

  _handleImage() async {
    Future<List<Asset>> selectImagesFromGallery() async {
      return await MultiImagePicker.pickImages(
        maxImages: 65536,
        enableCamera: true,
        materialOptions: MaterialOptions(
          actionBarColor: "#FF147cfa",
          statusBarColor: "#FF147cfa",
        ),
      );
    }

    assets = await selectImagesFromGallery();
    List<File> files = [];
    for (Asset asset in assets) {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      print(filePath);
      files.add(File(filePath));
      fileName = filePath.split('/').last;
      print(fileName);
      uploadList
          .add(await MultipartFile.fromFile(filePath, filename: fileName));
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _files = files;
    });
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
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              int uid = prefs.getInt('uid');
              print(uid);
              FormData formData = FormData.fromMap({
                'user_id': uid,
                'post_id': widget.post_id,
                'title': _captionController.text,
                'description': _decriptionController.text,
                'photo': uploadList,
              });
              const url = 'https://www.mustdiscovertech.co.in/social/v1/';
              Dio dio = new Dio();
              try {
                Response response =
                    await dio.post('${url}post/update', data: formData);
                print(response);

                setState(() {
                  _isLoading = false;
                });
                Navigator.pop(context);
                Navigator.pop(context);
              } on DioError catch (e) {
                print(e.error);
                throw (e.error);
              }
            },
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
          : getSinglePost.result.images.length == 0
              ? Container(
                  padding: EdgeInsets.all(0),
                  child: ListView(
                    children: <Widget>[
                      getSinglePost.result.images.length == 0
                          ? FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return VideoPlayer(
                                        video: getSinglePost.result.video,
                                      );
                                    },
                                  ),
                                );
                              },
                              padding: EdgeInsets.all(0),
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        CachedNetworkImage(
                                            imageUrl: getSinglePost
                                                .result.videoThumb),
                                        IconButton(
                                          icon: Icon(
                                            Icons.play_circle_outline,
                                            color: Colors.white,
                                          ),
                                          iconSize: 64,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return VideoPlayer(
                                                    video: getSinglePost
                                                        .result.video,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    // ListTile(
                                    //   title: Text(_li),
                                    //   subtitle: Text(Uri.parse(video.videoImageUrl).host),
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          : Expanded(
                              child: PageView.builder(
                                controller: PageController(
                                  viewportFraction: 0.5,
                                  initialPage: 0,
                                ),
                                itemCount: getSinglePost.result.images.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: <Widget>[
                                      Container(
                                        child: Image.network(getSinglePost
                                            .result.images[index].original),
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            int uid = prefs.getInt('uid');
                                            print(uid);
                                            FormData formData =
                                                FormData.fromMap({
                                              'user_id': uid,
                                              'post_id': widget.post_id,
                                              'url': getSinglePost.result
                                                  .images[index].original,
                                            });
                                            const url =
                                                'https://www.mustdiscovertech.co.in/social/v1/';
                                            Dio dio = new Dio();
                                            try {
                                              Response response =
                                                  await dio.post(
                                                      '${url}post/pfiledelete',
                                                      data: formData);
                                              print(response);

                                              getPost();

                                              setState(() {
                                                _isLoading = false;
                                              });
                                            } on DioError catch (e) {
                                              print(e.error);
                                              throw (e.error);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                      getSinglePost.result.images.length != 0
                          ? Expanded(
                              child: Column(
                                children: <Widget>[
                                  GFButton(
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    onPressed: () {
                                      _handleImage();
                                    },
                                    text: "Add ",
                                  ),
                                  _files.length != 0
                                      ? Expanded(
                                          child: PageView.builder(
                                              itemCount: _files.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      FlatButton(
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        onPressed: () async {
                                                          var image = imageLib
                                                              .decodeImage(_files[
                                                                      index]
                                                                  .readAsBytesSync());
                                                          image = imageLib
                                                              .copyResize(image,
                                                                  width: 600);
                                                          String fileName =
                                                              basename(
                                                                  _files[index]
                                                                      .path);

                                                          Map imagefile =
                                                              await Navigator
                                                                  .push(
                                                            context,
                                                            new MaterialPageRoute(
                                                              builder: (context) =>
                                                                  new PhotoFilterSelector(
                                                                title: Text(
                                                                    "Photo Filter Example"),
                                                                image: image,
                                                                filters:
                                                                    presetFiltersList,
                                                                filename:
                                                                    fileName,
                                                                loader: Center(
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          );
                                                          if (imagefile !=
                                                                  null &&
                                                              imagefile.containsKey(
                                                                  'image_filtered')) {
                                                            setState(() {
                                                              _files[index] =
                                                                  imagefile[
                                                                      'image_filtered'];
                                                            });
                                                            uploadList[index] =
                                                                await MultipartFile.fromFile(
                                                                    _files[index]
                                                                        .path,
                                                                    filename:
                                                                        fileName);
                                                            print(_files[index]
                                                                .path);
                                                          }
                                                        },
                                                        child: Image.file(
                                                          _files[index],
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.cancel,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _files.removeAt(
                                                                index);
                                                            uploadList.removeAt(
                                                                index);
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              controller: PageController(
                                                viewportFraction: 0.85,
                                                initialPage: 0,
                                              )),
                                        )
                                      : Container(),
                                ],
                              ),
                            )
                          : Container(),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: TextField(
                                          controller: _captionController,
                                          style: TextStyle(fontSize: 18.0),
                                          decoration: InputDecoration(
                                            labelText: 'Caption',
                                          ),
                                          onChanged: (input) =>
                                              _caption = input,
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
                                                _captionController.text +
                                                    emoji.emoji;
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: TextField(
                                          controller: _decriptionController,
                                          style: TextStyle(fontSize: 18.0),
                                          decoration: InputDecoration(
                                            labelText: 'Description',
                                          ),
                                          onChanged: (input) =>
                                              _description = input,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.insert_emoticon),
                                      onPressed: () {
                                        setState(() {
                                          showEmojiDescription =
                                              !showEmojiDescription;
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
                                                _decriptionController.text +
                                                    emoji.emoji;
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: TextField(
                                          controller: _locationController,
                                          style: TextStyle(fontSize: 18.0),
                                          decoration: InputDecoration(
                                            labelText: 'Location',
                                          ),
                                          onChanged: (input) =>
                                              _location = input,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: <Widget>[
                      getSinglePost.result.images.length == 0
                          ? FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return VideoPlayer(
                                        video: getSinglePost.result.video,
                                      );
                                    },
                                  ),
                                );
                              },
                              padding: EdgeInsets.all(0),
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        CachedNetworkImage(
                                            imageUrl: getSinglePost
                                                .result.videoThumb),
                                        IconButton(
                                          icon: Icon(
                                            Icons.play_circle_outline,
                                            color: Colors.white,
                                          ),
                                          iconSize: 64,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return VideoPlayer(
                                                    video: getSinglePost
                                                        .result.video,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    // ListTile(
                                    //   title: Text(_li),
                                    //   subtitle: Text(Uri.parse(video.videoImageUrl).host),
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          : Expanded(
                              child: PageView.builder(
                                controller: PageController(
                                  viewportFraction: 0.5,
                                  initialPage: 0,
                                ),
                                itemCount: getSinglePost.result.images.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: <Widget>[
                                      Container(
                                        child: Image.network(getSinglePost
                                            .result.images[index].original),
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            int uid = prefs.getInt('uid');
                                            print(uid);
                                            FormData formData =
                                                FormData.fromMap({
                                              'user_id': uid,
                                              'post_id': widget.post_id,
                                              'url': getSinglePost.result
                                                  .images[index].original,
                                            });
                                            const url =
                                                'https://www.mustdiscovertech.co.in/social/v1/';
                                            Dio dio = new Dio();
                                            try {
                                              Response response =
                                                  await dio.post(
                                                      '${url}post/pfiledelete',
                                                      data: formData);
                                              print(response);

                                              getPost();

                                              setState(() {
                                                _isLoading = false;
                                              });
                                            } on DioError catch (e) {
                                              print(e.error);
                                              throw (e.error);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                      getSinglePost.result.images.length != 0
                          ? Expanded(
                              child: Column(
                                children: <Widget>[
                                  GFButton(
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    onPressed: () {
                                      _handleImage();
                                    },
                                    text: "Add ",
                                  ),
                                  _files.length != 0
                                      ? Expanded(
                                          child: PageView.builder(
                                              itemCount: _files.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      FlatButton(
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        onPressed: () async {
                                                          var image = imageLib
                                                              .decodeImage(_files[
                                                                      index]
                                                                  .readAsBytesSync());
                                                          image = imageLib
                                                              .copyResize(image,
                                                                  width: 600);
                                                          String fileName =
                                                              basename(
                                                                  _files[index]
                                                                      .path);

                                                          Map imagefile =
                                                              await Navigator
                                                                  .push(
                                                            context,
                                                            new MaterialPageRoute(
                                                              builder: (context) =>
                                                                  new PhotoFilterSelector(
                                                                title: Text(
                                                                    "Photo Filter Example"),
                                                                image: image,
                                                                filters:
                                                                    presetFiltersList,
                                                                filename:
                                                                    fileName,
                                                                loader: Center(
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          );
                                                          if (imagefile !=
                                                                  null &&
                                                              imagefile.containsKey(
                                                                  'image_filtered')) {
                                                            setState(() {
                                                              _files[index] =
                                                                  imagefile[
                                                                      'image_filtered'];
                                                            });
                                                            uploadList[index] =
                                                                await MultipartFile.fromFile(
                                                                    _files[index]
                                                                        .path,
                                                                    filename:
                                                                        fileName);
                                                            print(_files[index]
                                                                .path);
                                                          }
                                                        },
                                                        child: Image.file(
                                                          _files[index],
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.cancel,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _files.removeAt(
                                                                index);
                                                            uploadList.removeAt(
                                                                index);
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              controller: PageController(
                                                viewportFraction: 0.85,
                                                initialPage: 0,
                                              )),
                                        )
                                      : Container(),
                                ],
                              ),
                            )
                          : Container(),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: TextField(
                                          controller: _captionController,
                                          style: TextStyle(fontSize: 18.0),
                                          decoration: InputDecoration(
                                            labelText: 'Caption',
                                          ),
                                          onChanged: (input) =>
                                              _caption = input,
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
                                                _captionController.text +
                                                    emoji.emoji;
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: TextField(
                                          controller: _decriptionController,
                                          style: TextStyle(fontSize: 18.0),
                                          decoration: InputDecoration(
                                            labelText: 'Description',
                                          ),
                                          onChanged: (input) =>
                                              _description = input,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.insert_emoticon),
                                      onPressed: () {
                                        setState(() {
                                          showEmojiDescription =
                                              !showEmojiDescription;
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
                                                _decriptionController.text +
                                                    emoji.emoji;
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: TextField(
                                          controller: _locationController,
                                          style: TextStyle(fontSize: 18.0),
                                          decoration: InputDecoration(
                                            labelText: 'Location',
                                          ),
                                          onChanged: (input) =>
                                              _location = input,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30.0),
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
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
