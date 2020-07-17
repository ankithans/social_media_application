// To parse this JSON data, do
//
//     final searchUsers = searchUsersFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SearchUsers searchUsersFromJson(String str) =>
    SearchUsers.fromJson(json.decode(str));

String searchUsersToJson(SearchUsers data) => json.encode(data.toJson());

class SearchUsers {
  SearchUsers({
    @required this.error,
    @required this.errorMsg,
    @required this.result,
  });

  final bool error;
  final String errorMsg;
  final List<Result> result;

  factory SearchUsers.fromJson(Map<String, dynamic> json) => SearchUsers(
        error: json["error"] == null ? null : json["error"],
        errorMsg: json["error_msg"] == null ? null : json["error_msg"],
        result: json["result"] == null
            ? null
            : List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "error_msg": errorMsg == null ? null : errorMsg,
        "result": result == null
            ? null
            : List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    @required this.userId,
    @required this.name,
    @required this.mobile,
    @required this.email,
    @required this.pic,
    @required this.bio,
  });

  final int userId;
  final String name;
  final dynamic mobile;
  final String email;
  final String pic;
  final String bio;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        userId: json["user_id"] == null ? null : json["user_id"],
        name: json["name"] == null ? null : json["name"],
        mobile: json["mobile"],
        email: json["email"] == null ? null : json["email"],
        pic: json["pic"] == null ? null : json["pic"],
        bio: json["bio"] == null ? null : json["bio"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "name": name == null ? null : name,
        "mobile": mobile,
        "email": email == null ? null : email,
        "pic": pic == null ? null : pic,
        "bio": bio == null ? null : bio,
      };
}
