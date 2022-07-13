import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';

import '../authentication_client.dart';

class UsuariosAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  UsuariosAPI(this._http, this._authenticationClient);

  Future<Object> getUsuarios({int pageNumber = 1, int pageSize = 100}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/users/get?PageSize=$pageSize&PageNumber=$pageNumber',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return UsuariosResponse.fromJson(data);
      },
    );
  }

  Future<Object> getUsuario({required String id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/users/get/$id',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return UsuariosResponse.fromJson(data);
      },
    );
  }

  Future<Object> getRolUsuario({required String id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/users/get/$id/roles',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return RolUsuarioResponse.fromJson(data);
      },
    );
  }

  Future<Object> createUsuarios(
      {required int id,
      required String descripcion,
      required int idAccion,
      required int idRecurso,
      required int esBasico}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/Usuarios/create',
      method: 'POST',
      data: {
        "id": id,
        "descripcion": descripcion,
        "idAccion": idAccion,
        "idRecurso": idRecurso,
        "esBasico": esBasico
      },
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return UsuariosResponse.fromJson(data);
      },
    );
  }

  Future<Object> updateUsuarios(
      {required int id,
      required String descripcion,
      required int idAccion,
      required int idRecurso,
      required int esBasico}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/Usuarios/update',
      method: 'POST',
      data: {
        "id": id,
        "descripcion": descripcion,
        "idAccion": idAccion,
        "idRecurso": idRecurso,
        "esBasico": esBasico
      },
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return UsuariosResponse.fromJson(data);
      },
    );
  }

  Future<Object> deleteUsuarios({required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/Usuarios/delete/?id=$id',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return UsuariosResponse.fromJson(data);
      },
    );
  }
}
