import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/posts/like_posts.dart';
import 'package:social_media_application/models/posts/lists_posts.dart';

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
          centerTitle: true,
          title: Text(
            'Home Screen',
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
              ));
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

  List images = new List();
  void listImages() async {
    for (var i = 0; i < _listPosts.result[widget.count].images.length; i++) {
      images.add(
        CachedNetworkImage(
          imageUrl: _listPosts.result[widget.count].images[i].original,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                      Text(_listPosts.result[widget.count].author[0]),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 200.0,
                          width: 350.0,
                          child: Carousel(
                            images: images,
                            dotSize: 4.0,
                            dotSpacing: 15.0,
                            dotColor: Colors.lightGreenAccent,
                            indicatorBgPadding: 5.0,
                            borderRadius: true,
                            autoplay: false,
                          ),
                        ),
                      ],
                    ),
                    onDoubleTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _listPosts.result[widget.count].title,
                      style: GoogleFonts.poppins(),
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
