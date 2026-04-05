import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../services/app_config.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  )
    ..interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: kDebugMode,
        error: kDebugMode,
        logPrint: (o) {
          if (kDebugMode) {
            // ignore: avoid_print
            print(o);
          }
        },
      ),
    );
}
