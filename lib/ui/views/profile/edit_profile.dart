import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/profile/profile.dart';
import 'package:social_media_application/models/profile/profile_update_result.dart';
import 'package:social_media_application/models/user.dart';
import 'package:social_media_application/repositories/api_client.dart';
import 'package:social_media_application/repositories/api_repositories.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ApiRepository apiRepository = ApiRepository(
    apiClient: ApiClient(),
  );
  final ApiClient apiClent = ApiClient();
  Profile _profile;
  bool _isLoading = false;
  ProfileUpdate _profileUpdate;
  String _name = '';
  String _bio = '';

  final _formKey = GlobalKey<FormState>();
  File profileImage;

  void getProfile() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int uid = prefs.getInt('uid');
    _profile = await apiRepository.getProfile(uid);
    print(_profile);
    setState(() {
      _isLoading = false;
    });
  }

  void editProfile() async {}

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void addUserDetails(String name, String bio, String picurl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('bio', bio);
    prefs.setString('pic', picurl);
  }

  String fileName;
  var imageFile;
  _handleImageFromGallery() async {
    final picker = ImagePicker();
    imageFile = await picker.getImage(source: ImageSource.gallery);
    fileName = imageFile.path.split('/').last;

    if (imageFile != null) {
      File croppedImage = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      );

      setState(() {
        profileImage = croppedImage;
      });
    }
  }

  _displayProfileImage() {
    // No new profile image
    if (profileImage == null) {
      // No existing profile image
      if (_profile.result.pic.isEmpty) {
        // Display placeholder
        return AssetImage('assets/images/user_placeholder.jpg');
      } else {
        // User profile image exists
        return CachedNetworkImageProvider(_profile.result.pic);
      }
    } else {
      // New profile image
      return FileImage(profileImage);
    }
  }

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int uid = prefs.getInt('uid');
      if (profileImage == null) {
        _profileUpdate =
            await apiRepository.UpdateProfileWithoutPic(uid, _name, _bio);
      } else {
        Response response;
        Dio dio = new Dio();
        FormData formData = new FormData.fromMap({
          "user_id": uid,
          "photo": await MultipartFile.fromFile(profileImage.path,
              filename: fileName),
          "name": _name,
          "bio": _bio
        });
        response = await dio.post(
            "https://www.mustdiscovertech.co.in/social/v1/user/update",
            data: formData);
        print(response);

        addUserDetails(_name, _bio, '');
        // _profileUpdate =
        //     await apiRepository.UpdateProfile(uid, _profileImage, _name, _bio);
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context, () {
        setState(() {});
      });
    }
  }

  // _cropImage(File imageFile) async {

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: !_isLoading
          ? GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView(
                children: <Widget>[
                  _isLoading
                      ? LinearProgressIndicator(
                          backgroundColor: Colors.blue[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        )
                      : SizedBox.shrink(),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.grey,
                            backgroundImage: _displayProfileImage(),
                          ),
                          FlatButton(
                            onPressed: _handleImageFromGallery,
                            child: Text(
                              'Change Profile Image',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 16.0),
                            ),
                          ),
                          TextFormField(
                            initialValue: _profile.result.name,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                size: 30.0,
                              ),
                              labelText: 'Name',
                            ),
                            validator: (input) => input.trim().length < 1
                                ? 'Please enter a valid name'
                                : null,
                            onSaved: (input) => _name = input,
                          ),
                          TextFormField(
                            initialValue: _profile.result.bio,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.book,
                                size: 30.0,
                              ),
                              labelText: 'Bio',
                            ),
                            validator: (input) => input.trim().length > 150
                                ? 'Please enter a bio less than 150 characters'
                                : null,
                            onSaved: (input) => _bio = input,
                          ),
                          Container(
                            margin: EdgeInsets.all(40.0),
                            height: 40.0,
                            width: 250.0,
                            child: FlatButton(
                              onPressed: _submit,
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text(
                                'Save Profile',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
