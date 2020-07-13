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
import 'package:social_media_application/utils/sizes_helpers.dart';

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
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color(0xFFFF8B66),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
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
      body: !_isLoading
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Container(
                    //   width: double.infinity,
                    //   padding: EdgeInsets.all(0),
                    //   margin: EdgeInsets.all(0),
                    //   child: Image.network(_profile.result.pic),
                    // ),
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: <Widget>[
                                  Image.network(
                                    _profile.result.pic,
                                    width: displayWidth(context),
                                    fit: BoxFit.fitWidth,
                                    height: displayHeight(context) * 0.30,
                                  ),
                                  SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 110,
                          left: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _profile.result.name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  _profile.result.bio,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: 15,
                              right: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFFF8B66),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _buildPosts("Posts"),
                                _buildFollowers("Followers"),
                                _buildFollowing("Following"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // SizedBox(height: 10),

                    // SizedBox(height: 20),
                    // Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: <Widget>[
                    //     FlatButton(
                    //       child: Icon(
                    //         Icons.message,
                    //         color: Colors.white,
                    //       ),
                    //       color: Colors.grey,
                    //       onPressed: () {},
                    //     ),
                    //     SizedBox(width: 10),
                    //     FlatButton(
                    //       child: Text(
                    //         'Edit',
                    //         style: GoogleFonts.poppins(color: Colors.white),
                    //       ),
                    //       color: Theme.of(context).accentColor,
                    //       onPressed: () {

                    //       },
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '   Posts',
                            style: GoogleFonts.poppins(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            primary: false,
                            itemCount: images.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.5,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.all(5.0),
                                child: images[index],
                              );
                            },
                          ),
                        ],
                      ),
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
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
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
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
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
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
