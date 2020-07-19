import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/notifications/notifications_listing.dart';

NotificationListing notificationListing;

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool _isLoading = false;

  void listNotifications() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int uid = prefs.getInt('uid');
    FormData formData = FormData.fromMap({
      'user_id': uid,
    });
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    try {
      Response response =
          await dio.post('${url}notify/listing', data: formData);
      print(response);
      setState(() {
        notificationListing = NotificationListing.fromJson(response.data);
      });
      setState(() {
        _isLoading = false;
      });
    } on DioError catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.error);
      throw (e.error);
    }
  }

  @override
  void initState() {
    super.initState();
    if (notificationListing == null) listNotifications();
  }

  Future _refresh() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // int uid = prefs.getInt('uid');
    // FormData formData = FormData.fromMap({
    //   'user_id': uid,
    // });
    // const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    // Dio dio = new Dio();
    // try {
    //   Response response =
    //       await dio.post('${url}notify/listing', data: formData);
    //   print(response);
    //   setState(() {
    //     notificationListing = NotificationListing.fromJson(response.data);
    //   });
    // } on DioError catch (e) {
    //   print(e.error);
    //   throw (e.error);
    // }
    listNotifications();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Notifications',
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
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Stack(
            children: <Widget>[
              _isLoading == false
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(10),
                      // separatorBuilder: (BuildContext context, int index) {
                      //   return Align(
                      //     alignment: Alignment.centerRight,
                      //     child: Container(
                      //       height: 0.5,
                      //       width: MediaQuery.of(context).size.width / 1.3,
                      //       child: Divider(),
                      //     ),
                      //   );
                      // },
                      itemCount: notificationListing.result.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FlatButton(
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ,))
                          },
                          padding: EdgeInsets.all(0),
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 15, top: 10, bottom: 10),
                              child: Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[400],
                                          offset: Offset(0.0, 1.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 45.0,
                                        right: 5,
                                        top: 12,
                                        bottom: 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              notificationListing
                                                  .result[index].title,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              notificationListing
                                                  .result[index].description,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            notificationListing
                                                .result[index].postedAt,
                                            style: GoogleFonts.poppins(
                                              fontSize: 9,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: -10,
                                    top: 9,
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          notificationListing
                                              .result[index].image),
                                    ),
                                  ),
                                ],
                              )),
                        );
                      },
                    )
                  : Center(
                      child: SpinKitThreeBounce(
                        color: Color(0xFFFF8B66),
                      ),
                    ),
            ],
          ),
        ));
  }
}
