import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';

class RolesAPI {
  final Http _http;
  RolesAPI(this._http);

  Future<Object> getRoles({required String token}) {
    return _http.request(
      '/api/roles/get',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $token',
      },
      parser: (data) {
        return RolResponse.fromJson(data);
      },
    );
  }
}
