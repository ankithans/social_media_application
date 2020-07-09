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
    @required this.followers,
    @required this.following,
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
  final List<dynamic> posts;
  final int noOfPost;
  final int followers;
  final int following;

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
            : List<dynamic>.from(json["posts"].map((x) => x)),
        noOfPost: json["no_of_post"] == null ? null : json["no_of_post"],
        followers: json["followers"] == null ? null : json["followers"],
        following: json["following"] == null ? null : json["following"],
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
        "posts": posts == null ? null : List<dynamic>.from(posts.map((x) => x)),
        "no_of_post": noOfPost == null ? null : noOfPost,
        "followers": followers == null ? null : followers,
        "following": following == null ? null : following,
      };
}
