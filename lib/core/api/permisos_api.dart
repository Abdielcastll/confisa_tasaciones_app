import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/models/permisos_response.dart';
import 'package:tasaciones_app/theme/theme.dart';

class PermisosAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  PermisosAPI(this._http, this._authenticationClient);

  Future<Object> getPermisos(
      {int pageNumber = 1, int pageSize = 900, String descripcion = ""}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/permisos/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return PermisosResponse.fromJson(data);
        },
        queryParameters: {
          'PageSize': pageSize,
          'PageNumber': pageNumber,
          'Descripcion': descripcion
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createPermisos(
      {required String descripcion,
      required int idAccion,
      required int idRecurso,
      required int esBasico}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/permisos/create',
        method: 'POST',
        data: {
          "descripcion": descripcion,
          "idAccion": idAccion,
          "idRecurso": idRecurso,
          "esBasico": esBasico
        },
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return PermisosData.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updatePermisos(
      {required int id,
      required String descripcion,
      required int idAccion,
      required int idRecurso,
      required int esBasico}) async {
    String? _token =
        await _authenticationClient.accessToken.timeout(durationLoading);
    if (_token != null) {
      return _http.request(
        '/api/permisos/update',
        method: 'PUT',
        data: {
          "id": id,
          "descripcion": descripcion,
          "idAccion": idAccion,
          "idRecurso": idRecurso,
          "esBasico": esBasico
        },
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return PermisosPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> deletePermisos({required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/permisos/delete/$id',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return PermisosPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
