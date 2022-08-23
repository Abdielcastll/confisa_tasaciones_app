import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/models/alarma_response.dart';

class AlarmasApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AlarmasApi(this._http, this._authenticationClient);

  Future<Object> getAlarmas(
      {String descripcion = "",
      bool? enviado,
      String correo = "",
      String titulo = "",
      String fechaCompromiso = "",
      String usuario = "",
      String fechaHora = "",
      int? idSolicitud,
      int pageSize = 900,
      int pageNumber = 1,
      int? id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/alarmas-solicitud/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "Id": id,
          "IdSolicitud": idSolicitud,
          "FechaHora": fechaHora,
          "Usuario": usuario,
          "FechaCompromiso": fechaCompromiso,
          "Titulo": titulo,
          "Correo": correo,
          "Enviado": enviado,
          "Descripcion": descripcion,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return AlarmasResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createAlarma({
    required int idSolicitud,
    required String descripcion,
    required String fechaCompromiso,
    required String titulo,
    required String correo,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/alarmas-solicitud/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "idSolicitud": idSolicitud,
          "descripcion": descripcion,
          "fechaCompromiso": fechaCompromiso,
          "titulo": titulo,
          "correo": correo
        },
        parser: (data) {
          return AlarmasData.fromJson(data["data"]);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateAlarma({
    required int id,
    required String descripcion,
    required String fechaCompromiso,
    required String titulo,
    required String correo,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/alarmas-solicitud/update',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "id": id,
          "descripcion": descripcion,
          "fechaCompromiso": fechaCompromiso,
          "titulo": titulo,
          "correo": correo
        },
        parser: (data) {
          return AlarmasPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> deleteAlarma({
    required int id,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/alarmas-solicitud/delete/$id',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return AlarmasPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
