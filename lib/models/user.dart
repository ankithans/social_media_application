// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    @required this.error,
    @required this.errorMsg,
    @required this.result,
  });

  final bool error;
  final String errorMsg;
  final Result result;

  factory User.fromJson(Map<String, dynamic> json) => User(
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
  });

  final int userId;
  final String name;
  var mobile;
  final String uniqueKey;
  final String email;
  final String otherMobile;
  final String pic;
  final String state;
  final String city;
  final String address;
  final String pincode;
  final int accessType;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        userId: json["user_id"] == null ? null : json["user_id"],
        name: json["name"] == null ? null : json["name"],
        mobile: json["mobile"],
        uniqueKey: json["unique_key"] == null ? null : json["unique_key"],
        email: json["email"] == null ? null : json["email"],
        otherMobile: json["other_mobile"] == null ? null : json["other_mobile"],
        pic: json["pic"] == null ? null : json["pic"],
        state: json["state"] == null ? null : json["state"],
        city: json["city"] == null ? null : json["city"],
        address: json["address"] == null ? null : json["address"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        accessType: json["access_type"] == null ? null : json["access_type"],
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
      };
}
