import 'package:bsthrm/model/key_settings_model.dart';
import 'package:bsthrm/model/user_details.dart';
import 'package:bsthrm/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiAccess {
  static final ApiAccess _instance = ApiAccess._internal();
  factory ApiAccess() => _instance;
  ApiAccess._internal() {
    _dio.interceptors.add(_loggingInterceptor);
    _dio.interceptors.add(_authInterceptor);
    _dio.options.baseUrl = baseUrl;
  }
  final _dio = Dio();
  static const String baseUrl = "https://ragroup.ind.in/api/";
  Dio get dio => _dio;
  Interceptor get _loggingInterceptor => InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          debugPrint("Request: ${options.uri}");
          debugPrint("Headers: ${options.headers}");
          debugPrint("Body: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, ResponseInterceptorHandler handler) {
          debugPrint("Response: ${response.headers}");
          debugPrint("Body: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) {
          debugPrint("Error: ${e.message}");
          return handler.next(e);
        },
      );
  //  Interceptor get _authInterceptor => InterceptorsWrapper(
  //   onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
  //     options.headers.addAll({
  //       'security_authentication_id': "d347774d04690c2c5e7457a8a03e02e7",
  //       'security_token': "2b45da5375d29a009023e25f27a2ddd4",
  //     });
  //     return handler.next(options);
  //   },
  // );
  Interceptor get _authInterceptor => InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          options.data = {
            ...options.data,
            'security_authentication_id': "d347774d04690c2c5e7457a8a03e02e7",
            'security_token': "2b45da5375d29a009023e25f27a2ddd4",
          };
          return handler.next(options);
        },
      );
  Future<bool> verifyPan({
    required String panNo,
    required String employeeId,
  }) async {
    try {
      final response = await _dio.post(
        'verify_pan',
        data: {
          'pan_no': panNo,
          'employee_id': employeeId,
        },
      );
      var data = response.data[0];
      if (data['error_code']?.toString() == '0') {
        Utils.showToast("Successfully Verified");
        return true;
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    }
    Utils.showToast("Try Again");
    return false;
  }

  Future<bool> verifyBank({
    required String employeeId,
    required String accNo,
    required String ifsc,
  }) async {
    try {
      final response = await _dio.post(
        'verify_bank',
        data: {
          'employee_id': employeeId,
          'acc_no': accNo,
          'ifsc': ifsc,
        },
      );
      var data = response.data[0];
      if (data['error_code']?.toString() == '0') {
        Utils.showToast("Successfully Verified");
        return true;
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    }
    Utils.showToast("Try Again");
    return false;
  }

//   https://ragroup.ind.in/api/upload_documents
// security_authentication_id=d347774d04690c2c5e7457a8a03e02e7
// security_token=2b45da5375d29a009023e25f27a2ddd4
// employee_id=1
// aadhar_card=base64
// pan_card=base64
// bank_passbook=base64
// [
//     {
//         "error_code": "0",
//         "message": "1",
//     }
// ] create api images are in base64 format
  Future<bool> uploadDocuments({
    required String employeeId,
    required String aadharCard,
    required String panCard,
    required String bankPassbook,
  }) async {
    try {
      final response = await _dio.post(
        'upload_documents',
        data: {
          'employee_id': employeeId,
          'aadhar_card': aadharCard,
          'pan_card': panCard,
          'bank_passbook': bankPassbook,
        },
      );
      var data = response.data[0];
      if (data['error_code'].toString() == '0') {
        Utils.showToast("Successfully Uploaded");
        return true;
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    }
    Utils.showToast("Try Again");
    return false;
  }

  Future<UserDetails?> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'login',
        data: {
          'username': username,
          'password': password,
        },
      );
      var data = response.data[0];
      if (data['error_code']?.toString() == '0') {
        return UserDetails.fromJson(data);
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    }
    Utils.showToast("Try Again");
    return null;
  }

  Future<String?> getAadharOtp({
    required String employeeId,
    required String aadharNo,
  }) async {
    try {
      final response = await _dio.post(
        'get_aadhar_otp',
        data: {
          'employee_id': employeeId,
          'aadhar_no': aadharNo,
        },
      );
      var data = response.data[0];
      if (data['message'].toString() != '0' &&
          data['request_id'].toString() != '') {
        return data['request_id'];
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    }
    Utils.showToast("Try Again");
    return null;
  }

  Future<bool> verifyAadhar({
    required String employeeId,
    required String aadharNo,
    required String otp,
    required String requestId,
  }) async {
    try {
      final response = await _dio.post(
        'verify_aadhar',
        data: {
          'employee_id': employeeId,
          'aadhar_no': aadharNo,
          'otp': otp,
          'request_id': requestId,
        },
      );
      var data = response.data[0];
      if (data['error_code']?.toString() == '0') {
        Utils.showToast("Successfully Verified");
        return true;
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    }
    Utils.showToast("Try Again");
    return false;
  }

  Future<KycSettingModel?> kycSettings({
    required String employeeId,
  }) async {
    try {
      final response = await _dio.post(
        'kyc_settings',
        data: {'employee_id': employeeId},
      );
      var data = response.data[0];
      if (data['error_code'].toString() == '0') {
        return KycSettingModel.fromJson(data);
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    }
    return null;
  }
}
