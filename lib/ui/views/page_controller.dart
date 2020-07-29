import 'package:flutter/material.dart';
import 'package:social_media_application/ui/views/chat/chat_list.dart';
import 'package:social_media_application/ui/views/home_page.dart';
import 'package:social_media_application/ui/views/settings.dart';

class PageControl extends StatefulWidget {
  @override
  _PageControlState createState() => _PageControlState();
}

class _PageControlState extends State<PageControl> {
  PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: ScrollPhysics(),
        controller: controller,
        children: <Widget>[
          HomePage(),
          ChatMembersList(),
        ],
      ),
    );
  }
}
