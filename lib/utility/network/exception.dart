import 'package:bringessesellerapp/utility/network/local_keys.dart';
import 'package:dio/dio.dart';



class DataException implements Exception {
  DataException({required this.message});

  DataException.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = LocaleKeys.errorRequestCancelled;
        break;
      case DioErrorType.connectionTimeout:
        message = LocaleKeys.errorConnectionTimeout;
        break;
      case DioErrorType.receiveTimeout:
        message = LocaleKeys.errorReceiveTimeout;
        break;
      case DioErrorType.receiveTimeout:
        message = _handleError(dioError.response!.statusCode!);
        break;
      case DioErrorType.sendTimeout:
        message = LocaleKeys.errorSendTimeout;
        break;
      case DioErrorType.unknown:
        message = LocaleKeys.errorSocketException;
        break;
      default:
        message = handleErrorResponse(dioError);
        break;
    }
  }

  String message = "";

  String _handleError(int statusCode) {
    switch (statusCode) {
      case 400:
        return LocaleKeys.errorBadRequest;
      case 404:
        return LocaleKeys.errorRequestNotFound;
      case 500:
        return LocaleKeys.errorIntenalServer;
      default:
        return LocaleKeys.errorSomethingWentWrong;
    }
  }
  String handleErrorResponse(DioError error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final errorMessage = error.response?.data['message'] ?? 'Request failed with status code $statusCode';
      return errorMessage;
    } else {
      return 'Network error: ${error.message}';
    }
  }

  @override
  String toString() => message;
}

