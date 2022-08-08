import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/accesorios_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class AccesoriosApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AccesoriosApi(this._http, this._authenticationClient);

  Future<Object> getAccesorios(
      {int pageSize = 900,
      int pageNumber = 1,
      String descripcion = "",
      int? id,
      int? idSegmento}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/accesorios/get',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        "Id": id,
        "Descripcion": descripcion,
        "IdSegmento": idSegmento,
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return AccesoriosResponse.fromJson(data);
      },
    );
  }

  Future<Object> updateAccesorios(
      {required int id,
      required String descripcion,
      required int idSegmento}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/accesorios/update',
      method: 'PUT',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"id": id, "descripcion": descripcion, "idSegmento": idSegmento},
      parser: (data) {
        return AccesoriosPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> createAccesorios(
      {required String descripcion, required int idSegmento}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/accesorios/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"descripcion": descripcion, "idSegmento": idSegmento},
      parser: (data) {
        return AccesoriosPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> deleteAccesorios({required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/accesorios/delete/$id',
      method: 'DELETE',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return AccesoriosPOSTResponse.fromJson(data);
      },
    );
  }
}
