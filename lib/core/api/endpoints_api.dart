import 'package:tasaciones_app/core/models/endpoints_response.dart';

import '../authentication_client.dart';
import '../models/acciones_response.dart';
import 'http.dart';

class EndpointsApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  EndpointsApi(this._http, this._authenticationClient);

  Future<Object> getEndpoints(
      {String controlador = "", int pageSize = 900, int pageNumber = 1}) async {
    String _token = await _authenticationClient.accessToken;
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
  }

  Future<Object> createEndpoint(
      {required String controlador,
      required String nombre,
      required String metodo,
      required String httpVerbo}) async {
    String _token = await _authenticationClient.accessToken;
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
  }

  Future<Object> deleteEndpoint({required int id}) async {
    String _token = await _authenticationClient.accessToken;
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
  }

  Future<Object> updateEndpoint(
      {required int id,
      required String nombre,
      required String controlador,
      required String metodo,
      required String httpVerbo}) async {
    String _token = await _authenticationClient.accessToken;
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
  }
}
