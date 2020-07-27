import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/chat/user_friends_list.dart';
import 'package:social_media_application/ui/views/chat/chat_search.dart';
import 'package:social_media_application/ui/views/chat/chat_with_user.dart';
import 'package:social_media_application/utils/flutter_icons.dart';
import 'package:social_media_application/utils/ui_utils.dart';

class ChatMembersList extends StatefulWidget {
  @override
  _ChatMembersListState createState() => _ChatMembersListState();
}

class _ChatMembersListState extends State<ChatMembersList> {
  UserFriendList userFriendList;
  bool _isLoading = false;

  void getUserFriendList() async {
    setState(() {
      _isLoading = true;
    });
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int uid = prefs.getInt('uid');
    FormData formData = FormData.fromMap({
      'user_id': uid,
    });

    try {
      Response response = await dio.post('${url}user/friends', data: formData);
      print(response);

      userFriendList = UserFriendList.fromJson(response.data);
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
    getUserFriendList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Messages',
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
      body: _isLoading == false
          ? Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 30,
                    ),
                    child: Container(
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
                                          delegate:
                                              ChatUsersSearch(userFriendList),
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
                  Text(
                    'Messages',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                  ),
                  // FlatButton(
                  //   padding: EdgeInsets.all(0),
                  //   onPressed: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => ChatWithUser(
                  //         userName: 'Group Chat',
                  //         uid: 1,
                  //         pic: '',
                  //       ),
                  //     ),
                  //   ),
                  //   child: GroupChat(),
                  // ),
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: userFriendList.result.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatWithUser(
                                  userName: userFriendList.result[index].name,
                                  user_id: userFriendList.result[index].userId,
                                  pic: userFriendList.result[index].pic,
                                ),
                              ),
                            );
                          },
                          child: ChatMemberItem(
                            userFriendList: userFriendList,
                            index: index,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: SpinKitThreeBounce(
                color: Color(0xFFFF8B66),
              ),
            ),
    );
  }
}

class ChatMemberItem extends StatefulWidget {
  final UserFriendList userFriendList;
  final index;

  const ChatMemberItem({Key key, this.userFriendList, this.index})
      : super(key: key);

  @override
  _ChatMemberItemState createState() => _ChatMemberItemState();
}

class _ChatMemberItemState extends State<ChatMemberItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                      widget.userFriendList.result[widget.index].pic),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.userFriendList.result[widget.index].name,
                      style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.userFriendList.result[widget.index].email,
                      style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
