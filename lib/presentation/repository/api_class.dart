import 'dart:developer';

import 'package:dio/dio.dart';

class ApiClass {
  register({
    required String name,
    required String email,
    required String password,
    required String contactNo,
  }) async {
    try {
      final response = await Dio().post(
        'https://bringesse.com:3002/accounts/signup',
        data: {
          "name": name,
          "contactNo": contactNo,
          "email": email,
          "password": password
        },
      );
      log("responseData:${response.data},${response.data['status_code']}");
      if (response.statusCode == 200) {
        return {"status": true};
      } else {
        throw Exception('Failed to register');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
