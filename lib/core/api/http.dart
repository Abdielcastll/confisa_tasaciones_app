import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tasaciones_app/core/api/api_status.dart';

class Http {
  late Dio _dio;
  late Logger _logger;
  late bool _logsEnabled;
  Http({
    required Dio dio,
    required Logger logger,
    required bool logsEnabled,
  }) {
    _dio = dio;
    _logger = logger;
    _logsEnabled = logsEnabled;
  }

  Future<Object> request(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.request<Map<String, dynamic>>(
        path,
        options: Options(
          method: method,
          headers: headers,
        ),
        queryParameters: queryParameters,
        data: data,
      );
      if (_logsEnabled) _logger.i(response.data);
      return Success(response: response.data!);
    } catch (e) {
      Failure data = Failure(
        messages: ['No Internet'],
        source: '',
        exception: '',
        errorId: '',
        supportMessage: '',
        statusCode: 0,
      );
      if (e is DioError) {
        if (_logsEnabled) _logger.e(e.response?.data);
        data = Failure.fromJson(e.response?.data);
      }
      return data;
    }
  }
}
