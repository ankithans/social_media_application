import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/profile/search_users.dart';
import 'package:social_media_application/ui/views/profile/search_users.dart';
import 'package:social_media_application/utils/ui_utils.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _isLoading = false;
  SearchUsers _searchUsers;

  void searchUsers() async {
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
      Response response = await dio.post('${url}user/listing', data: formData);
      print(response);
      _searchUsers = SearchUsers.fromJson(response.data);
      setState(() {
        _isLoading = false;
      });
    } on DioError catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.error);
      throw e.error;
    }
  }

  @override
  void initState() {
    super.initState();
    if (_searchUsers == null) searchUsers();
  }

  @override
  void dispose() {
    // DO STUFF
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[50],
        title: Container(
          decoration: BoxDecoration(
              color: AppColors.darkColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              )),
          child: _isLoading == false
              ? SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: SearchDistricts(_searchUsers),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.search),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Search Users',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),

          // child: TextField(
          //   decoration: InputDecoration(
          //     border: InputBorder.none,
          //     prefixIcon: Icon(
          //       FlutterIcons.search,
          //       color: Colors.black,
          //     ),
          //     hintText: "Search",
          //     hintStyle: TextStyle(
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: SpinKitThreeBounce(
                color: Color(0xFFFF8B66),
              ),
            )
          : Container(),
    );
  }
}
