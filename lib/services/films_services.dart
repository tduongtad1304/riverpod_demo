import 'dart:developer';

import '../model/films.dart';
import 'package:dio/dio.dart' as dio;

class FilmsServices {
  static Future<List<Films>> getFilms() async {
    const String url = 'http://10.0.2.2:3000/films';

    ///(10.0.2.2 instead of localhost)
    try {
      final response = await dio.Dio().get(url);
      final List<dynamic> data = response.data;
      log('data: $data');
      return data.map((e) => Films.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<dynamic> updateFilms(Films film) async {
    String url = 'http://10.0.2.2:3000/films/${film.id}';

    ///(10.0.2.2 instead of localhost)
    try {
      final response = await dio.Dio().patch(url, data: film.toJson());
      var data = response.data;
      log('data: $data');
      return Films.fromJson(data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
