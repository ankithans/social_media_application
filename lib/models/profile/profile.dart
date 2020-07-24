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
    @required this.result,
  });

  final bool error;
  final String errorMsg;
  final Result result;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
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
    @required this.mobile,
    @required this.uniqueKey,
    @required this.email,
    @required this.otherMobile,
    @required this.pic,
    @required this.state,
    @required this.city,
    @required this.address,
    @required this.pincode,
    @required this.accessType,
    @required this.bio,
    @required this.posts,
    @required this.noOfPost,
    @required this.following,
    @required this.followers,
  });

  final int userId;
  final String name;
  final String mobile;
  final String uniqueKey;
  final String email;
  final String otherMobile;
  final String pic;
  final String state;
  final String city;
  final String address;
  final String pincode;
  final int accessType;
  final String bio;
  final List<Post> posts;
  final int noOfPost;
  final int following;
  final int followers;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        userId: json["user_id"] == null ? null : json["user_id"],
        name: json["name"] == null ? null : json["name"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        uniqueKey: json["unique_key"] == null ? null : json["unique_key"],
        email: json["email"] == null ? null : json["email"],
        otherMobile: json["other_mobile"] == null ? null : json["other_mobile"],
        pic: json["pic"] == null ? null : json["pic"],
        state: json["state"] == null ? null : json["state"],
        city: json["city"] == null ? null : json["city"],
        address: json["address"] == null ? null : json["address"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        accessType: json["access_type"] == null ? null : json["access_type"],
        bio: json["bio"] == null ? null : json["bio"],
        posts: json["posts"] == null
            ? null
            : List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
        noOfPost: json["no_of_post"] == null ? null : json["no_of_post"],
        following: json["following"] == null ? null : json["following"],
        followers: json["followers"] == null ? null : json["followers"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "name": name == null ? null : name,
        "mobile": mobile == null ? null : mobile,
        "unique_key": uniqueKey == null ? null : uniqueKey,
        "email": email == null ? null : email,
        "other_mobile": otherMobile == null ? null : otherMobile,
        "pic": pic == null ? null : pic,
        "state": state == null ? null : state,
        "city": city == null ? null : city,
        "address": address == null ? null : address,
        "pincode": pincode == null ? null : pincode,
        "access_type": accessType == null ? null : accessType,
        "bio": bio == null ? null : bio,
        "posts": posts == null
            ? null
            : List<dynamic>.from(posts.map((x) => x.toJson())),
        "no_of_post": noOfPost == null ? null : noOfPost,
        "following": following == null ? null : following,
        "followers": followers == null ? null : followers,
      };
}

class Post {
  Post({
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
    @required this.status,
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
  final List<Comment> comments;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
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
            : List<Comment>.from(
                json["comments"].map((x) => Comment.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
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
            : List<dynamic>.from(comments.map((x) => x.toJson())),
        "status": status == null ? null : status,
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
