// To parse this JSON data, do
//
//     final listPosts = listPostsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ListPosts listPostsFromJson(String str) => ListPosts.fromJson(json.decode(str));

String listPostsToJson(ListPosts data) => json.encode(data.toJson());

class ListPosts {
  ListPosts({
    @required this.error,
    @required this.errorMsg,
    @required this.result,
  });

  final bool error;
  final String errorMsg;
  final List<Result> result;

  factory ListPosts.fromJson(Map<String, dynamic> json) => ListPosts(
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
    @required this.postId,
    @required this.userId,
    @required this.title,
    @required this.images,
    @required this.video,
    @required this.description,
    @required this.author,
    @required this.totalLike,
    @required this.userLike,
    @required this.comments,
    @required this.createdAt,
    @required this.updatedAt,
  });

  final int postId;
  final int userId;
  final String title;
  final List<Images> images;
  final String video;
  final String description;
  final List<String> author;
  final int totalLike;
  final int userLike;
  final List<Comment> comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        postId: json["post_id"] == null ? null : json["post_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        title: json["title"] == null ? null : json["title"],
        images: json["images"] == null
            ? null
            : List<Images>.from(json["images"].map((x) => Images.fromJson(x))),
        video: json["video"] == null ? null : json["video"],
        description: json["description"] == null ? null : json["description"],
        author: json["author"] == null
            ? null
            : List<String>.from(json["author"].map((x) => x)),
        totalLike: json["total_like"] == null ? null : json["total_like"],
        userLike: json["user_like"] == null ? null : json["user_like"],
        comments: json["comments"] == null
            ? null
            : List<Comment>.from(
                json["comments"].map((x) => Comment.fromJson(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId == null ? null : postId,
        "user_id": userId == null ? null : userId,
        "title": title == null ? null : title,
        "images": images == null
            ? null
            : List<dynamic>.from(images.map((x) => x.toJson())),
        "video": video == null ? null : video,
        "description": description == null ? null : description,
        "author":
            author == null ? null : List<dynamic>.from(author.map((x) => x)),
        "total_like": totalLike == null ? null : totalLike,
        "user_like": userLike == null ? null : userLike,
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments.map((x) => x.toJson())),
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class Comment {
  Comment({
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

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
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

class Images {
  Images({
    @required this.original,
    @required this.thumbnail,
  });

  final String original;
  final String thumbnail;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        original: json["original"] == null ? null : json["original"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "original": original == null ? null : original,
        "thumbnail": thumbnail == null ? null : thumbnail,
      };
}
