import 'package:dio/dio.dart';

class DioErrorHandler {
  static final DioErrorHandler _instance = DioErrorHandler._();
  static DioErrorHandler get instance => _instance;

  DioErrorHandler._();

  String dioErrorHandler(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        return 'Request to API server was cancelled';
      case DioErrorType.connectTimeout:
        return 'Connection timeout with API server';
      case DioErrorType.sendTimeout:
        return 'Connection to API server failed due to internet connection';
      case DioErrorType.receiveTimeout:
        return 'Receive timeout in connection with API server';
      case DioErrorType.response:
        return 'Received invalid status code: ${error.response?.statusCode}';
      case DioErrorType.other:
        return 'Send timeout in connection with API server';
      default:
        return 'Something went wrong';
    }
  }
}
