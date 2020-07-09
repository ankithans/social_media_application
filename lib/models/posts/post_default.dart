// To parse this JSON data, do
//
//     final postDefault = postDefaultFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PostDefault postDefaultFromJson(String str) =>
    PostDefault.fromJson(json.decode(str));

String postDefaultToJson(PostDefault data) => json.encode(data.toJson());

class PostDefault {
  PostDefault({
    @required this.error,
    @required this.errorMsg,
  });

  final bool error;
  final String errorMsg;

  factory PostDefault.fromJson(Map<String, dynamic> json) => PostDefault(
        error: json["error"] == null ? null : json["error"],
        errorMsg: json["error_msg"] == null ? null : json["error_msg"],
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "error_msg": errorMsg == null ? null : errorMsg,
      };
}
