import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/profile/following.dart';

class FollowingCard extends StatefulWidget {
  final GetFollowing getfollowing;
  final int index;

  const FollowingCard({Key key, this.getfollowing, this.index})
      : super(key: key);

  @override
  _FollowingCardState createState() => _FollowingCardState();
}

class _FollowingCardState extends State<FollowingCard> {
  @override
  Widget build(BuildContext context) {}
}
