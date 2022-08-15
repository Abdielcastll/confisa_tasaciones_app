import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/models/notas_response.dart';

class NotasApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  NotasApi(this._http, this._authenticationClient);

  Future<Object> getNotas(
      {String descripcion = "",
      bool? enviado,
      String correo = "",
      String titulo = "",
      String fechaCompromiso = "",
      String usuario = "",
      String fechaHora = "",
      int? idSolicitud,
      int pageSize = 900,
      int pageNumber = 1,
      int? id}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/notassolicitud/get',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        "Id": id,
        "IdSolicitud": idSolicitud,
        "FechaHora": fechaHora,
        "Usuario": usuario,
        "FechaCompromiso": fechaCompromiso,
        "Titulo": titulo,
        "Correo": correo,
        "Enviado": enviado,
        "Descripcion": descripcion,
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return NotasResponse.fromJson(data);
      },
    );
  }

  Future<Object> createNota({
    required int idSolicitud,
    required String descripcion,
    required String titulo,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/notassolicitud/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "idSolicitud": idSolicitud,
        "descripcion": descripcion,
        "titulo": titulo,
      },
      parser: (data) {
        return NotasData.fromJson(data["data"]);
      },
    );
  }

  Future<Object> updateNota({
    required int id,
    required String descripcion,
    required String titulo,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/notassolicitud/update',
      method: 'PUT',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "id": id,
        "descripcion": descripcion,
        "titulo": titulo,
      },
      parser: (data) {
        return NotasPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> deleteNota({
    required int id,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/notassolicitud/delete/$id',
      method: 'DELETE',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return NotasPOSTResponse.fromJson(data);
      },
    );
  }
}
