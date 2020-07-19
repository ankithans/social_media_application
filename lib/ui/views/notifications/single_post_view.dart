// import 'package:flutter/material.dart';

// class SinglePostView extends StatefulWidget {
//   final int count;

//   const SinglePostView({Key key, this.count}) : super(key: key);
//   @override
//   _SinglePostViewState createState() => _SinglePostViewState();
// }

// class _SinglePostViewState extends State<SinglePostView> {
//   bool _isLoading = false;
//   bool _isLiked = false;

//   @override
//   void initState() {
//     super.initState();
//     listImages();
//   }

//   // Future<ListPosts> listPosts() async {
//   //   setState(() {
//   //     _isLoading = true;
//   //   });
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   uid = prefs.getInt('uid');
//   //   print(uid);
//   //   FormData formData = FormData.fromMap({
//   //     'user_id': uid,
//   //   });
//   //   const url = 'https://www.mustdiscovertech.co.in/social/v1/';
//   //   Dio dio = new Dio();
//   //   try {
//   //     Response response = await dio.post('${url}post/listing', data: formData);
//   //     print(response);

//   //     _listPosts = ListPosts.fromJson(response.data);
//   //     listLikes();

//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //     return ListPosts.fromJson(response.data);
//   //   } on DioError catch (e) {
//   //     print(e.error);
//   //     throw (e.error);
//   //   }
//   // }

//   ListLikes _listLikes;

//   void listLikes() async {
//     setState(() {
//       _isLoading = true;
//     });
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     uid = prefs.getInt('uid');
//     print(uid);
//     FormData formData = FormData.fromMap({
//       'user_id': uid,
//       'post_id': _listPosts.result[widget.count].postId,
//     });
//     const url = 'https://www.mustdiscovertech.co.in/social/v1/';
//     Dio dio = new Dio();
//     try {
//       Response response =
//           await dio.post('${url}post/like/listing', data: formData);
//       print(response);
//       setState(() {
//         _listLikes = ListLikes.fromJson(response.data);
//       });
//       setState(() {
//         _isLoading = false;
//       });
//     } on DioError catch (e) {
//       print(e.error);
//       throw (e.error);
//     }
//   }

//   // void _onDoubleTapLikePhoto() {
//   //   setState(() => widget.post.addLikeIfUnlikedFor(currentUser));
//   //   _doubleTapImageEvents.sink.add(null);
//   // }

//   List<Widget> images = new List();
//   List<String> img = new List();
//   void listImages() async {
//     for (var i = 0; i < _listPosts.result[widget.count].images.length; i++) {
//       img.add(_listPosts.result[widget.count].images[i].original);
//       images.add(
//         ZoomOverlay(
//           twoTouchOnly: true,
//           child: AspectRatio(
//             aspectRatio: 16 / 9,
//             child: CachedNetworkImage(
//               fit: BoxFit.fitWidth,
//               imageUrl: _listPosts.result[widget.count].images[i].original,
//               progressIndicatorBuilder: (context, url, downloadProgress) =>
//                   Center(
//                 child: CircularProgressIndicator(
//                   value: downloadProgress.progress,
//                 ),
//               ),
//               errorWidget: (context, url, error) => Icon(Icons.error),
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   CarouselController buttonCarouselController = CarouselController();
//   int _currentIndex = 0;
//   List<T> map<T>(List list, Function handler) {
//     List<T> result = [];
//     for (var i = 0; i < list.length; i++) {
//       result.add(handler(i, list[i]));
//     }
//     return result;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Container(
//             color: Colors.grey[100],
//             child: Padding(
//               padding: const EdgeInsets.all(0.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   FlatButton(
//                     onPressed: () {
//                       _listPosts.result[widget.count].userId == uid
//                           ? Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ProfilePage(),
//                               ),
//                             )
//                           : Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => OthersProfile(
//                                   userId:
//                                       _listPosts.result[widget.count].userId,
//                                 ),
//                               ),
//                             );
//                     },
//                     padding: EdgeInsets.all(0),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Row(
//                         children: <Widget>[
//                           CircleAvatar(
//                             backgroundImage: NetworkImage(
//                                 _listPosts.result[widget.count].author[1]),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Text(
//                             _listPosts.result[widget.count].author[0],
//                             style: GoogleFonts.poppins(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   // GestureDetector(
//                   //   child: Stack(
//                   //     alignment: Alignment.center,
//                   //     children: <Widget>[
//                   //       SizedBox(
//                   //         height: 220.0,
//                   //         child: Carousel(
//                   //           images: images,
//                   //           dotSize: 4.0,
//                   //           dotSpacing: 15.0,
//                   //           dotColor: Colors.lightGreenAccent,
//                   //           indicatorBgPadding: 5.0,
//                   //           borderRadius: true,
//                   //           autoplay: false,
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   //   onDoubleTap: () {},
//                   // ),
//                   // CarouselSlider(
//                   //   items: images,
//                   //   carouselController: buttonCarouselController,
//                   //   options: CarouselOptions(
//                   //     height: 250,
//                   //     autoPlay: false,
//                   //     enlargeCenterPage: true,
//                   //     viewportFraction: 1,
//                   //     aspectRatio: 2.0,
//                   //     initialPage: 1,

