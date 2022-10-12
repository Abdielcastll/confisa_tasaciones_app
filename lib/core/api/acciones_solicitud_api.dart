import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/models/acciones_solicitud_response.dart';

class AccionesSolicitudApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AccionesSolicitudApi(this._http, this._authenticationClient);

  Future<Object> getAccionesSolicitud(
      {bool? listo,
      String comentario = "",
      String notas = "",
      String fechaHora = "",
      int? idSolicitud,
      int? tipo,
      int pageSize = 900,
      int pageNumber = 1,
      int? id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/listado-acciones-solicitud/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "Id": id,
          "IdSolicitud": idSolicitud,
          "FechaHora": fechaHora,
          "Tipo": tipo,
          "Notas": notas,
          "Listo": listo,
          "Comentario": comentario,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return AccionesSolicitudResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getTiposAccionesSolicitud() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/tipo-acciones-solicitud/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "PageSize": 10000,
          "PageNumber": 1,
        },
        parser: (data) {
          return TipoAccionesSolicitudResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createAccionSolicitud({
    required int idSolicitud,
    required int tipo,
    required String notas,
    required String comentario,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/listado-acciones-solicitud/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "idSolicitud": idSolicitud,
          "tipo": tipo,
          "notas": notas,
          "comentario": comentario
        },
        parser: (data) {
          return AccionesSolicitudData.fromJson(data["data"]);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateAccionSolicitud({
    required int id,
    required int tipo,
    required String notas,
    required bool listo,
    required String comentario,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/listado-acciones-solicitud/update',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "id": id,
          "tipo": tipo,
          "notas": notas,
          "listo": listo,
          "comentario": comentario
        },
        parser: (data) {
          return AccionesSolicitudPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> deleteAccionSolicitud({
    required int id,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/listado-acciones-solicitud/delete/$id',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return AccionesSolicitudPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
