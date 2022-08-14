import '../../authentication_client.dart';
import '../../models/seguridad_entidades_generales/adjuntos_response.dart';
import '../http.dart';

class AdjuntosApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AdjuntosApi(this._http, this._authenticationClient);

  Future<Object> getAdjuntos(
      {String descripcion = "",
      int pageSize = 900,
      int pageNumber = 1,
      int? id}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/tipos-adjuntos/get',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        "Id": id,
        "Descripcion": descripcion,
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return AdjuntosResponse.fromJson(data);
      },
    );
  }

  Future<Object> createAdjunto({required String descripcion}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/tipos-adjuntos/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "descripcion": descripcion,
      },
      parser: (data) {
        return AdjuntosData.fromJson(data["data"]);
      },
    );
  }

  Future<Object> updateAdjunto(
      {required int id, required String descripcion}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/tipos-adjuntos/update',
      method: 'PUT',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"id": id, "descripcion": descripcion},
      parser: (data) {
        return AdjuntosPOSTResponse.fromJson(data);
      },
    );
  }
}
