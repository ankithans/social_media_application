import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/repositories/api_client.dart';
import 'package:social_media_application/repositories/api_repositories.dart';
import 'package:social_media_application/models/profile/following.dart';
import 'package:social_media_application/ui/views/profile/following_card.dart';

class Following extends StatefulWidget {
  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  final ApiRepository apiRepository = ApiRepository(
    apiClient: ApiClient(),
  );

  GetFollowing _following;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getFollowing();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Following',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading == false
          ? GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              primary: false,
              itemCount: _following.result.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(_following.result[index].pic),
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
                                  ProgressDialog(context, isDismissible: false);
                              await pr.show();

                              const url =
                                  'https://www.mustdiscovertech.co.in/social/v1/';
                              Dio dio = new Dio();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              int uid = prefs.getInt('uid');
                              FormData formData = FormData.fromMap({
                                'follow_by': uid,
                                'follow_to': _following.result[index].userId,
                              });

                              try {
                                Response response = await dio
                                    .post('${url}user/follow', data: formData);
                                print(response);
                              } on DioError catch (e) {
                                print(e.error);
                                throw e.error;
                              }

                              FormData formData1 = FormData.fromMap({
                                'user_id': uid,
                              });

                              try {
                                Response response = await dio.post(
                                    '${url}user/following',
                                    data: formData1);
                                print(response);

                                setState(() {
                                  _following =
                                      GetFollowing.fromJson(response.data);
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
                              borderRadius: BorderRadius.circular(20),
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
    );
  }
}
