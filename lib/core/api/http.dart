import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/theme/theme.dart';

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

  Future<Object> request<T>(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    T Function(dynamic data)? parser,
  }) async {
    try {
      if (path == "/api/monto-factura-minima-sucursal/get") {
        final response = await _dio
            .request<List<dynamic>>(
              path,
              options: Options(
                method: method,
                headers: headers,
              ),
              queryParameters: queryParameters,
              data: data,
            )
            .timeout(durationLoading);
        if (_logsEnabled) _logger.i(response.data);
        if (parser != null) {
          return Success<T>(response: parser(response.data));
        }
        return Success(response: response.data!);
      }
      final response = await _dio
          .request<Map<String, dynamic>>(
            path,
            options: Options(
              method: method,
              headers: headers,
            ),
            queryParameters: queryParameters,
            data: data,
          )
          .timeout(durationLoading);
      if (_logsEnabled) _logger.i(response.data);
      if (parser != null) {
        return Success<T>(response: parser(response.data));
      }
      return Success(response: response.data!);
    } catch (e) {
      _logger.e(e);
      Failure data = Failure(
        messages: ['No Internet'],
        supportMessage: '',
        statusCode: 0,
      );
      if (e is DioError) {
        if (_logsEnabled) _logger.e(e.response?.data ?? 'DioError Null');
        if (e.response?.data != null) {
          try {
            data = Failure.fromJson(e.response?.data);
          } catch (e) {
            data = Failure(
                messages: ['Error desconocido'],
                supportMessage: 'Error',
                statusCode: 0);
          }
        }
      }
      return data;
    }
  }
}
