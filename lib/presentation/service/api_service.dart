import 'dart:convert';
import 'dart:developer';

import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/utility/network/exception.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;
  SharedPreferenceHelper? sharedPreferenceHelper;

  ApiService(this.dio, this.sharedPreferenceHelper);

  Future<Map<String, dynamic>> _getHeaders() async {
    final token = sharedPreferenceHelper?.getToken;
    final sellerId = sharedPreferenceHelper?.getSellerId;
    print("slkdfhs$sellerId");
    return {
      'Content-Type': 'application/json',
      'Authorization': '$token',
      'sellerid': '${sellerId.toString()}'
    };
  }

  Future<Map<String, dynamic>> _refreshHeaders() async {
    final token = sharedPreferenceHelper?.getRefreshToken;
    final sellerId = sharedPreferenceHelper?.getSellerId;
    print("sdjfbs$token");
    return {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    };
  }

  Future<Map<String, dynamic>> _getHeaders1() async {
    return {
      'Content-Type': 'application/json',
    };
  }

  Future<Response> getprofile(String endpoint, bool? _isheaders,
      {Map<String, dynamic>? headers}) async {
    try {
      if (_isheaders == true) {
        headers ??= await _getHeaders();
      }

      print("lakdfhsfff${headers}");
      // headers!.putIfAbsent('Content-Type', () => 'application/json');

      final response = await dio.get(
        endpoint,
        options: Options(
          headers: headers,
        ),
      );

      print("Request Headers: $headers");
      print("Endpoint: $endpoint");

      return response;
    } on DioError catch (e) {
      throw DataException.fromDioError(e);
    }
  }

  Future<Response> get(String endpoint, bool? _isheaders,
      {Map<String, dynamic>? headers}) async {
    try {
      if (_isheaders == true) {
        headers ??= await _getHeaders();
      }
      if (_isheaders == false) {
        headers ??= await _getHeaders1();
      }
      //print("lakdfhs${headers}");
      headers!.putIfAbsent('Content-Type', () => 'application/json');

      final response = await dio.get(
        endpoint,
        options: Options(
          headers: headers,
        ),
      );

      print("Request Headers: $headers");
      print("Endpoint: $endpoint");

      return response;
    } on DioError catch (e) {
      throw DataException.fromDioError(e);
    }
  }

  Future<Response> getRefresh(String endpoint, bool? _isheaders,
      {Map<String, dynamic>? headers}) async {
    try {
      if (_isheaders == true) {
        headers ??= await _refreshHeaders();
      }

      headers!.putIfAbsent('Content-Type', () => 'application/json');

      final response = await dio.get(
        endpoint,
        options: Options(
          headers: headers,
        ),
      );

      print("Request Headers: $headers");
      print("Endpoint: $endpoint");

      return response;
    } on DioError catch (e) {
      throw DataException.fromDioError(e);
    }
  }

  Future<Response> post(String? endpoint, dynamic body, bool? _isheaders,
      {Map<String, dynamic>? headers,
      isFormData = false,
      bool? isrefresh}) async {
    try {
      print(body);

      if (_isheaders == true) {
        headers ??= await _getHeaders();
      }
      if (_isheaders == false) {
        headers ??= await _getHeaders1();
      }

      print(headers);
      print("BodyData:$headers");
      Response response;
      if (isFormData) {
        response = await dio.post(
          endpoint!,
          data: body as FormData,
          options: Options(headers: headers),
        );
      } else {
        response = await dio.post(
          endpoint!,
          data: jsonEncode(body),
          options: Options(headers: headers),
        );
      }

      return response;
    } on DioError catch (e) {
      throw DataException.fromDioError(e);
    }
  }

  Future<Response> refresToken(
    String? endpoint,
    dynamic body,
    bool? _isheaders, {
    Map<String, dynamic>? headers,
    isFormData = false,
  }) async {
    try {
      print(body);

      if (_isheaders == true) {
        headers ??= await _refreshHeaders();
      }
      print(headers);
      print("BodyData:$headers");
      Response response;
      if (isFormData) {
        response = await dio.post(
          endpoint!,
          data: body as FormData,
          options: Options(headers: headers),
        );
      } else {
        response = await dio.post(
          endpoint!,
          data: jsonEncode(body),
          options: Options(headers: headers),
        );
      }

      return response;
    } on DioError catch (e) {
      throw DataException.fromDioError(e);
    }
  }

  Future<Response> delete(String? endpoint, bool? _isheaders,
      {Map<String, dynamic>? headers, dynamic body}) async {
    try {
      print("DELETE Endpoint: $endpoint");
      if (_isheaders == true) {
        headers ??= await _getHeaders();
      } else {
        headers ??= await _getHeaders1();
      }

      print("Final Headers: $headers");
      print("Body: $body");

      final response = await dio.delete(
        endpoint!,
        data: body != null ? jsonEncode(body) : null,
        options: Options(headers: headers),
      );

      print("DELETE Response: ${response.data}");
      return response;
    } on DioError catch (e) {
      throw DataException.fromDioError(e);
    }
  }

  Future<Response> patch(
    String? endpoint,
    dynamic body,
    bool? _isheaders, {
    Map<String, dynamic>? headers,
    bool isFormData = false,
  }) async {
    try {
      print("PATCH Endpoint: $endpoint");
      print("Incoming Body: $body");

      // Handle headers based on flag
      if (_isheaders == true) {
        headers ??= await _getHeaders();
      } else {
        headers ??= await _getHeaders1();
      }

      print("Final Headers: $headers");

      Response response;
      if (isFormData) {
        // ✅ Handle multipart/form-data
        response = await dio.patch(
          endpoint!,
          data: body as FormData,
          options: Options(headers: headers),
        );
      } else {
        // ✅ Default JSON patch
        response = await dio.patch(
          endpoint!,
          data: jsonEncode(body),
          options: Options(headers: headers),
        );
      }

      print("PATCH Response: ${response.data}");
      return response;
    } on DioError catch (e) {
      throw DataException.fromDioError(e);
    }
  }

  FormData mapToFormData(Map<String, dynamic> data) {
    final formData = FormData();
    data.forEach((key, value) {
      switch (key) {
        case "noteworthy_files":
        case "capa_format":
        case "upload_files":
          // Uncomment and update this section as needed
          /*var items  = (value as List<ItemsFile>);
          items.forEach((element) async {
            if (element.fileId?.isNotEmpty == true) {
              formData.files.add(MapEntry(
                key,
                await MultipartFile.fromFile(element.fileUrl ?? "", filename: basename(element.fileUrl ?? "")),
              ));
            }
          });*/
          break;
        default:
          formData.fields.add(MapEntry(key, value.toString()));
          break;
      }
    });
    return formData;
  }
}
