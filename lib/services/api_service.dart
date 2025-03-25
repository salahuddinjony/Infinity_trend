import 'package:dio/dio.dart';
import 'package:login_page/pages/bazar%20pages/const.dart';
// ignore: depend_on_referenced_packages

class ApiBaseHelper {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: EndPoint.base_url,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 10),
  ));

  // GET Request: Fetch data from API
  Future<dynamic> get(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'deviceId': "44b4d8cd-7a2d-4a5f-a0e2-798021f1e294",
            'Content-Type': 'application/json',
            'User-Agent': 'nopstationcart.flutter/v1'
          },
        ),
      );

      if (response.statusCode == 200) {
        print("GET Success: ${response.statusCode}");
        return response.data;
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("DioError: ${e.message}, Response: ${e.response?.statusCode}");
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      print("Unexpected Error: $e");
      throw Exception("Unexpected error occurred");
    }
  }
}