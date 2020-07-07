// To parse this JSON data, do
//
//     final default = defaultFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Default defaultFromJson(String str) => Default.fromJson(json.decode(str));

String defaultToJson(Default data) => json.encode(data.toJson());

class Default {
  Default({
    @required this.error,
    @required this.errorMsg,
    @required this.message,
  });

  final bool error;
  final String errorMsg;
  final String message;

  factory Default.fromJson(Map<String, dynamic> json) => Default(
        error: json["error"] == null ? null : json["error"],
        errorMsg: json["error_msg"] == null ? null : json["error_msg"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "error_msg": errorMsg == null ? null : errorMsg,
        "message": message == null ? null : message,
      };
}
