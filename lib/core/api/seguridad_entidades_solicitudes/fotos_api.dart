import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/models/cantidad_fotos_response.dart';

class FotosApi {
  FotosApi(this._http, this._authenticationClient);
  final Http _http;
  final AuthenticationClient _authenticationClient;

  Future<Object> getCantidadFotos() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/fotos/get-cantidad',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return EntidadResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateCantidad({required String descripcion, int? id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/fotos/update-cantidad',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"id": id, "descripcion": descripcion},
        parser: (data) {
          return EntidadPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getOpcionesTipos() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/fotos/get-opciones-tipos',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return EntidadResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getTipoFotos() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/fotos/get-tipos',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return EntidadResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateTipos(
      {required String descripcion, required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/fotos/update-tipos',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"id": id, "descripcion": descripcion},
        parser: (data) {
          return EntidadPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
