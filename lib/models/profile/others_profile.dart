// To parse this JSON data, do
//
//     final profileOthers = profileOthersFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProfileOthers profileOthersFromJson(String str) =>
    ProfileOthers.fromJson(json.decode(str));

String profileOthersToJson(ProfileOthers data) => json.encode(data.toJson());

class ProfileOthers {
  ProfileOthers({
    @required this.error,
    @required this.errorMsg,
    @required this.result,
  });

  final bool error;
  final String errorMsg;
  final Result result;

  factory ProfileOthers.fromJson(Map<String, dynamic> json) => ProfileOthers(
        error: json["error"] == null ? null : json["error"],
        errorMsg: json["error_msg"] == null ? null : json["error_msg"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "error_msg": errorMsg == null ? null : errorMsg,
        "result": result == null ? null : result.toJson(),
      };
}

class Result {
  Result({
    @required this.userId,
    @required this.name,
    @required this.email,
    @required this.pic,
    @required this.bio,
    @required this.follow,
  });

  final int userId;
  final String name;
  final String email;
  final String pic;
  final String bio;
  final int follow;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        userId: json["user_id"] == null ? null : json["user_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        pic: json["pic"] == null ? null : json["pic"],
        bio: json["bio"] == null ? null : json["bio"],
        follow: json["follow"] == null ? null : json["follow"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "pic": pic == null ? null : pic,
        "bio": bio == null ? null : bio,
        "follow": follow == null ? null : follow,
      };
}
