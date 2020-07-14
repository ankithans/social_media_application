import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/posts/like_posts.dart';
import 'package:social_media_application/models/posts/lists_posts.dart';
import 'package:social_media_application/ui/views/profile/profilePage.dart';
import 'package:social_media_application/ui/widgets/zoom_overlay.dart';
import 'package:social_media_application/utils/sizes_helpers.dart';

ListPosts _listPosts;
int uid;

class HomeFeeds extends StatefulWidget {
  @override
  _HomeFeedsState createState() => _HomeFeedsState();
}

class _HomeFeedsState extends State<HomeFeeds> {
  @override
  void initState() {
    super.initState();
    listPosts();
  }

  bool _isLoading = false;

  Future<ListPosts> listPosts() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getInt('uid');
    print(uid);
    FormData formData = FormData.fromMap({
      'user_id': uid,
    });
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    try {
      Response response = await dio.post('${url}post/listing', data: formData);
      print(response);

      _listPosts = ListPosts.fromJson(response.data);
      setState(() {
        _isLoading = false;
      });
      return ListPosts.fromJson(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

  final _posts = <ListPosts>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Social Media',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color(0xFFFF8B66),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.menu,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {},
        // ),
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
      body: !_isLoading
          ? ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _listPosts.result.length,
              itemBuilder: (BuildContext context, int index) {
                return SinglePostView(
                  count: index,
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Container(
          color: Color(0xFFFF8B66),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 30,
            ),
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Ankit Hans',
                        style: GoogleFonts.poppins(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Her Bio will come',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: Text(
                    'My Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.local_activity,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Activity',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Notifications',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Friends',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Messages',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Settings',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SinglePostView extends StatefulWidget {
  final int count;

  const SinglePostView({Key key, this.count}) : super(key: key);
  @override
  _SinglePostViewState createState() => _SinglePostViewState();
}

class _SinglePostViewState extends State<SinglePostView> {
  bool _isLoading = false;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    listImages();
  }

  Future<ListPosts> listPosts() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getInt('uid');
    print(uid);
    FormData formData = FormData.fromMap({
      'user_id': uid,
    });
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    try {
      Response response = await dio.post('${url}post/listing', data: formData);
      print(response);

      _listPosts = ListPosts.fromJson(response.data);
      setState(() {
        _isLoading = false;
      });
      return ListPosts.fromJson(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

  int _currentImageIndex = 0;
  final StreamController<void> _doubleTapImageEvents =
      StreamController.broadcast();

  // void _onDoubleTapLikePhoto() {
  //   setState(() => widget.post.addLikeIfUnlikedFor(currentUser));
  //   _doubleTapImageEvents.sink.add(null);
  // }

  List<Widget> images = new List();
  List<String> img = new List();
  void listImages() async {
    for (var i = 0; i < _listPosts.result[widget.count].images.length; i++) {
      img.add(_listPosts.result[widget.count].images[i].original);
      images.add(
        ZoomOverlay(
          twoTouchOnly: true,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              fit: BoxFit.fitWidth,
              imageUrl: _listPosts.result[widget.count].images[i].original,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      );
    }
  }

  CarouselController buttonCarouselController = CarouselController();
  int _currentIndex = 0;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            _listPosts.result[widget.count].author[1]),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        _listPosts.result[widget.count].author[0],
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // GestureDetector(
                  //   child: Stack(
                  //     alignment: Alignment.center,
                  //     children: <Widget>[
                  //       SizedBox(
                  //         height: 220.0,
                  //         child: Carousel(
                  //           images: images,
                  //           dotSize: 4.0,
                  //           dotSpacing: 15.0,
                  //           dotColor: Colors.lightGreenAccent,
                  //           indicatorBgPadding: 5.0,
                  //           borderRadius: true,
                  //           autoplay: false,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  //   onDoubleTap: () {},
                  // ),
                  // CarouselSlider(
                  //   items: images,
                  //   carouselController: buttonCarouselController,
                  //   options: CarouselOptions(
                  //     height: 250,
                  //     autoPlay: false,
                  //     enlargeCenterPage: true,
                  //     viewportFraction: 1,
                  //     aspectRatio: 2.0,
                  //     initialPage: 1,

                  //     pauseAutoPlayInFiniteScroll: false,
                  //     enableInfiniteScroll: false,
                  //     onPageChanged: (index, reason) {
                  //       setState(() {
                  //         _currentIndex = index;
                  //       });
                  //     },
                  //   ),
                  // ),

                  GFCarousel(
                    items: images,
                    activeIndicator: Colors.black,
                    passiveIndicator: Colors.grey,
                    enableInfiniteScroll: false,
                    enlargeMainPage: true,
                    viewportFraction: 1.0,
                    height: 200,
                    scrollPhysics: BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(images, (index, url) {
                      return Container(
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _listPosts.result[widget.count].title,
                          style: GoogleFonts.poppins(),
                        ),
                        Text(
                          _listPosts.result[widget.count].description,
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: _isLiked
                            ? Icon(
                                OMIcons.favorite,
                                color: Colors.red,
                                size: 28,
                              )
                            : Icon(
                                OMIcons.favoriteBorder,
                                color: Colors.black,
                                size: 28,
                              ),
                        onPressed: () async {
                          setState(() {
                            _isLiked = !_isLiked;
                          });
                          FormData formData = FormData.fromMap({
                            'user_id': uid,
                            'post_id': _listPosts.result[widget.count].postId,
                          });
                          const url =
                              'https://www.mustdiscovertech.co.in/social/v1/';
                          Dio dio = new Dio();
                          try {
                            Response response = await dio
                                .post('${url}post/like', data: formData);
                            print(response);
                            LikePosts likePosts =
                                LikePosts.fromJson(response.data);
                            if (likePosts.result == 1) {
                              setState(() {
                                _isLiked = true;
                              });
                            } else {
                              setState(() {
                                _isLiked = false;
                              });
                            }
                          } on DioError catch (e) {
                            print(e.error);
                            throw (e.error);
                          }
                        },
                      ),
                      IconButton(
                          icon: Icon(
                            OMIcons.chatBubbleOutline,
                          ),
                          onPressed: () {})
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
