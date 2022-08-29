import 'package:tasaciones_app/core/models/adjunto_foto_response.dart';

import '../../authentication_client.dart';
import '../../models/seguridad_entidades_generales/adjuntos_response.dart';
import '../api_status.dart';
import '../http.dart';

class AdjuntosApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AdjuntosApi(this._http, this._authenticationClient);

  Future<Object> getAdjuntos({
    String descripcion = "",
    String prefijo = "",
    int pageSize = 900,
    int pageNumber = 1,
    int? id,
    int? esFotoVehiculo,
    int? orden,
  }) async {
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
          "Prefijo": prefijo,
          "EsFotoVehiculo": esFotoVehiculo,
          "Ordon": orden,
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

  Future<Object> createAdjunto(
      {required String descripcion,
      required String prefijo,
      required int esFotoVehiculo,
      required int orden}) async {
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
          "esFotoVehiculo": esFotoVehiculo,
          "orden": orden,
          "prefijo": prefijo
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
      {required int id,
      required String descripcion,
      required String prefijo,
      required int esFotoVehiculo,
      required int orden}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/tipos-adjuntos/update',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "id": id,
          "descripcion": descripcion,
          "esFotoVehiculo": esFotoVehiculo,
          "orden": orden,
          "prefijo": prefijo
        },
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
      return _http.request(
        '/api/adjuntos/add-fotos-tasacion',
        method: "POST",
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "noTasacion": noTasacion,
          "adjuntos": adjuntos,
        },
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
