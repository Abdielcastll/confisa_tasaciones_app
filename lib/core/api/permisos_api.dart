import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/permisos_response.dart';

class PermisosAPI {
  final Http _http;
  PermisosAPI(this._http);

  Future<Object> getPermisos(
      {required String token, int pageNumber = 1, int pageSize = 12}) {
    return _http.request(
      '/api/permisos/get?PageSize=$pageSize&PageNumber=$pageNumber',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $token',
      },
      parser: (data) {
        return PermisosResponse.fromJson(data);
      },
    );
  }

  Future<Object> createPermisos(
      {required String token,
      required int id,
      required String descripcion,
      required int idAccion,
      required int idRecurso,
      required int esBasico}) {
    return _http.request(
      '/api/permisos/create',
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
        return PermisosResponse.fromJson(data);
      },
    );
  }

  Future<Object> updatePermisos(
      {required String token,
      required int id,
      required String descripcion,
      required int idAccion,
      required int idRecurso,
      required int esBasico}) {
    return _http.request(
      '/api/permisos/update',
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
        return PermisosResponse.fromJson(data);
      },
    );
  }

  Future<Object> deletePermisos({required String token, required int id}) {
    return _http.request(
      '/api/permisos/delete/?id=$id',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $token',
      },
      parser: (data) {
        return PermisosResponse.fromJson(data);
      },
    );
  }
}
