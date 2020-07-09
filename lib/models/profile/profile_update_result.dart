// To parse this JSON data, do
//
//     final profileUpdate = profileUpdateFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProfileUpdate profileUpdateFromJson(String str) =>
    ProfileUpdate.fromJson(json.decode(str));

String profileUpdateToJson(ProfileUpdate data) => json.encode(data.toJson());

class ProfileUpdate {
  ProfileUpdate({
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

  factory ProfileUpdate.fromJson(Map<String, dynamic> json) => ProfileUpdate(
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
