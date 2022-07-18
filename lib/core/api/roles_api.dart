import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/roles_claims_response.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';

import '../authentication_client.dart';
import '../models/permisos_response.dart';

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

  Future<Object> createRoles(String name, String descripcion) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/roles/create',
      method: 'POST',
      data: {"name": name, "description": descripcion},
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return RolPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> updateRol(String id, String name, String descripcion) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/roles/update',
      method: 'PUT',
      data: {"id": id, "name": name, "description": descripcion},
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return RolPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> assingPermisosRol(
      String id, List<PermisosData> permisos) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/rolesclaims/assing-permisos',
      method: 'POST',
      data: {"roleId": id, "permissions": permisos},
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return RolPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> updatePermisoRol(
      String id, List<RolClaimsData> permisos) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/rolesclaims/update',
      method: 'PUT',
      data: {"roleId": id, "permissions": permisos},
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return RolPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> deletePermisosRol(
      String id, List<RolClaimsData> permisos) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/rolesclaims/delete',
      method: 'DELETE',
      data: {"roleId": id, "permisos": permisos},
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return RolPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> deleteRol(String id) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/roles/delete/$id',
      method: 'DELETE',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return RolPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> getRolesClaims({required String idRol}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/rolesclaims/get/$idRol',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return RolClaimsResponse.fromJson(data);
      },
    );
  }
}
