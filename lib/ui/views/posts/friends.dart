import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/chat/user_friends_list.dart';
import 'package:social_media_application/models/profile/following.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  bool _isLoading = false;
  UserFriendList userFriendList;
  GetFollowing _following;
  GetFollowing _followers;

  // void getUserFriendList() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   const url = 'https://www.mustdiscovertech.co.in/social/v1/';
  //   Dio dio = new Dio();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   int uid = prefs.getInt('uid');
  //   FormData formData = FormData.fromMap({
  //     'user_id': uid,
  //   });

  //   try {
  //     Response response = await dio.post('${url}user/friends', data: formData);
  //     print(response);

  //     userFriendList = UserFriendList.fromJson(response.data);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   } on DioError catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     print(e.error);
  //     throw (e.error);
  //   }
  // }

  void getFollowing() async {
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int uid = prefs.getInt('uid');
    FormData formData = FormData.fromMap({
      'user_id': uid,
    });

    try {
      setState(() {
        _isLoading = true;
      });
      Response response =
          await dio.post('${url}user/following', data: formData);
      print(response);

      _following = GetFollowing.fromJson(response.data);
      setState(() {
        _isLoading = false;
      });
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

  void getFollowers() async {
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int uid = prefs.getInt('uid');
    FormData formData = FormData.fromMap({
      'user_id': uid,
    });

    try {
      setState(() {
        _isLoading = true;
      });
      Response response =
          await dio.post('${url}user/followers', data: formData);
      print(response);

      _followers = GetFollowing.fromJson(response.data);
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
    // getUserFriendList();
    getFollowing();
    getFollowers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFF8B66),
            leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () => Navigator.pop(context),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text('Following'),
                ),
                Tab(
                  child: Text('Suggestions'),
                ),
              ],
            ),
            title: Text('Friends'),
            centerTitle: true,
          ),
          body: _isLoading
              ? Center(
                  child: SpinKitThreeBounce(
                    color: Color(0xFFFF8B66),
                  ),
                )
              : TabBarView(
                  children: [
                    _isLoading == false
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            primary: false,
                            itemCount: _following.result.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF8B66),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                _following.result[index].pic),
                                          ),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              _following.result[index].name,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              _following.result[index].bio,
                                              maxLines: 4,
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey[300],
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                        RaisedButton(
                                          onPressed: () async {
                                            final ProgressDialog pr =
                                                ProgressDialog(context,
                                                    isDismissible: false);
                                            await pr.show();

                                            const url =
                                                'https://www.mustdiscovertech.co.in/social/v1/';
                                            Dio dio = new Dio();
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            int uid = prefs.getInt('uid');
                                            FormData formData =
                                                FormData.fromMap({
                                              'follow_by': uid,
                                              'follow_to': _following
                                                  .result[index].userId,
                                            });

                                            try {
                                              Response response = await dio
                                                  .post('${url}user/follow',
                                                      data: formData);
                                              print(response);
                                            } on DioError catch (e) {
                                              print(e.error);
                                              throw e.error;
                                            }

                                            FormData formData1 =
                                                FormData.fromMap({
                                              'user_id': uid,
                                            });

                                            try {
                                              Response response = await dio
                                                  .post('${url}user/following',
                                                      data: formData1);
                                              print(response);

                                              setState(() {
                                                _following =
                                                    GetFollowing.fromJson(
                                                        response.data);
                                              });
                                              await pr.hide();
                                            } on DioError catch (e) {
                                              await pr.hide();

                                              print(e.error);
                                              throw (e.error);
                                            }
                                          },
                                          elevation: 0,
                                          padding: EdgeInsets.all(0),
                                          color: Color(0xFFFF8B66),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            side: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: Text(
                                            'Unfollow',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                    _isLoading == false
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            primary: false,
                            itemCount: _followers.result.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF8B66),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                _followers.result[index].pic),
                                          ),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              _followers.result[index].name,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              _followers.result[index].bio,
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey[300],
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                        RaisedButton(
                                          onPressed: () async {
                                            final ProgressDialog pr =
                                                ProgressDialog(context,
                                                    isDismissible: false);
                                            await pr.show();

                                            // setState(() {
                                            //   _progress = true;
                                            // });
                                            const url =
                                                'https://www.mustdiscovertech.co.in/social/v1/';
                                            Dio dio = new Dio();
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            int uid = prefs.getInt('uid');
                                            FormData formData =
                                                FormData.fromMap({
                                              'follow_by': uid,
                                              'follow_to': _followers
                                                  .result[index].userId,
                                            });

                                            try {
                                              Response response = await dio
                                                  .post('${url}user/follow',
                                                      data: formData);
                                              print(response);
                                            } on DioError catch (e) {
                                              // setState(() {
                                              //   _progress = false;
                                              // });
                                              print(e.error);
                                              throw e.error;
                                            }

                                            FormData formData1 =
                                                FormData.fromMap({
                                              'user_id': uid,
                                            });

                                            try {
                                              Response response = await dio
                                                  .post('${url}user/followers',
                                                      data: formData1);
                                              print(response);

                                              setState(() {
                                                _followers =
                                                    GetFollowing.fromJson(
                                                        response.data);
                                              });
                                              // setState(() {
                                              //   _progress = false;
                                              // });
                                              await pr.hide();
                                            } on DioError catch (e) {
                                              await pr.hide();

                                              // setState(() {
                                              //   _progress = false;
                                              // });
                                              print(e.error);
                                              throw (e.error);
                                            }
                                          },
                                          elevation: 0,
                                          padding: EdgeInsets.all(0),
                                          color: Color(0xFFFF8B66),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            side: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: Text(
                                            _followers.result[index].follow == 1
                                                ? 'Unfollow'
                                                : 'Follow',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
