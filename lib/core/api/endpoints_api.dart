import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/endpoints_response.dart';

import '../authentication_client.dart';
import 'http.dart';

class EndpointsApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  EndpointsApi(this._http, this._authenticationClient);

  Future<Object> getEndpoints(
      {String controlador = "", int pageSize = 900, int pageNumber = 1}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/endpoints/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "Controlador": controlador,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return EndpointsResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createEndpoint(
      {required String controlador,
      required String nombre,
      required String metodo,
      required String httpVerbo}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/endpoints/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "nombre": nombre,
          "controlador": controlador,
          "metodo": metodo,
          "httpVerbo": httpVerbo,
          "estado": true,
        },
        parser: (data) {
          return EndpointsData.fromJson(data["data"]);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> deleteEndpoint({required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/endpoints/delete/$id',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return EndpointsPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> assignPermisoEndpoint(
      {required int endpointId,
      required int permisoId,
      bool estado = true}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/endpoints/assign-permiso',
        method: 'POST',
        data: {"id": 0, "endpointId": endpointId, "permisoId": permisoId},
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return EndpointsPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateEndpoint(
      {required int id,
      required String nombre,
      required String controlador,
      required String metodo,
      required String httpVerbo}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/endpoints/update',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "id": id,
          "nombre": nombre,
          "controlador": controlador,
          "metodo": metodo,
          "httpVerbo": httpVerbo,
          "estado": true,
        },
        parser: (data) {
          return EndpointsPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
