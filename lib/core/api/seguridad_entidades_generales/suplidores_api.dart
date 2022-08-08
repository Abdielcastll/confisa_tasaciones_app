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
    int pageSize = 900,
    int pageNumber = 1,
    int? codigoRelacionado,
  }) async {
    String _token = await _authenticationClient.accessToken;
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
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return SuplidoresResponse.fromJson(data);
      },
    );
  }

  Future<Object> getSuplidoresPorId({
    required int codigoRelacionado,
  }) async {
    String _token = await _authenticationClient.accessToken;
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
  }

  /* Future<Object> createSuplidores({required String descripcion}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/tipo-acciones-solicitud/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "descripcion": descripcion,
      },
      parser: (data) {
        return SuplidoresPOSTResponse.fromJson(data["data"]);
      },
    );
  }

  Future<Object> updateSuplidores(
      {required int id, required String descripcion}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/tipo-acciones-solicitud/update',
      method: 'PUT',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"id": id, "descripcion": descripcion},
      parser: (data) {
        return SuplidoresPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> deleteSuplidores({required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/tipo-acciones-solicitud/delete/$id',
      method: 'DELETE',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return SuplidoresPOSTResponse.fromJson(data);
      },
    );
  } */
}
