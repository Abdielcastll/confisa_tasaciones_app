import '../authentication_client.dart';
import '../models/acciones_response.dart';
import 'http.dart';

class AccionesApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AccionesApi(this._http, this._authenticationClient);

  Future<Object> getAcciones(
      {int pageNumber = 1, int pageSize = 20, String id = ''}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/acciones/get',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        "id": id,
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return AccionesResponse.fromJson(data);
      },
    );
  }

  Future<Object> createAcciones({required String name}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/acciones/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "nombre": name,
      },
    );
  }

  Future<Object> updateAcciones({required String name, required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/acciones/update',
      method: "PUT",
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "id": id,
        "nombre": name,
      },
    );
  }

  Future<Object> deleteAcciones({required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/acciones/update',
      method: "DELETE",
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        "id": id,
      },
    );
  }
}
