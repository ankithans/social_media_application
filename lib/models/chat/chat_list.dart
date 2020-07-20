// To parse this JSON data, do
//
//     final chatListing = chatListingFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ChatListing chatListingFromJson(String str) =>
    ChatListing.fromJson(json.decode(str));

String chatListingToJson(ChatListing data) => json.encode(data.toJson());

class ChatListing {
  ChatListing({
    @required this.error,
    @required this.errorMsg,
    @required this.result,
  });

  final bool error;
  final String errorMsg;
  final List<Result> result;

  factory ChatListing.fromJson(Map<String, dynamic> json) => ChatListing(
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
    @required this.email,
    @required this.pic,
    @required this.bio,
    @required this.chat,
    @required this.createdAt,
  });

  final int userId;
  final String name;
  final String email;
  final String pic;
  final String bio;
  final String chat;
  final DateTime createdAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        userId: json["user_id"] == null ? null : json["user_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        pic: json["pic"] == null ? null : json["pic"],
        bio: json["bio"] == null ? null : json["bio"],
        chat: json["chat"] == null ? null : json["chat"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "pic": pic == null ? null : pic,
        "bio": bio == null ? null : bio,
        "chat": chat == null ? null : chat,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
      };
}
