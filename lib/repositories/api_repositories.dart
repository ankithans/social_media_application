import 'package:social_media_application/models/default.dart';
import 'package:social_media_application/models/login/user.dart';
import 'package:social_media_application/repositories/api_client.dart';

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
}
