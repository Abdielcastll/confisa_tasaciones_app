import '../authentication_client.dart';
import 'http.dart';

class AccionesPendientesApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AccionesPendientesApi(this._http, this._authenticationClient);

  Future<Object> getAccionesPendientes(
      {String descripcion = "",
      int pageSize = 900,
      int pageNumber = 1,
      int? id,
      int? elemento}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/tipos-acciones-solicitud/get',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        "Id": id,
        "Descripcion": descripcion,
        "Elemento": elemento,
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return AccionesPendientesResponse.fromJson(data);
      },
    );
  }

  Future<Object> createAccionesPendientes({required String descripcion}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/tipos-acciones-solicitud/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "descripcion": descripcion,
      },
      parser: (data) {
        return AccionesPendientesData.fromJson(data["data"]);
      },
    );
  }

  Future<Object> updateAccionesPendientes(
      {required int id, required String descripcion}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/tipos-acciones-solicitud/update',
      method: 'PUT',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"id": id, "descripcion": descripcion},
      parser: (data) {
        return AccionesPendientesPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> deleteAccionesPendientes(
      {required int id, required String descripcion}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/tipos-acciones-solicitud/delete/$id',
      method: 'DELETE',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"id": id, "descripcion": descripcion},
      parser: (data) {
        return AccionesPendientesPOSTResponse.fromJson(data);
      },
    );
  }
}
