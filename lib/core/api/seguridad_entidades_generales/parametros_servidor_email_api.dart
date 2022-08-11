import 'package:tasaciones_app/core/models/seguridad_entidades_generales/parametors_servidor_email_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class ParametrosServidorEmailApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  ParametrosServidorEmailApi(this._http, this._authenticationClient);

  Future<Object> getParametrosServidorEmail(
      {String remitente = "",
      String host = "",
      String puerto = "",
      String usuario = "",
      String password = "",
      int pageSize = 900,
      int pageNumber = 1,
      int? id}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/parametros-servidor-email/get',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        "Id": id,
        "Remitente": remitente,
        "Host": host,
        "Puerto": puerto,
        "Usuario": usuario,
        "Password": password,
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return ParametrosServidorEmailResponse.fromJson(data);
      },
    );
  }

  Future<Object> createParametrosServidorEmail(
      {required String remitente,
      required String host,
      required String puerto,
      required String usuario,
      required String password}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/parametros-servidor-email/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "remitente": remitente,
        "host": host,
        "puerto": puerto,
        "usuario": usuario,
        "password": password,
      },
      parser: (data) {
        return ParametrosServidorEmailResponse.fromJson(data);
      },
    );
  }

  Future<Object> updateParametrosServidorEmail(
      {required int id,
      required String remitente,
      required String host,
      required String puerto,
      required String usuario,
      required String password}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/parametros-servidor-email/update',
      method: 'PUT',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "id": id,
        "remitente": remitente,
        "host": host,
        "puerto": puerto,
        "usuario": usuario,
        "password": password,
      },
      parser: (data) {
        return ParametrosServidorEmailPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> deleteParametrosServidorEmail({required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/parametros-servidor-email/delete/$id',
      method: 'DELETE',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return ParametrosServidorEmailPOSTResponse.fromJson(data);
      },
    );
  }
}
