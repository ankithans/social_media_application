// To parse this JSON data, do
//
//     final likePosts = likePostsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LikePosts likePostsFromJson(String str) => LikePosts.fromJson(json.decode(str));

String likePostsToJson(LikePosts data) => json.encode(data.toJson());

class LikePosts {
  LikePosts({
    @required this.error,
    @required this.errorMsg,
    @required this.result,
  });

  final bool error;
  final String errorMsg;
  final int result;

  factory LikePosts.fromJson(Map<String, dynamic> json) => LikePosts(
        error: json["error"] == null ? null : json["error"],
        errorMsg: json["error_msg"] == null ? null : json["error_msg"],
        result: json["result"] == null ? null : json["result"],
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "error_msg": errorMsg == null ? null : errorMsg,
        "result": result == null ? null : result,
      };
}
