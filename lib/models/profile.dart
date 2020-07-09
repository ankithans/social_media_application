// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    @required this.error,
    @required this.errorMsg,
    @required this.pic,
    @required this.name,
    @required this.bio,
  });

  final bool error;
  final String errorMsg;
  final String pic;
  final String name;
  final String bio;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        error: json["error"] == null ? null : json["error"],
        errorMsg: json["error_msg"] == null ? null : json["error_msg"],
        pic: json["pic"] == null ? null : json["pic"],
        name: json["name"] == null ? null : json["name"],
        bio: json["bio"] == null ? null : json["bio"],
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "error_msg": errorMsg == null ? null : errorMsg,
        "pic": pic == null ? null : pic,
        "name": name == null ? null : name,
        "bio": bio == null ? null : bio,
      };
}
