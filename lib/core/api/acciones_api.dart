import '../authentication_client.dart';
import '../models/acciones_response.dart';
import 'api_status.dart';
import 'http.dart';

class AccionesApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AccionesApi(this._http, this._authenticationClient);

  Future<Object> getAcciones({
    int pageNumber = 1,
    int pageSize = 999,
    String name = '',
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/acciones/get',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "Nombre": name,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return AccionesResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createAcciones({required String name}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
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
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateAcciones({required String name, required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
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
    } else {
      return TokenFail();
    }
  }

  Future<Object> deleteAcciones({required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/acciones/delete/$id',
        method: "DELETE",
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
    } else {
      return TokenFail();
    }
  }
}
