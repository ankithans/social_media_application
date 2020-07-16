// To parse this JSON data, do
//
//     final listComments = listCommentsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ListComments listCommentsFromJson(String str) =>
    ListComments.fromJson(json.decode(str));

String listCommentsToJson(ListComments data) => json.encode(data.toJson());

class ListComments {
  ListComments({
    @required this.error,
    @required this.errorMsg,
    @required this.result,
  });

  final bool error;
  final String errorMsg;
  final List<Result> result;

  factory ListComments.fromJson(Map<String, dynamic> json) => ListComments(
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
    @required this.commentId,
    @required this.userId,
    @required this.comment,
    @required this.commentBy,
    @required this.createdAt,
    @required this.updatedAt,
  });

  final int commentId;
  final int userId;
  final String comment;
  final List<String> commentBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        commentId: json["comment_id"] == null ? null : json["comment_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        comment: json["comment"] == null ? null : json["comment"],
        commentBy: json["comment_by"] == null
            ? null
            : List<String>.from(json["comment_by"].map((x) => x)),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId == null ? null : commentId,
        "user_id": userId == null ? null : userId,
        "comment": comment == null ? null : comment,
        "comment_by": commentBy == null
            ? null
            : List<dynamic>.from(commentBy.map((x) => x)),
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
