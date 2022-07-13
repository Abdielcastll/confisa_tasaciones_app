import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/roles_claims_response.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';

import '../authentication_client.dart';

class RolesAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  RolesAPI(this._http, this._authenticationClient);

  Future<Object> getRoles() async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/roles/get',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return RolResponse.fromJson(data);
      },
    );
  }

  Future<Object> getRolesClaims(
      {required String idRol, required String token}) {
    return _http.request(
      '/api/rolesclaims/get/$idRol',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $token',
      },
      parser: (data) {
        return RolClaimsResponse.fromJson(data);
      },
    );
  }
}
