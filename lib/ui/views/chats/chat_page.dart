import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_application/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:social_media_application/ui/views/chats/chat_item_page.dart';
import 'package:social_media_application/utils/flutter_icons.dart';

import 'package:social_media_application/utils/ui_utils.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatModel> list = ChatModel.list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.mainColor,
        title: Text(
          "Chat",
          style: GoogleFonts.nunito(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FlutterIcons.filter,
              color: AppColors.blueColor,
            ),
            onPressed: null,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: AppColors.darkColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
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
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatItemPage(),
                      ),
                    );
                  },
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage("assets/images/default.jpg"),
                      ),
                    ),
                  ),
                  title: Text(
                    list[index].contact.name,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  subtitle: list[index].isTyping
                      ? Row(
                          children: <Widget>[
                            SpinKitThreeBounce(
                              color: AppColors.blueColor,
                              size: 20.0,
                            ),
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Text(
                              list[index].lastMessage,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 25),
                            Text(
                              list[index].lastMessageTime + " days ago",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
        backgroundColor: AppColors.blueColor,
      ),
    );
  }
}
