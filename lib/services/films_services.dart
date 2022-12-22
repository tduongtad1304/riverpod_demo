import 'dart:developer';

import 'package:riverpod_demo/exception/dio_error_handler.dart';

import '../model/films.dart';
import 'package:dio/dio.dart';

class FilmsServices {
  static Future<List<Films>> getFilms() async {
    BaseOptions options = BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = Dio(options);
    const String url = 'http://10.0.2.2:3000/films';

    ///(10.0.2.2 instead of localhost)
    try {
      final response = await dio.get(url);
      final List<dynamic> data = response.data;
      log('data: $data');
      return data.map((e) => Films.fromJson(e)).toList();
    } on DioError catch (e) {
      return Future.error(DioErrorHandler.instance.dioErrorHandler(e));
    }
  }

  static Future<dynamic> updateFilms(Films film) async {
    Dio dio = Dio();
    String url = 'http://10.0.2.2:3000/films/${film.id}';

    ///(10.0.2.2 instead of localhost)
    try {
      final response = await dio.patch(url, data: film.toJson());
      var data = response.data;
      log('data: $data');
      return Films.fromJson(data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        return Future.error(DioErrorHandler.instance.dioErrorHandler(e));
      } else {
        return Future.error(DioErrorHandler.instance.dioErrorHandler(e));
      }
    }
  }
}
