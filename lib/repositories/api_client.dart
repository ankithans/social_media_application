import 'dart:io';

import 'package:dio/dio.dart';
import 'package:social_media_application/models/default.dart';
import 'package:social_media_application/models/posts/post_default.dart';
import 'package:social_media_application/models/profile/profile_update_result.dart';
import 'package:social_media_application/models/user.dart';
import 'package:social_media_application/models/profile/profile.dart';

class ApiClient {
  static const url = 'https://www.mustdiscovertech.co.in/social/v1/';
  Dio dio = new Dio();
  ApiClient() {
    BaseOptions options = BaseOptions(
        receiveTimeout: 100000, connectTimeout: 100000, baseUrl: url);
    dio = Dio(options);
  }

  void showProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future<Default> signInWithMobile(
      String name, String mobile, String registrationToken) async {
    FormData formData = FormData.fromMap({
      'name': name,
      'mobile': mobile,
      'registration_token': registrationToken,
    });

    try {
      Response response = await dio.post('${url}user/login', data: formData);
      print(response);
      return Default.fromJson(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw e.error;
    }
  }

  Future<User> verifyOtp(String mobile, String otp) async {
    FormData formData = FormData.fromMap({
      'mobile': mobile,
      'otp': otp,
    });

    try {
      Response response =
          await dio.post('${url}user/otpverify', data: formData);
      print(response);
      return User.fromJson(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw e.error;
    }
  }

  Future<Default> resendOtp(String mobile) async {
    FormData formData = FormData.fromMap({
      'mobile': mobile,
    });

    try {
      Response response =
          await dio.post('${url}user/resendotp', data: formData);
      print(response);
      return Default.fromJson(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw e.error;
    }
  }

  Future<User> socialSignIn(String email, String registration_token,
      String name, String mobile, String profile_pic) async {
    FormData formData = FormData.fromMap({
      'email': email,
      'registration_token': registration_token,
      'name': name,
      'mobile': mobile,
      'profile_pic': profile_pic,
    });

    try {
      Response response =
          await dio.post('${url}user/sociallogin', data: formData);

      return User.fromJson(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw e.error;
    }
  }

  Future<ProfileUpdate> UpdateProfile(
      int user_id, File file, String name, String bio) async {
    FormData formData = FormData.fromMap({
      'user_id': user_id,
      'photo': await MultipartFile.fromFile(file.path, filename: 'pic'),
      'name': name,
      'bio': bio,
    });

    try {
      Response response = await dio.post('${url}user/update', data: formData);
      print(response);
      return ProfileUpdate.fromJson(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

  Future<ProfileUpdate> UpdateProfileWithoutPic(
      int user_id, String name, String bio) async {
    FormData formData = FormData.fromMap({
      'user_id': user_id,
      'name': name,
      'bio': bio,
    });

    try {
      Response response = await dio.post('${url}user/update', data: formData);
      print(response);
      return ProfileUpdate.fromJson(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

  Future<Profile> getProfile(int user_id) async {
    FormData formData = FormData.fromMap({
      'user_id': user_id,
    });

    try {
      Response response = await dio.post('${url}user/profile', data: formData);
      print(response);
      return Profile.fromJson(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }

  Future<PostDefault> postUpload(int user_id, String title,
      List<MultipartFile> photo, String description) async {
    FormData formData = FormData.fromMap({
      'user_id': user_id,
      'title': title,
      'photo[]': photo,
      'description': description,
    });

    try {
      Response response = await dio.post('${url}post/upload', data: formData);
      print(response);
      return PostDefault.fromJson(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw (e.error);
    }
  }
}
