// To parse this JSON data, do
//
//     final hashTagPost = hashTagPostFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

HashTagPost hashTagPostFromJson(String str) =>
    HashTagPost.fromJson(json.decode(str));

String hashTagPostToJson(HashTagPost data) => json.encode(data.toJson());

class HashTagPost {
  HashTagPost({
    @required this.error,
    @required this.errorMsg,
    @required this.result,
  });

  final bool error;
  final String errorMsg;
  final List<Result> result;

  factory HashTagPost.fromJson(Map<String, dynamic> json) => HashTagPost(
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
    @required this.videoThumb,
    @required this.description,
    @required this.author,
    @required this.totalLike,
    @required this.userLike,
    @required this.comments,
    @required this.location,
    @required this.hashtag,
    @required this.createdAt,
    @required this.updatedAt,
  });

  final int postId;
  final int userId;
  final String title;
  final List<Image> images;
  final String video;
  final String videoThumb;
  final String description;
  final List<String> author;
  final int totalLike;
  final int userLike;
  final List<dynamic> comments;
  final String location;
  final List<String> hashtag;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        postId: json["post_id"] == null ? null : json["post_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        title: json["title"] == null ? null : json["title"],
        images: json["images"] == null
            ? null
            : List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        video: json["video"] == null ? null : json["video"],
        videoThumb: json["video_thumb"] == null ? null : json["video_thumb"],
        description: json["description"] == null ? null : json["description"],
        author: json["author"] == null
            ? null
            : List<String>.from(json["author"].map((x) => x)),
        totalLike: json["total_like"] == null ? null : json["total_like"],
        userLike: json["user_like"] == null ? null : json["user_like"],
        comments: json["comments"] == null
            ? null
            : List<dynamic>.from(json["comments"].map((x) => x)),
        location: json["location"] == null ? null : json["location"],
        hashtag: json["hashtag"] == null
            ? null
            : List<String>.from(json["hashtag"].map((x) => x)),
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
        "video_thumb": videoThumb == null ? null : videoThumb,
        "description": description == null ? null : description,
        "author":
            author == null ? null : List<dynamic>.from(author.map((x) => x)),
        "total_like": totalLike == null ? null : totalLike,
        "user_like": userLike == null ? null : userLike,
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments.map((x) => x)),
        "location": location == null ? null : location,
        "hashtag":
            hashtag == null ? null : List<dynamic>.from(hashtag.map((x) => x)),
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class Image {
  Image({
    @required this.original,
    @required this.thumbnail,
  });

  final String original;
  final String thumbnail;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        original: json["original"] == null ? null : json["original"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "original": original == null ? null : original,
        "thumbnail": thumbnail == null ? null : thumbnail,
      };
}
