import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';

class UsuariosAPI {
  final Http _http;
  UsuariosAPI(this._http);

  Future<Object> getUsuarios(
      {required String token, int pageNumber = 1, int pageSize = 100}) {
    return _http.request(
      '/api/users/get?PageSize=$pageSize&PageNumber=$pageNumber',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $token',
      },
      parser: (data) {
        return UsuariosResponse.fromJson(data);
      },
    );
  }

  Future<Object> getUsuario({required String token, required String id}) {
    return _http.request(
      '/api/users/get/$id',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $token',
      },
      parser: (data) {
        return UsuariosResponse.fromJson(data);
      },
    );
  }

  Future<Object> getRolUsuario({required String token, required String id}) {
    return _http.request(
      '/api/users/get/$id/roles',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $token',
      },
      parser: (data) {
        return RolUsuarioResponse.fromJson(data);
      },
    );
  }

  Future<Object> createUsuarios(
      {required String token,
      required int id,
      required String descripcion,
      required int idAccion,
      required int idRecurso,
      required int esBasico}) {
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
        'Authorization': 'Bearer $token',
      },
      parser: (data) {
        return UsuariosResponse.fromJson(data);
      },
    );
  }

  Future<Object> updateUsuarios(
      {required String token,
      required int id,
      required String descripcion,
      required int idAccion,
      required int idRecurso,
      required int esBasico}) {
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
        'Authorization': 'Bearer $token',
      },
      parser: (data) {
        return UsuariosResponse.fromJson(data);
      },
    );
  }

  Future<Object> deleteUsuarios({required String token, required int id}) {
    return _http.request(
      '/api/Usuarios/delete/?id=$id',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $token',
      },
      parser: (data) {
        return UsuariosResponse.fromJson(data);
      },
    );
  }
}
