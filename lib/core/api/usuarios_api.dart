import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';

import '../authentication_client.dart';
import '../models/roles_response.dart';
import 'api_status.dart';

class UsuariosAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  UsuariosAPI(this._http, this._authenticationClient);

  Future<Object> getUsuarios(
      {int pageNumber = 1,
      int pageSize = 100,
      String email = "",
      String nombreCompleto = ""}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/users/get?PageSize=$pageSize&PageNumber=$pageNumber&Email=$email',
        method: 'GET',
        queryParameters: {
          "NombreCompleto": nombreCompleto,
        },
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return UsuariosResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getUsuario({required String id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
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
    } else {
      return TokenFail();
    }
  }

  Future<Object> getUsuarioDomain({required String email}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/usersdomain/get/$email',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return UsuarioDomainData.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getRolUsuario({required String id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
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
    } else {
      return TokenFail();
    }
  }

  Future<Object> createUsuarios(
      {required String fullName,
      required String email,
      required String roleId,
      required String phoneNumber,
      int? noTasador,
      int codigoSuplidor = 0}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/users/create',
        method: 'POST',
        data: {
          "fullName": fullName,
          "email": email,
          "roleId": roleId,
          "codigoSuplidor": codigoSuplidor,
          "phoneNumber": phoneNumber,
          "noTasador": noTasador,
        },
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return UsuarioPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateUsuarios(
      {required String id,
      required String fullName,
      required String phoneNumber,
      required String email,
      int? noTasador}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/users/update',
        method: 'PUT',
        data: {
          "id": id,
          "fullName": fullName,
          "phoneNumber": phoneNumber,
          "email": email,
          "noTasador": noTasador,
        },
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return UsuarioPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateStatusUsuario(
      {required String id, required bool status}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/users/change-status',
        method: 'POST',
        data: {
          "activateUser": status,
          "userId": id,
        },
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return UsuarioPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateRolUsuario(
      {required String id, required List<RolData2> roles}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/users/update/$id/roles',
        method: 'PUT',
        data: {"userRoles": roles},
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return UsuarioPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> deleteUsuarios({required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
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
    } else {
      return TokenFail();
    }
  }
}