//                   //     pauseAutoPlayInFiniteScroll: false,
//                   //     enableInfiniteScroll: false,
//                   //     onPageChanged: (index, reason) {
//                   //       setState(() {
//                   //         _currentIndex = index;
//                   //       });
//                   //     },
//                   //   ),
//                   // ),

//                   GFCarousel(
//                     items: images,
//                     activeIndicator: Colors.black,
//                     passiveIndicator: Colors.grey,
//                     enableInfiniteScroll: false,
//                     enlargeMainPage: true,
//                     viewportFraction: 1.0,
//                     height: 300,
//                     scrollPhysics: ScrollPhysics(),
//                     onPageChanged: (index) {
//                       setState(() {
//                         _currentIndex = index;
//                       });
//                     },
//                   ),

//                   Row(
//                     children: <Widget>[
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Row(
//                             children: <Widget>[
//                               // IconButton(
//                               //   icon:
//                               //       _listPosts.result[widget.count].userLike ==
//                               //                   1 ||
//                               //               _isLiked
//                               //           ? Icon(
//                               //               OMIcons.favorite,
//                               //               color: Colors.red,
//                               //               size: 28,
//                               //             )
//                               //           : Icon(
//                               //               OMIcons.favoriteBorder,
//                               //               color: Colors.black,
//                               //               size: 28,
//                               //             ),
//                               //   onPressed: () async {
//                               //     setState(() {
//                               //       _isLiked = !_isLiked;
//                               //       // if (backendLike == 1) {
//                               //       //   backendLike = 0;
//                               //       // } else {
//                               //       //   backendLike = 1;
//                               //       // }
//                               //     });
//                               //     FormData formData = FormData.fromMap({
//                               //       'user_id': uid,
//                               //       'post_id':
//                               //           _listPosts.result[widget.count].postId,
//                               //     });
//                               //     const url =
//                               //         'https://www.mustdiscovertech.co.in/social/v1/';
//                               //     Dio dio = new Dio();
//                               //     try {
//                               //       Response response = await dio.post(
//                               //           '${url}post/like',
//                               //           data: formData);
//                               //       print(response);
//                               //       setState(() {
//                               //         listPosts();
//                               //       });
//                               //       LikePosts likePosts =
//                               //           LikePosts.fromJson(response.data);
//                               //       listLikes();
//                               //     } on DioError catch (e) {
//                               //       print(e.error);
//                               //       throw (e.error);
//                               //     }
//                               //   },
//                               // ),

//                               LikeButton(
//                                 onTap: (isLiked) async {
//                                   FormData formData = FormData.fromMap({
//                                     'user_id': uid,
//                                     'post_id':
//                                         _listPosts.result[widget.count].postId,
//                                   });
//                                   const url =
//                                       'https://www.mustdiscovertech.co.in/social/v1/';
//                                   Dio dio = new Dio();
//                                   try {
//                                     Response response = await dio.post(
//                                         '${url}post/like',
//                                         data: formData);
//                                     print(response);
//                                     setState(() {
//                                       listPosts();
//                                     });
//                                     LikePosts likePosts =
//                                         LikePosts.fromJson(response.data);
//                                     listLikes();
//                                   } on DioError catch (e) {
//                                     print(e.error);
//                                     throw (e.error);
//                                   }
//                                   return isLiked;
//                                 },
//                                 circleColor: CircleColor(
//                                     start: Colors.red, end: Colors.red),
//                                 bubblesColor: BubblesColor(
//                                   dotPrimaryColor: Colors.red,
//                                   dotSecondaryColor: Colors.red,
//                                 ),
//                                 likeBuilder: (bool isLiked) {
//                                   return Icon(
//                                     Icons.favorite,
//                                     color: isLiked ? Colors.red : Colors.black,
//                                   );
//                                 },
//                                 likeCount:
//                                     _listPosts.result[widget.count].totalLike,
//                                 countBuilder:
//                                     (int count, bool isLiked, String text) {
//                                   var color =
//                                       isLiked ? Colors.red : Colors.black;
//                                   Widget result;
//                                   if (count == 0) {
//                                     result = Text(
//                                       "like",
//                                       style: TextStyle(color: color),
//                                     );
//                                   } else
//                                     result = Text(
//                                       text,
//                                       style: TextStyle(color: color),
//                                     );
//                                   return result;
//                                 },
//                               ),
//                               IconButton(
//                                 icon: Icon(
//                                   OMIcons.chatBubbleOutline,
//                                 ),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CommentsScreen(
//                                         index: widget.count,
//                                         listPosts: _listPosts,
//                                         uid: uid,
//                                         post_id: _listPosts
//                                             .result[widget.count].postId,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                           _isLoading == false
//                               ? Padding(
//                                   padding: EdgeInsets.only(left: 12.0),
//                                   child: Text(
//                                     "${_listPosts.result[widget.count].totalLike} likes",
//                                     style: GoogleFonts.montserrat(
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 )
//                               : Padding(
//                                   padding: EdgeInsets.only(left: 12.0),
//                                   child: SpinKitThreeBounce(
//                                     color: Color(0xFFFF8B66),
//                                     size: 10,
//                                   ),
//                                 ),
//                         ],
//                       ),
//                       SizedBox(
//                         width: 70,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: map<Widget>(images, (index, url) {
//                           return Container(
//                             width: 10.0,
//                             height: 10.0,
//                             margin: EdgeInsets.symmetric(
//                                 vertical: 5.0, horizontal: 2.0),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: _currentIndex == index
//                                   ? Colors.blueAccent
//                                   : Colors.grey,
//                             ),
//                           );
//                         }),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           _listPosts.result[widget.count].title,
//                           style: GoogleFonts.poppins(),
//                         ),
//                         Text(
//                           _listPosts.result[widget.count].description,
//                           style: GoogleFonts.poppins(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                         FlatButton(
//                           padding: EdgeInsets.all(0),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => CommentsScreen(
//                                   index: widget.count,
//                                   listPosts: _listPosts,
//                                   uid: uid,
//                                   post_id:
//                                       _listPosts.result[widget.count].postId,
//                                 ),
//                               ),
//                             );
//                           },
//                           child:
//                               _listPosts.result[widget.count].comments.length >
//                                       1
//                                   ? Text(
//                                       'View all ${_listPosts.result[widget.count].comments.length} comments',
//                                       style: GoogleFonts.openSans(
//                                         fontSize: 13,
//                                         color: Colors.grey[500],
//                                       ),
//                                     )
//                                   : _listPosts.result[widget.count].comments
//                                               .length ==
//                                           0
//                                       ? Container()
//                                       : Text(
//                                           'View ${_listPosts.result[widget.count].comments.length} comment',
//                                           style: GoogleFonts.openSans(
//                                             fontSize: 13,
//                                             color: Colors.grey[500],
//                                           ),
//                                         ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
