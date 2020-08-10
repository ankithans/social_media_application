import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/posts/listLikes.dart';
import 'package:social_media_application/models/posts/lists_posts.dart';
import 'package:social_media_application/models/profile/profile.dart';
import 'package:social_media_application/repositories/api_client.dart';
import 'package:social_media_application/repositories/api_repositories.dart';
import 'package:social_media_application/ui/views/posts/comments_screen.dart';
import 'package:social_media_application/ui/views/posts/update_post_photo.dart';
import 'package:social_media_application/ui/views/posts/update_post_video.dart';
import 'package:social_media_application/ui/views/posts/video_player.dart';
import 'package:social_media_application/ui/views/profile/others_profile.dart';
import 'package:social_media_application/ui/views/profile/profilePage.dart';
import 'package:social_media_application/ui/widgets/zoom_overlay.dart';

// ListPosts _listPosts;

class SinglePostView extends StatefulWidget {
  final int count;
  final Profile profile;
  final bool showEditDel;

  const SinglePostView({Key key, this.count, this.profile, this.showEditDel})
      : super(key: key);
  @override
  _SinglePostViewState createState() => _SinglePostViewState();
}

class _SinglePostViewState extends State<SinglePostView> {
  bool _isLoading = false;
  int uid;
  Profile profile;

  @override
  void initState() {
    super.initState();
    listImages();
    profile = widget.profile;
  }

  // Future<ListPosts> listPosts() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   uid = prefs.getInt('uid');
  //   print(uid);
  //   FormData formData = FormData.fromMap({
  //     'user_id': uid,
  //   });
  //   const url = 'https://www.mustdiscovertech.co.in/social/v1/';
  //   Dio dio = new Dio();
  //   try {
  //     Response response = await dio.post('${url}post/listing', data: formData);
  //     print(response);

  //     _listPosts = ListPosts.fromJson(response.data);
  //     listLikes();

  //     setState(() {
  //       _isLoading = false;
  //     });
  //     return ListPosts.fromJson(response.data);
  //   } on DioError catch (e) {
  //     print(e.error);
  //     throw (e.error);
  //   }
  // }

  ListLikes _listLikes;

  void getProfile() async {
    final ApiRepository apiRepository = ApiRepository(
      apiClient: ApiClient(),
    );
    Profile pfile =
        profile = await apiRepository.getProfile(widget.profile.result.userId);
    setState(() {
      profile = pfile;
    });
  }

