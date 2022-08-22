import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/accesorios_suplidor_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class AccesoriosSuplidorApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AccesoriosSuplidorApi(this._http, this._authenticationClient);

  Future<Object> getAccesoriosSuplidor(
      {int pageSize = 900,
      int pageNumber = 1,
      String accesorioDescripcion = "",
      String suplidorNombre = "",
      int? idSuplidor,
      int? id,
      int? idAccesorio}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/accesoriossuplidor/get',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        "Id": id,
        "IdAccesorio": idAccesorio,
        "IdSuplidor": idSuplidor,
        "SuplidorNombre": suplidorNombre,
        "AccesorioDescripcion": accesorioDescripcion,
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return AccesoriosSuplidorResponse.fromJson(data);
      },
    );
  }

  /* Future<Object> updateAccesoriosSuplidor(
      {required int id,
      required String descripcion,
      required int idSegmento}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/accesoriosSuplidor/update',
      method: 'PUT',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"id": id, "descripcion": descripcion, "idSegmento": idSegmento},
      parser: (data) {
        return AccesoriosSuplidorPOSTResponse.fromJson(data);
      },
    );
  } */

  Future<Object> createAccesoriosSuplidor(
      {required int idSuplidor, required List<int> idAccesorios}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/accesoriossuplidor/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"idSuplidor": idSuplidor, "idAccesorios": idAccesorios},
      parser: (data) {
        return AccesoriosSuplidorData.fromJson(data);
      },
    );
  }
}
