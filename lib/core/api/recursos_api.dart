import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/recursos_response.dart';

import '../authentication_client.dart';
import '../models/menu_response.dart';
import 'api_status.dart';

class RecursosAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  RecursosAPI(this._http, this._authenticationClient);

  Future<Object> getRecursos(
      {int pageNumber = 1,
      int pageSize = 999,
      String name = '',
      String nombreModulo = ""}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/recursos/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "Nombre": name,
          "NombreModulo": nombreModulo,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return RecursosResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getMenu() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/recursos/get/menu',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return MenuResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createRecursos(
      {required String name,
      required int idModulo,
      required int esMenuConfiguracion,
      required String descripcionMenuConfiguracion,
      required String url}) async {
    String? _token = await _authenticationClient.accessToken;

    if (_token != null) {
      return _http.request(
        '/api/recursos/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "nombre": name,
          "idModulo": idModulo,
          "esMenuConfiguracion": esMenuConfiguracion,
          "descripcionMenuConfiguracion": descripcionMenuConfiguracion,
          "url": url
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateRecursos(
      {required int id,
      required String nombre,
      required int idModulo,
      required String descripcionMenuConfiguracion,
      required int esMenuConfiguracion,
      required String url}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/recursos/update',
        method: "PUT",
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "id": id,
          "nombre": nombre,
          "idModulo": idModulo,
          "esMenuConfiguracion": esMenuConfiguracion,
          "descripcionMenuConfiguracion": descripcionMenuConfiguracion,
          "url": url
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> deleteRecursos({required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/recursos/delete/$id',
        method: "DELETE",
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
    } else {
      return TokenFail();
    }
  }
}
