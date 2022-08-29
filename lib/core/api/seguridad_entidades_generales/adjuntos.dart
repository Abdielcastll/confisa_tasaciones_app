import 'package:logger/logger.dart';
import 'package:tasaciones_app/core/models/adjunto_foto_response.dart';

import '../../authentication_client.dart';
import '../../models/seguridad_entidades_generales/adjuntos_response.dart';
import '../api_status.dart';
import '../http.dart';

class AdjuntosApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AdjuntosApi(this._http, this._authenticationClient);
  Logger _logger = Logger();

  Future<Object> getAdjuntos(
      {String descripcion = "",
      int pageSize = 900,
      int pageNumber = 1,
      int? id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/tipos-adjuntos/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "Id": id,
          "Descripcion": descripcion,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return AdjuntosResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createAdjunto({required String descripcion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/tipos-adjuntos/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "descripcion": descripcion,
        },
        parser: (data) {
          return AdjuntosData.fromJson(data["data"]);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateAdjunto(
      {required int id, required String descripcion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/tipos-adjuntos/update',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"id": id, "descripcion": descripcion},
        parser: (data) {
          return AdjuntosPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> addFotosTasacion({
    required int noTasacion,
    required List<Map<String, dynamic>> adjuntos,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      final body = {
        "noTasacion": noTasacion,
        "adjuntos": adjuntos,
      };
      // _logger.i(body);
      return _http.request(
        '/api/adjuntos/add-fotos-tasacion',
        method: "POST",
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: body,
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getFotosTasacion({required int noTasacion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/adjuntos/get/$noTasacion',
        method: "GET",
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return AdjuntosFotoResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
