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
}
