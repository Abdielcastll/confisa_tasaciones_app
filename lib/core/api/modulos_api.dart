import 'package:tasaciones_app/core/models/modulos_response.dart';

import '../authentication_client.dart';
import 'http.dart';

class ModulosApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  ModulosApi(this._http, this._authenticationClient);

  Future<Object> getModulos({
    int pageNumber = 1,
    int pageSize = 20,
    int? id,
    String name = '',
  }) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request('/api/modulos/get', headers: {
      'Authorization': 'Bearer $_token',
    }, queryParameters: {
      "Nombre": name,
      "PageSize": pageSize,
      "PageNumber": pageNumber,
      "id": id,
    }, parser: (data) {
      return ModulosResponse.fromJson(data);
    });
  }

  Future<Object> createModulos({required String name}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/modulos/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "nombre": name,
      },
    );
  }

  Future<Object> updateModulos({required String name, required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/modulos/update',
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

  Future<Object> deleteModulos({required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/modulos/delete/$id',
      method: "DELETE",
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
  }
}
