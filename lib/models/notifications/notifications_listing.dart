// To parse this JSON data, do
//
//     final notificationListing = notificationListingFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

NotificationListing notificationListingFromJson(String str) =>
    NotificationListing.fromJson(json.decode(str));

String notificationListingToJson(NotificationListing data) =>
    json.encode(data.toJson());

class NotificationListing {
  NotificationListing({
    @required this.error,
    @required this.errorMsg,
    @required this.result,
  });

  final bool error;
  final String errorMsg;
  final List<Result> result;

  factory NotificationListing.fromJson(Map<String, dynamic> json) =>
      NotificationListing(
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
    @required this.notifyId,
    @required this.notifyType,
    @required this.typeId,
    @required this.title,
    @required this.description,
    @required this.image,
    @required this.status,
    @required this.postedAt,
  });

  final int notifyId;
  final String notifyType;
  final int typeId;
  final String title;
  final String description;
  final String image;
  final int status;
  final String postedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        notifyId: json["notify_id"] == null ? null : json["notify_id"],
        notifyType: json["notify_type"] == null ? null : json["notify_type"],
        typeId: json["type_id"] == null ? null : json["type_id"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        image: json["image"] == null ? null : json["image"],
        status: json["status"] == null ? null : json["status"],
        postedAt: json["posted_at"] == null ? null : json["posted_at"],
      );

  Map<String, dynamic> toJson() => {
        "notify_id": notifyId == null ? null : notifyId,
        "notify_type": notifyType == null ? null : notifyType,
        "type_id": typeId == null ? null : typeId,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "image": image == null ? null : image,
        "status": status == null ? null : status,
        "posted_at": postedAt == null ? null : postedAt,
      };
}
