import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/posts/HashTagPost.dart';
import 'package:social_media_application/ui/views/posts/comments_screen.dart';
import 'package:social_media_application/ui/views/posts/video_player.dart';
import 'package:social_media_application/ui/views/profile/others_profile.dart';
import 'package:social_media_application/ui/views/profile/profilePage.dart';
import 'example_data.dart' as Example;

class HashTagSearch extends StatefulWidget {
  final HashTagPost hashTagPost;
  final int index;

  const HashTagSearch({Key key, this.hashTagPost, this.index})
      : super(key: key);

  @override
  _HashTagSearchState createState() => _HashTagSearchState();
}

class _HashTagSearchState extends State<HashTagSearch> {
  int _currentIndex = 0;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Reaction reaction;

  List<Widget> images = new List();
  List<String> img = new List();
  void listImages() async {
    for (var i = 0; i < widget.hashTagPost.result[i].images.length; i++) {
      img.add(widget.hashTagPost.result[i].images[i].original);
      images.add(
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PhotoView(
            imageProvider:
                NetworkImage(widget.hashTagPost.result[i].images[i].original),
            loadingBuilder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: widget.hashTagPost.result.length,
          itemBuilder: (context, index) {
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
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              int uid = prefs.getInt('uid');
                              widget.hashTagPost.result[index].userId == uid
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
                                          userId: widget
                                              .hashTagPost.result[index].userId,
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
                                    backgroundImage: NetworkImage(widget
                                        .hashTagPost.result[index].author[1]),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.hashTagPost.result[index]
                                            .author[0],
                                        style: GoogleFonts.poppins(),
                                      ),
                                      Text(
                                        widget
                                            .hashTagPost.result[index].location,
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
                          widget.hashTagPost.result[index].hashtag != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SelectableAutoLinkText(
                                    widget.hashTagPost.result[index].hashtag
                                        .toString()
                                        .replaceAll('[', '')
                                        .replaceAll(']', ''),
                                    style:
                                        const TextStyle(color: Colors.black87),
                                    linkStyle:
                                        const TextStyle(color: Colors.blue),
                                    highlightedLinkStyle: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      backgroundColor: Colors.deepOrangeAccent
                                          .withAlpha(0x33),
                                    ),
                                    onTap: (link) {
                                      print(link);
                                    },
                                    linkRegExpPattern:
                                        '(@[\\w]+|#[\\w]+|${AutoLinkUtils.urlRegExpPattern})',
                                    onTransformDisplayLink:
                                        AutoLinkUtils.shrinkUrl,
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

                          if (widget.hashTagPost.result[index].images.length !=
                              0)
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

                          if (widget.hashTagPost.result[index].video != null &&
                              widget.hashTagPost.result[index].images.length ==
                                  0)
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return VideoPlayer(
                                        video: widget
                                            .hashTagPost.result[index].video,
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
                                            imageUrl: widget.hashTagPost
                                                .result[index].videoThumb),
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
                                                    video: widget.hashTagPost
                                                        .result[index].video,
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
                                          boxColor:
                                              Colors.black.withOpacity(0.5),
                                          boxRadius: 10,
                                          boxDuration:
                                              Duration(milliseconds: 500),
                                        ),
                                      ),
                                      // IconButton(
                                      //   icon:
                                      //       widget.hashTagPost.result[index].userLike ==
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
                                      //           widget.hashTagPost.result[index].postId,
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
                                      //           widget.hashTagPost.result[index].postId,
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
                                      //       widget.hashTagPost.result[index].totalLike,
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
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         CommentsScreen(
                                          //       index: widget.count,
                                          //       // listPosts: widget.hashTagPost,
                                          //       uid: uid,
                                          //       post_id: _listPosts
                                          //           .result[widget.count].postId,
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                      ),
                                    ],
                                  ),
                                  _isLoading == false
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 12.0),
                                          child: Text(
                                            "${widget.hashTagPost.result[index].totalLike} likes",
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
                                widget.hashTagPost.result[index].title == ""
                                    ? Container()
                                    : Text(
                                        widget.hashTagPost.result[index].title,
                                        style: GoogleFonts.poppins(),
                                      ),
                                widget.hashTagPost.result[index].description ==
                                        ""
                                    ? Container()
                                    : Text(
                                        widget.hashTagPost.result[index]
                                            .description,
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => CommentsScreen(
                                    //       index: widget.count,
                                    //       listPosts: _listPosts,
                                    //       uid: uid,
                                    //       post_id: _listPosts
                                    //           .result[widget.count].postId,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: widget.hashTagPost.result[index]
                                              .comments.length >
                                          1
                                      ? Text(
                                          'View all ${widget.hashTagPost.result[index].comments.length} comments',
                                          style: GoogleFonts.openSans(
                                            fontSize: 13,
                                            color: Colors.grey[500],
                                          ),
                                        )
                                      : widget.hashTagPost.result[index]
                                                  .comments.length ==
                                              0
                                          ? Container()
                                          : Text(
                                              'View ${widget.hashTagPost.result[index].comments.length} comment',
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
          }),
    );
  }
}
