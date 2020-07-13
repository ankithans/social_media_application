import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              itemCount: 5,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FollowingCard(
                    getfollowing: _following,
                    index: index,
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
