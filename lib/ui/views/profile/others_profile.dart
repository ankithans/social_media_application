import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/ui/views/posts/single_post_view.dart';

import 'package:social_media_application/models/profile/others_profile.dart';
import 'package:social_media_application/repositories/api_client.dart';
import 'package:social_media_application/repositories/api_repositories.dart';
import 'package:social_media_application/models/profile/profile.dart';
import 'package:social_media_application/ui/views/profile/following.dart';

Profile _profile;
List images = new List();

class OthersProfile extends StatefulWidget {
  final int userId;
  final bool following;

  const OthersProfile({Key key, this.userId, this.following}) : super(key: key);

  @override
  _OthersProfileState createState() => _OthersProfileState();
}

class _OthersProfileState extends State<OthersProfile> {
  ProfileOthers profileOthers;
  bool _progress = false;
  final ApiRepository apiRepository = ApiRepository(
    apiClient: ApiClient(),
  );
  bool _isLoading = false;

  void getProfile() async {
    setState(() {
      _isLoading = true;
    });
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // int uid = prefs.getInt('uid');

    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int uid = prefs.getInt('uid');
    FormData formData = FormData.fromMap({
      'login_user_id': uid,
      'user_id': widget.userId,
    });

    try {
      Response response =
          await dio.post('${url}user/profile/other', data: formData);
      profileOthers = ProfileOthers.fromJson(response.data);
      print(response);
    } on DioError catch (e) {
      print(e.error);
      throw e.error;
    }

    _profile = await apiRepository.getProfile(widget.userId);
    print(_profile);
    // addPic();
    images = [];
    listImages();

    setState(() {
      _isLoading = false;
    });
  }

