import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/repositories/api_client.dart';
import 'package:social_media_application/repositories/api_repositories.dart';
import 'package:social_media_application/models/profile/profile.dart';
import 'package:social_media_application/ui/views/profile/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiRepository apiRepository = ApiRepository(
    apiClient: ApiClient(),
  );
  Profile _profile;
  bool _isLoading = false;

  void getProfile() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int uid = prefs.getInt('uid');
    _profile = await apiRepository.getProfile(uid);
    print(_profile);
    images = [];
    listImages();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  List images = new List();
  void listImages() async {
    for (var i = 0; i < _profile.result.posts.length; i++) {
      images.add(
        CachedNetworkImage(
          imageUrl: _profile.result.posts[i].images[0].thumbnail,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(
              value: downloadProgress.progress,
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      );
    }
  }

  static Random random = Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.grey[50],
        leading: Icon(
          Icons.camera,
          color: Colors.black,
          size: 30,
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.meriendaOne(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return IconButton(
              color: Colors.black,
              icon: Icon(OMIcons.nearMe),
              onPressed: () => {},
            );
          }),
        ],
      ),
      body: !_isLoading
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    CircleAvatar(
                      backgroundImage: NetworkImage(_profile.result.pic),
                      radius: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      _profile.result.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      _profile.result.bio,
                      style: GoogleFonts.poppins(),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlatButton(
                          child: Icon(
                            Icons.message,
                            color: Colors.white,
                          ),
                          color: Colors.grey,
                          onPressed: () {},
                        ),
                        SizedBox(width: 10),
                        FlatButton(
                          child: Text(
                            'Edit',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(),
                                )).whenComplete(() => {getProfile()});
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildPosts("Posts"),
                          _buildFollowers("Followers"),
                          _buildFollowing("Following"),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      primary: false,
                      padding: EdgeInsets.all(5),
                      itemCount: images.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 200 / 200,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: images[index],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPosts(String title) {
    return Column(
      children: <Widget>[
        Text(
          '${_profile.result.noOfPost}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.poppins(),
        ),
      ],
    );
  }

  Widget _buildFollowers(String title) {
    return Column(
      children: <Widget>[
        Text(
          '${_profile.result.followers}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.poppins(),
        ),
      ],
    );
  }

  Widget _buildFollowing(String title) {
    return Column(
      children: <Widget>[
        Text(
          '${_profile.result.following}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(),
        ),
      ],
    );
  }
}
