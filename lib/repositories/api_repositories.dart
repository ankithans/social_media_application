import 'dart:io';

import 'package:social_media_application/models/default.dart';
import 'package:social_media_application/models/profile/profile.dart';
import 'package:social_media_application/models/user.dart';
import 'package:social_media_application/repositories/api_client.dart';
import 'package:social_media_application/models/profile/profile_update_result.dart';

class ApiRepository {
  final ApiClient apiClient;

  ApiRepository({
    this.apiClient,
  }) : assert(apiClient != null);

  Future<Default> signInWithMobile(
      String name, String mobile, String registrationToken) async {
    return apiClient.signInWithMobile(name, mobile, registrationToken);
  }

  Future<User> verifyOtp(String mobile, String otp) async {
    return apiClient.verifyOtp(mobile, otp);
  }

  Future<Default> resendOtp(String mobile) async {
    return apiClient.resendOtp(mobile);
  }

  Future<User> socialSignIn(String email, String registration_token,
      String name, String mobile, String profile_pic) async {
    return apiClient.socialSignIn(
        email, registration_token, name, mobile, profile_pic);
  }

  Future<ProfileUpdate> UpdateProfile(
      int user_id, File file, String name, String bio) async {
    return apiClient.UpdateProfile(
      user_id,
      file,
      name,
      bio,
    );
  }

  Future<ProfileUpdate> UpdateProfileWithoutPic(
      int user_id, String name, String bio) async {
    return apiClient.UpdateProfileWithoutPic(
      user_id,
      name,
      bio,
    );
  }

  Future<Profile> getProfile(int user_id) async {
    return apiClient.getProfile(user_id);
  }
}
