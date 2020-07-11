import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/posts/post_default.dart';
import 'package:social_media_application/repositories/api_client.dart';
import 'package:social_media_application/repositories/api_repositories.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:dio/dio.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _image;
  TextEditingController _captionController = TextEditingController();
  TextEditingController _decriptionController = TextEditingController();
  String _caption = '';
  String _description = '';
  bool _isLoading = false;

  final ApiRepository apiRepository = ApiRepository(
    apiClient: ApiClient(),
  );

  PostDefault postDefault;

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Add Photo'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Take Photo'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: Text('Choose From Gallery'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  _androidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Add Photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Take Photo'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text('Choose From Gallery'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  List<File> _files;
  List<MultipartFile> uploadList = new List<MultipartFile>();
  List<Asset> assets = [];

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    // File imageFile = await ImagePicker.pickImage(source: source);
    // if (imageFile != null) {
    //   imageFile = await _cropImage(imageFile);
    //   setState(() {
    //     _image = imageFile;
    //   });
    // }

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

    // for (var imageFiles in files) {
    //   fileName = imageFiles.path.split('/').last;
    //   uploadList.add(
    //       await MultipartFile.fromFile(imageFiles.path, filename: fileName));
    // }
  }

  String fileName;

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return croppedImage;
  }

  _submit() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int uid = prefs.getInt('uid');

      // Create post
      FormData formData = FormData.fromMap({
        'user_id': uid,
        'title': _captionController.text,
        'photo': uploadList,
        'description': _decriptionController.text,
      });
      const url = 'https://www.mustdiscovertech.co.in/social/v1/';
      Dio dio = new Dio();
      try {
        Response response = await dio.post('${url}post/upload', data: formData);
        print(response);

        FlutterToast.showToast(msg: 'Your post is uploaded successfully!');
        // Reset data
        _captionController.clear();

        setState(() {
          _caption = '';
          _image = null;
          _isLoading = false;
        });

        return PostDefault.fromJson(response.data);
      } on DioError catch (e) {
        print(e.error);
        FlutterToast.showToast(msg: 'Not able to upload your post');

        throw (e.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create Post',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              if (_captionController.text == '') {
                FlutterToast.showToast(
                    msg: 'Please Enter a Caption for your post');
              } else {
                _submit();
              }
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: height,
            child: Column(
              children: <Widget>[
                _isLoading
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.blue[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      )
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: _showSelectImageDialog,
                  child: Container(
                    height: width,
                    width: width,
                    color: Colors.grey[300],
                    child: _image == null
                        ? Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 150.0,
                          )
                        : Image(
                            image: FileImage(_image),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
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
                Padding(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
