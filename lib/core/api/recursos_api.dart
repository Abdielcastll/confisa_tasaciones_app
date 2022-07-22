import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/recursos_response.dart';

import '../authentication_client.dart';
import '../models/menu_response.dart';

class RecursosAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  RecursosAPI(this._http, this._authenticationClient);

  Future<Object> getRecursos(
      {int pageNumber = 1, int pageSize = 20, String name = ''}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/recursos/get',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        "Nombre": name,
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return RecursosResponse.fromJson(data);
      },
    );
  }

  Future<Object> getMenu() async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/recursos/get/menu',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return MenuResponse.fromJson(data);
      },
    );
  }

  Future<Object> createRecursos(
      {required String name, required int idModulo}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/recursos/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "nombre": name,
        "idModulo": idModulo,
      },
    );
  }

  Future<Object> updateRecursos({
    required int id,
    required String nombre,
    required int idModulo,
  }) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/recursos/update',
      method: "PUT",
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "id": id,
        "nombre": nombre,
        "idModulo": idModulo,
      },
    );
  }

  Future<Object> deleteRecursos({required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/recursos/delete',
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