  void listLikes() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getInt('uid');
    print(uid);
    FormData formData = FormData.fromMap({
      'user_id': uid,
      'post_id': profile.result.posts[widget.count].postId,
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
    for (var i = 0;
        i < widget.profile.result.posts[widget.count].images.length;
        i++) {
      img.add(widget.profile.result.posts[widget.count].images[i].original);
      images.add(
        ZoomOverlay(
          twoTouchOnly: true,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: PhotoView(
              imageProvider: NetworkImage(
                  widget.profile.result.posts[widget.count].images[i].original),
              loadingBuilder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        actions: <Widget>[
          widget.showEditDel == false
              ? Container()
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    profile.result.posts[widget.count].images.length == 0
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdatePost(
                                post_id:
                                    profile.result.posts[widget.count].postId,
                              ),
                            ),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdatePostPhoto(
                                post_id:
                                    profile.result.posts[widget.count].postId,
                              ),
                            ),
                          );
                  },
                ),
          widget.showEditDel == false
              ? Container()
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext acontext) {
                        return PlatformAlertDialog(
                          title: Text('Are you sure to delete this Post?'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('After Deleting the post '),
                                Text(
                                    'You will not able to retrieve the post again.'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            PlatformDialogAction(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            PlatformDialogAction(
                              child: Text('Delete'),
                              actionType: ActionType.Preferred,
                              onPressed: () async {
                                final ProgressDialog pr = ProgressDialog(
                                    context,
                                    isDismissible: false);

                                Navigator.pop(acontext);
                                pr.show();

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                uid = prefs.getInt('uid');
                                print(uid);
                                FormData formData = FormData.fromMap({
                                  'user_id': uid,
                                  'post_id':
                                      profile.result.posts[widget.count].postId,
                                });
                                const url =
                                    'https://www.mustdiscovertech.co.in/social/v1/';
                                Dio dio = new Dio();
                                try {
                                  Response response = await dio.post(
                                      '${url}post/pdelete',
                                      data: formData);
                                  print(response);

                                  pr.hide();
                                } on DioError catch (e) {
                                  FlutterToast.showToast(
                                      msg:
                                          'Not able delete this post at this moment. Please try again later');
                                  print(e.error);
                                  throw (e.error);
                                }
                                Navigator.pop(context, () {
                                  setState(() {});
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                          profile.result.posts[widget.count].userId == uid
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
                                      userId: profile
                                          .result.posts[widget.count].userId,
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
                                backgroundImage: NetworkImage(profile
                                    .result.posts[widget.count].author[1]),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    profile
                                        .result.posts[widget.count].author[0],
                                    style: GoogleFonts.poppins(),
                                  ),
                                  // Text(
                                  //   profile.result.posts[widget.count].location,
                                  //   style: GoogleFonts.poppins(
                                  //     color: Colors.grey[500],
                                  //     fontSize: 12,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
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

                      if (profile.result.posts[widget.count].images.length != 0)
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

                      if (profile.result.posts[widget.count].video != null &&
                          profile.result.posts[widget.count].images.length == 0)
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return VideoPlayer(
                                    video: profile
                                        .result.posts[widget.count].video,
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
                                        imageUrl: profile.result
                                            .posts[widget.count].videoThumb),
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
                                                video: profile.result
                                                    .posts[widget.count].video,
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
                                  IconButton(
                                    icon: profile.result.posts[widget.count]
                                                .userLike ==
                                            1
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
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      uid = prefs.getInt('uid');
                                      FormData formData = FormData.fromMap({
                                        'user_id': uid,
                                        'post_id': profile
                                            .result.posts[widget.count].postId,
                                      });
                                      const url =
                                          'https://www.mustdiscovertech.co.in/social/v1/';
                                      Dio dio = new Dio();
                                      try {
                                        Response response = await dio.post(
                                            '${url}post/like',
                                            data: formData);
                                        print(response);
                                        setState(() {
                                          getProfile();
                                        });
                                        // LikePosts likePosts =
                                        //     LikePosts.fromJson(response.data);
                                        listLikes();
                                      } on DioError catch (e) {
                                        print(e.error);
                                        throw (e.error);
                                      }
                                    },
                                  ),

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
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      uid = prefs.getInt('uid');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CommentsScreen(
                                            index: widget.count,
                                            uid: uid,
                                            post_id: profile.result
                                                .posts[widget.count].postId,
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
                                        "${profile.result.posts[widget.count].totalLike} likes",
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
                            profile.result.posts[widget.count].title == ""
                                ? Container()
                                : Text(
                                    profile.result.posts[widget.count].title,
                                    style: GoogleFonts.poppins(),
                                  ),
                            profile.result.posts[widget.count].description == ""
                                ? Container()
                                : Text(
                                    profile
                                        .result.posts[widget.count].description,
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                            FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                uid = prefs.getInt('uid');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentsScreen(
                                      index: widget.count,
                                      uid: uid,
                                      post_id: profile
                                          .result.posts[widget.count].postId,
                                    ),
                                  ),
                                );
                              },
                              child: profile.result.posts[widget.count].comments
                                          .length >
                                      1
                                  ? Text(
                                      'View all ${profile.result.posts[widget.count].comments.length} comments',
                                      style: GoogleFonts.openSans(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                      ),
                                    )
                                  : profile.result.posts[widget.count].comments
                                              .length ==
                                          0
                                      ? Container()
                                      : Text(
                                          'View ${profile.result.posts[widget.count].comments.length} comment',
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
        ),
      ),
    );
  }
}
