import 'dart:developer';

import 'package:dio/dio.dart';

class ApiClass {
  register({
    required String name,
    required String email,
    required String password,
    required String contactNo,
    String? referedBy,
  }) async {
    try {
      final response = await Dio().post(
        'https://bringesse.com:3002/accounts/signup',
        data: {
          "name": name,
          "contactNo": contactNo,
          "email": email,
          "password": password,
          'referedBy': referedBy
        },
      );
      log("singupres:${response.data},${response.data['status_code']}");
      if (response.data['status_code'] == 200) {
        return {"status": true};
      } else {
        print("sdfbsd");
        return {"status": false, "message": response.data['message']};
        // throw Exception('Failed to register');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
