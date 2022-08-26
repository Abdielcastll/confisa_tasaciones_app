import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/suplidores_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class SuplidoresApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  SuplidoresApi(this._http, this._authenticationClient);

  Future<Object> getSuplidores({
    String nombre = "",
    String identificacion = "",
    int? estado,
    String direccion = "",
    String email = "",
    int pageSize = 900,
    int pageNumber = 1,
    int? codigoRelacionado,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/suplidores/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "CodigoRelacionado": codigoRelacionado,
          "Nombre": nombre,
          "Identificacion": identificacion,
          "Estado": estado,
          "Direccion": direccion,
          "Email": email,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return SuplidoresResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getSuplidoresPorId({
    required int codigoRelacionado,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/suplidores/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "CodigoRelacionado": codigoRelacionado,
        },
        parser: (data) {
          return SuplidoresResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateSuplidor(
      {required int idSuplidor,
      required int estado,
      required String detalles,
      required String registro}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/suplidores/update',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "idSuplidor": idSuplidor,
          "estado": estado,
          "detalles": detalles,
          "registro": registro
        },
        parser: (data) {
          return SuplidoresPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
