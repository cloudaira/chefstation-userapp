import 'package:chefstation_multivendor/common/models/response_model.dart';
import 'package:chefstation_multivendor/api/api_client.dart';
import 'package:chefstation_multivendor/features/auth/domain/models/auth_response_model.dart';
import 'package:chefstation_multivendor/features/verification/domain/models/verification_data_model.dart';
import 'package:chefstation_multivendor/features/verification/domain/repositories/verification_repo_interface.dart';
import 'package:chefstation_multivendor/helper/auth_helper.dart';
import 'package:chefstation_multivendor/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationRepo implements VerificationRepoInterface{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  VerificationRepo({required this.sharedPreferences, required this.apiClient});

  @override
  Future<ResponseModel> forgetPassword(String? phone) async {
    Response response = await apiClient.postData(AppConstants.forgetPasswordUri, {"phone": phone}, handleError: false);
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> verifyToken(String? phone, String token) async {
    Response response = await apiClient.postData(AppConstants.verifyTokenUri, {"phone": phone, "reset_token": token}, handleError: false);
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> resetPassword(String? resetToken, String number, String password, String confirmPassword) async {
    Response response = await apiClient.postData(
      AppConstants.resetPasswordUri,
      {"_method": "put", "reset_token": resetToken, "phone": number, "password": password, "confirm_password": confirmPassword},
      handleError: false,
    );
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> checkEmail(String email) async {
    Response response = await apiClient.postData(AppConstants.checkEmailUri, {"email": email}, handleError: false);
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["token"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<Response> verifyEmail(String email, String token) async {
    return await apiClient.postData(AppConstants.verifyEmailUri, {"email": email, "token": token}, handleError: false);
  }

  @override
  Future<Response> verifyPhone(VerificationDataModel data) async {
    return await apiClient.postData(AppConstants.verifyPhoneUri, data.toJson(), handleError: false);
  }

  @override
  Future<ResponseModel> verifyFirebaseOtp({required String phoneNumber, required String session, required String otp, required String loginType}) async {
    String guestId = AuthHelper.getGuestId();
    Map<String, dynamic> data = {
      'session_info' : session,
      'phone' : phoneNumber,
      'otp' : otp,
      'login_type' : loginType,
    };
    if(guestId.isNotEmpty) {
      data.addAll({"guest_id": guestId});
    }
    Response response = await apiClient.postData(AppConstants.firebaseAuthVerify, data);
    if (response.statusCode == 200) {
      AuthResponseModel authResponse = AuthResponseModel.fromJson(response.body);
      return ResponseModel(true, response.body["message"], authResponseModel: authResponse);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> verifyForgetPassFirebaseOtp({required String phoneNumber, required String session, required String otp}) async {
    Response response = await apiClient.postData(AppConstants.firebaseResetPassword,
      {'sessionInfo' : session,
        'phoneNumber' : phoneNumber,
        'code' : otp,
        'is_reset_token' : 1,
        '_method': 'PUT'
      },
    );
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
 