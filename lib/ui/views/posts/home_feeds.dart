import 'dart:async';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/posts/HashTagPost.dart';
import 'package:social_media_application/models/posts/listLikes.dart';
import 'package:social_media_application/models/posts/lists_posts.dart';
import 'package:social_media_application/ui/views/authentication/welcomePage.dart';
import 'package:social_media_application/ui/views/posts/comments_screen.dart';
import 'package:social_media_application/ui/views/posts/friends.dart';
import 'package:social_media_application/ui/views/posts/hashTagSearchResults.dart';
import 'package:social_media_application/ui/views/posts/video_player.dart';
import 'package:social_media_application/ui/views/profile/others_profile.dart';
import 'package:social_media_application/ui/views/profile/profilePage.dart';
import 'package:social_media_application/ui/widgets/zoom_overlay.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'example_data.dart' as Example;

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
    addUserDetails();

    if (_listPosts == null) listPosts();
  }

  @override
  void dispose() {
    // DO STUFF
    super.dispose();
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
      FlutterToast.showToast(
          msg: 'Not able to load posts at this moment. Please try again later');
      print(e.error);
      throw (e.error);
    }
  }

  String name = '';
  String bio = '';
  String pic = '';

  void addUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      bio = prefs.getString('bio');
      pic = prefs.getString('pic');
    });
  }

  Future<ListPosts> listPostsAgain() async {
    final ProgressDialog pr = ProgressDialog(context, isDismissible: false);
    setState(() {
      _isLoading = true;
    });
    await pr.show();
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
      await pr.hide();

      return ListPosts.fromJson(response.data);
    } on DioError catch (e) {
      await pr.hide();
      FlutterToast.showToast(
          msg: 'Not able to load posts at this moment. Please try again later');
      print(e.error);
      throw (e.error);
    }
  }

  Future _refresh() async {
    listPostsAgain();
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
          'Social Media',
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
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
            addUserDetails();
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
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Stack(
          children: <Widget>[
            _isLoading == false
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _listPosts.result.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SinglePostView(
                        count: index,
                      );
                    },
                  )
                : SpinKitThreeBounce(
                    color: Color(0xFFFF8B66),
                  ),
          ],
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Container(
          color: Color(0xFFFF8B66),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
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
                        backgroundImage: pic != null ? NetworkImage(pic) : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        name,
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
                        bio,
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
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ProfilePage(),
                    //   ),
                    // );
                    Navigator.pop(context);
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
                      fontSize: 15,
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
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => Notifications(),
                    //   ),
                    // );
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
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => Following(),
                    //   ),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Friends(),
                      ),
                    );
                  },
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height / 2.2,
                // ),
                ListTile(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove("isLoggedIn");
                    prefs.remove('userId');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomePage(),
                      ),
                    );
                  },
                  title: Text(
                    'Sign out',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Settings',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ProfilePage(),
                    //   ),
                    // );
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
      listLikes();

      setState(() {
        _isLoading = false;
      });
      return ListPosts.fromJson(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

  ListLikes _listLikes;

  void listLikes() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getInt('uid');
    print(uid);
    FormData formData = FormData.fromMap({
      'user_id': uid,
      'post_id': _listPosts.result[widget.count].postId,
    });
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    try {
      Response response =
          await dio.post('${url}post/like/listing', data: formData);
      print(response);
      setState(() {
        _listLikes = ListLikes.fromJson(response.data);
      });
      setState(() {
        _isLoading = false;
      });
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

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
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PhotoView(
            imageProvider: NetworkImage(
                _listPosts.result[widget.count].images[i].original),
            loadingBuilder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }
  }

  //  imageProvider: CachedNetworkImage(
  //             fit: BoxFit.fitWidth,
  //             imageUrl: _listPosts.result[widget.count].images[i].original,
  //             progressIndicatorBuilder: (context, url, downloadProgress) =>
  //                 Center(
  //               child: CircularProgressIndicator(
  //                 value: downloadProgress.progress,
  //               ),
  //             ),
  //           ),

  CarouselController buttonCarouselController = CarouselController();
  int _currentIndex = 0;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Reaction reaction;

  List hashTags = ['#ddd', '#wfwrw', '#ggd'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      _listPosts.result[widget.count].userId == uid
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(),
                              ),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OthersProfile(
                                  userId:
                                      _listPosts.result[widget.count].userId,
                                ),
                              ),
                            );
                    },
                    padding: EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                _listPosts.result[widget.count].author[1]),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _listPosts.result[widget.count].author[0],
                                style: GoogleFonts.poppins(),
                              ),
                              Text(
                                _listPosts.result[widget.count].location,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  _listPosts.result[widget.count].hashtag != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableAutoLinkText(
                            _listPosts.result[widget.count].hashtag
                                .toString()
                                .replaceAll('[', '')
                                .replaceAll(']', ''),
                            style: const TextStyle(color: Colors.black87),
                            linkStyle: const TextStyle(color: Colors.blue),
                            highlightedLinkStyle: TextStyle(
                              color: Colors.deepOrangeAccent,
                              backgroundColor:
                                  Colors.deepOrangeAccent.withAlpha(0x33),
                            ),
                            onTap: (link) async {
                              HashTagPost hashTagPost;
                              setState(() {
                                _isLoading = true;
                              });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              uid = prefs.getInt('uid');
                              print(uid);
                              FormData formData = FormData.fromMap({
                                'user_id': uid,
                                'hashtag': link,
                              });
                              const url =
                                  'https://www.mustdiscovertech.co.in/social/v1/';
                              Dio dio = new Dio();
                              try {
                                Response response = await dio.post(
                                    '${url}post/tagpostlisting',
                                    data: formData);
                                print(response);
                                setState(() {
                                  hashTagPost =
                                      HashTagPost.fromJson(response.data);
                                });
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HashTagSearch(
                                      hashTagPost: hashTagPost,
                                    ),
                                  ),
                                );
                              } on DioError catch (e) {
                                print(e.error);
                                throw (e.error);
                              }
                            },
                            linkRegExpPattern:
                                '(@[\\w]+|#[\\w]+|${AutoLinkUtils.urlRegExpPattern})',
                            onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
                            onDebugMatch: (match) {
                              // for debug
                              print(
                                  'DebugMatch:[${match.start}-${match.end}]`${match.group(0)}`');
                            },
                          ),
                        )
                      : Container(),
                  // SizedBox(
                  //   height: 8,
                  // ),
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

                  if (_listPosts.result[widget.count].images.length != 0)
                    FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {},
                      child: GFCarousel(
                        items: images,
                        activeIndicator: Colors.black,
                        passiveIndicator: Colors.grey,
                        enableInfiniteScroll: false,
                        enlargeMainPage: true,
                        viewportFraction: 1.0,
                        height: 300,
                        scrollPhysics: ScrollPhysics(),
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),

                  if (_listPosts.result[widget.count].video != null &&
                      _listPosts.result[widget.count].images.length == 0)
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return VideoPlayer(
                                video: _listPosts.result[widget.count].video,
                              );
                            },
                          ),
                        );
                      },
                      padding: EdgeInsets.all(0),
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                CachedNetworkImage(
                                    imageUrl: _listPosts
                                        .result[widget.count].videoThumb),
                                IconButton(
                                  icon: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                  ),
                                  iconSize: 64,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return VideoPlayer(
                                            video: _listPosts
                                                .result[widget.count].video,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            // ListTile(
                            //   title: Text(_li),
                            //   subtitle: Text(Uri.parse(video.videoImageUrl).host),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Builder(
                                builder: (ctx) => FlutterReactionButton(
                                  onReactionChanged: (reaction1) {
                                    setState(() {
                                      reaction = reaction1;
                                    });
                                    // Scaffold.of(ctx).showSnackBar(
                                    //   SnackBar(
                                    //     content: Text(
                                    //         'reaction selected id: ${reaction1.id}'),
                                    //   ),
                                    // );
                                  },
                                  shouldChangeReaction: true,
                                  splashColor: Colors.red,
                                  boxPosition: Position.TOP,
                                  reactions: Example.flagsReactions,
                                  initialReaction: reaction,
                                  boxColor: Colors.black.withOpacity(0.5),
                                  boxRadius: 10,
                                  boxDuration: Duration(milliseconds: 500),
                                ),
                              ),
                              // IconButton(
                              //   icon:
                              //       _listPosts.result[widget.count].userLike ==
                              //               1
                              //           ? Icon(
                              //               OMIcons.favorite,
                              //               color: Colors.red,
                              //               size: 28,
                              //             )
                              //           : Icon(
                              //               OMIcons.favoriteBorder,
                              //               color: Colors.black,
                              //               size: 28,
                              //             ),
                              //   onPressed: () async {
                              //     FormData formData = FormData.fromMap({
                              //       'user_id': uid,
                              //       'post_id':
                              //           _listPosts.result[widget.count].postId,
                              //     });
                              //     const url =
                              //         'https://www.mustdiscovertech.co.in/social/v1/';
                              //     Dio dio = new Dio();
                              //     try {
                              //       Response response = await dio.post(
                              //           '${url}post/like',
                              //           data: formData);
                              //       print(response);
                              //       setState(() {
                              //         listPosts();
                              //       });
                              //       // LikePosts likePosts =
                              //       //     LikePosts.fromJson(response.data);
                              //       listLikes();
                              //     } on DioError catch (e) {
                              //       print(e.error);
                              //       throw (e.error);
                              //     }
                              //   },
                              // ),

                              // LikeButton(
                              //   onTap: (isLiked) async {
                              //     FormData formData = FormData.fromMap({
                              //       'user_id': uid,
                              //       'post_id':
                              //           _listPosts.result[widget.count].postId,
                              //     });
                              //     const url =
                              //         'https://www.mustdiscovertech.co.in/social/v1/';
                              //     Dio dio = new Dio();
                              //     try {
                              //       Response response = await dio.post(
                              //           '${url}post/like',
                              //           data: formData);
                              //       print(response);
                              //       setState(() {
                              //         listPosts();
                              //       });
                              //       LikePosts likePosts =
                              //           LikePosts.fromJson(response.data);
                              //       listLikes();
                              //     } on DioError catch (e) {
                              //       print(e.error);
                              //       throw (e.error);
                              //     }
                              //     return isLiked;
                              //   },
                              //   circleColor: CircleColor(
                              //       start: Colors.red, end: Colors.red),
                              //   bubblesColor: BubblesColor(
                              //     dotPrimaryColor: Colors.red,
                              //     dotSecondaryColor: Colors.red,
                              //   ),
                              //   likeBuilder: (bool isLiked) {
                              //     return Icon(
                              //       Icons.favorite,
                              //       color: isLiked ? Colors.red : Colors.black,
                              //     );
                              //   },
                              //   likeCount:
                              //       _listPosts.result[widget.count].totalLike,
                              //   countBuilder:
                              //       (int count, bool isLiked, String text) {
                              //     var color =
                              //         isLiked ? Colors.red : Colors.black;
                              //     Widget result;
                              //     if (count == 0) {
                              //       result = Text(
                              //         "like",
                              //         style: TextStyle(color: color),
                              //       );
                              //     } else
                              //       result = Text(
                              //         text,
                              //         style: TextStyle(color: color),
                              //       );
                              //     return result;
                              //   },
                              // ),
                              IconButton(
                                icon: Icon(
                                  OMIcons.chatBubbleOutline,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CommentsScreen(
                                        index: widget.count,
                                        listPosts: _listPosts,
                                        uid: uid,
                                        post_id: _listPosts
                                            .result[widget.count].postId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          _isLoading == false
                              ? Padding(
                                  padding: EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    "${_listPosts.result[widget.count].totalLike} likes",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(left: 12.0),
                                  child: SpinKitThreeBounce(
                                    color: Color(0xFFFF8B66),
                                    size: 10,
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        width: 70,
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
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _listPosts.result[widget.count].title == ""
                            ? Container()
                            : Text(
                                _listPosts.result[widget.count].title,
                                style: GoogleFonts.poppins(),
                              ),
                        _listPosts.result[widget.count].description == ""
                            ? Container()
                            : Text(
                                _listPosts.result[widget.count].description,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                        FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommentsScreen(
                                  index: widget.count,
                                  listPosts: _listPosts,
                                  uid: uid,
                                  post_id:
                                      _listPosts.result[widget.count].postId,
                                ),
                              ),
                            );
                          },
                          child:
                              _listPosts.result[widget.count].comments.length >
                                      1
                                  ? Text(
                                      'View all ${_listPosts.result[widget.count].comments.length} comments',
                                      style: GoogleFonts.openSans(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                      ),
                                    )
                                  : _listPosts.result[widget.count].comments
                                              .length ==
                                          0
                                      ? Container()
                                      : Text(
                                          'View ${_listPosts.result[widget.count].comments.length} comment',
                                          style: GoogleFonts.openSans(
                                            fontSize: 13,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                        ),
                      ],
                    ),
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
