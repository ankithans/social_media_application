import 'package:flutter/material.dart';
import 'package:social_media_application/utils/flutter_icons.dart';
import 'package:social_media_application/utils/ui_utils.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[50],
        title: Container(
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
      ),
    );
  }
}