  // void addPic() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('pic', _profile.result.pic);
  // }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void listImages() async {
    for (var i = 0; i < _profile.result.posts.length; i++) {
      images.add(
        PhotoView(
          imageProvider: _profile.result.posts[i].images.length != 0
              ? NetworkImage(_profile.result.posts[i].images[0].thumbnail)
              : NetworkImage(_profile.result.posts[i].videoThumb),
          loadingBuilder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }

  Future _refresh() async {
    getProfile();
  }

  Color calculateTextColor(Color background) {
    return background.computeLuminance() >= 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   centerTitle: true,
      //   // title: Text(
      //   //   'Profile',
      //   //   style: GoogleFonts.poppins(
      //   //     fontWeight: FontWeight.w500,
      //   //   ),
      //   // ),
      //   backgroundColor: Color(0xFFFF8B66),
      //   leading: Icon(
      //     Icons.person,
      //     color: Colors.white,
      //   ),

      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(
      //         Icons.edit,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => EditProfileScreen(),
      //             )).whenComplete(() => {getProfile()});
      //       },
      //     ),
      //   ],
      // ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: !_isLoading
            ? SingleChildScrollView(
                physics: ScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xFFFF8B66),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                bottom: 16,
                              ),
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        NetworkImage(_profile.result.pic),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        _profile.result.name,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        // width:
                                        //     MediaQuery.of(context).size.width *
                                        //         0.50,
                                        child: Text(
                                          _profile.result.bio,
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey[200],
                                            fontSize: 13,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        left: 15,
                                        right: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFffb399),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          _buildPosts("Posts"),
                                          _buildFollowers("Followers"),
                                          _buildFollowing("Following"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: FlatButton.icon(
                                      label: _progress == true
                                          ? SpinKitThreeBounce(
                                              color: Colors.white,
                                              size: 15,
                                            )
                                          : Text(
                                              profileOthers.result.follow == 1
                                                  ? 'Unfollow'
                                                  : 'Follow',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                              ),
                                            ),
                                      icon: _progress == true
                                          ? Icon(null)
                                          : Icon(
                                              profileOthers.result.follow == 1
                                                  ? Icons.remove_circle_outline
                                                  : Icons.person_add,
                                              color: Colors.white,
                                            ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color: Color(0xFFffd9cc),
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _progress = true;
                                        });
                                        const url =
                                            'https://www.mustdiscovertech.co.in/social/v1/';
                                        Dio dio = new Dio();
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        int uid = prefs.getInt('uid');
                                        FormData formData = FormData.fromMap({
                                          'follow_by': uid,
                                          'follow_to': widget.userId,
                                        });

                                        try {
                                          Response response = await dio.post(
                                              '${url}user/follow',
                                              data: formData);
                                          print(response);
                                        } on DioError catch (e) {
                                          setState(() {
                                            _progress = false;
                                          });
                                          print(e.error);
                                          throw e.error;
                                        }

                                        FormData formData1 = FormData.fromMap({
                                          'login_user_id': uid,
                                          'user_id': widget.userId,
                                        });

                                        try {
                                          Response response = await dio.post(
                                              '${url}user/profile/other',
                                              data: formData1);
                                          setState(() {
                                            profileOthers =
                                                ProfileOthers.fromJson(
                                                    response.data);
                                          });
                                          setState(() {
                                            _progress = false;
                                          });
                                          print(response);
                                        } on DioError catch (e) {
                                          setState(() {
                                            _progress = false;
                                          });
                                          print(e.error);
                                          throw e.error;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      // Container(
                      //   width: double.infinity,
                      //   padding: EdgeInsets.all(0),
                      //   margin: EdgeInsets.all(0),
                      //   child: Image.network(_profile.result.pic),
                      // ),
                      // Stack(
                      //   alignment: Alignment.bottomLeft,
                      //   children: <Widget>[
                      //     Stack(
                      //       children: <Widget>[
                      //         Align(
                      //           alignment: Alignment.center,
                      //           child: Column(
                      //             children: <Widget>[
                      //               CircleAvatar(
                      //                 backgroundImage: NetworkImage(
                      //                   _profile.result.pic,
                      //                   // width: displayWidth(context),
                      //                   // fit: BoxFit.fitWidth,
                      //                   // height: displayHeight(context) * 0.30,
                      //                 ),
                      //               ),
                      //               SizedBox(
                      //                 height: 50,
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     Positioned(
                      //       top: 90,
                      //       left: 10,
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(14.0),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: <Widget>[
                      //             Text(
                      //               _profile.result.name,
                      //               style: GoogleFonts.poppins(
                      //                 fontWeight: FontWeight.w600,
                      //                 fontSize: 22,
                      //                 color: Colors.white,
                      //               ),
                      //             ),
                      //             SizedBox(height: 3),
                      //             Container(
                      //               width:
                      //                   MediaQuery.of(context).size.width * 0.8,
                      //               child: Text(
                      //                 _profile.result.bio,
                      //                 style: GoogleFonts.poppins(
                      //                   color: Colors.white,
                      //                   height: 1,
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     Padding(
                      //       padding: EdgeInsets.symmetric(horizontal: 20),
                      //       child: Container(
                      //         padding: EdgeInsets.only(
                      //           top: 8,
                      //           bottom: 8,
                      //           left: 15,
                      //           right: 15,
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Color(0xFFFF8B66),
                      //           borderRadius: BorderRadius.circular(8),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: <Widget>[
                      //             _buildPosts("Posts"),
                      //             _buildFollowers("Followers"),
                      //             _buildFollowing("Following"),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

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
                        height: 0,
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
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SinglePostView(
                                          count: index,
                                          profile: _profile,
                                          showEditDel: false,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: images[index],
                                  ),
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
            : Center(
                child: SpinKitThreeBounce(
                  color: Color(0xFFFF8B66),
                ),
              ),
      ),
    );
  }

  Widget _buildPosts(String title) {
    return FlatButton(
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Following(),
        //   ),
        // );
      },
      child: Column(
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
      ),
    );
  }

  Widget _buildFollowers(String title) {
    return FlatButton(
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Following(),
        //   ),
        // );
      },
      child: Column(
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
      ),
    );
  }

  Widget _buildFollowing(String title) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Following(),
          ),
        );
      },
      child: Column(
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
      ),
    );
  }
}
