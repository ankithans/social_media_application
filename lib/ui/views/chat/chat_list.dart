import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_application/ui/views/chat/chat_with_user.dart';
import 'package:social_media_application/utils/flutter_icons.dart';
import 'package:social_media_application/utils/ui_utils.dart';

class ChatMembersList extends StatefulWidget {
  @override
  _ChatMembersListState createState() => _ChatMembersListState();
}

class _ChatMembersListState extends State<ChatMembersList> {
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
      body: Padding(
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
                      Radius.circular(20),
                    )),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      FlutterIcons.search,
                      color: Colors.black,
                    ),
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Messages',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 15,
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatWithUser(
                            userName: 'Ankit',
                            uid: 5,
                          ),
                        ),
                      );
                    },
                    child: ChatMemberItem(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMemberItem extends StatefulWidget {
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
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Ankit Hans',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'This is last message',
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
