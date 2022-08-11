import 'package:tasaciones_app/core/models/seguridad_entidades_generales/suplidores_default_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class SuplidoresDefaultApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  SuplidoresDefaultApi(this._http, this._authenticationClient);

  Future<Object> getSuplidoresDefault(
      {String valor = "",
      int pageSize = 900,
      int pageNumber = 1,
      int? codigoEntidad,
      int? id,
      int? idCatalogoParametro}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/suplidor-default/get',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        "Id": id,
        "CodigoEntidad": codigoEntidad,
        "IdCatalogoParametros": idCatalogoParametro,
        "Valor": valor,
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return SuplidoresDefaultResponse.fromJson(data);
      },
    );
  }

  Future<Object> createOrUpdateSuplidoresDefault(
      {required String codigoEntidad, required String valor}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/suplidor-default/create-or-update',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "valor": valor,
        "codigoEntidad": codigoEntidad,
      },
      parser: (data) {
        return SuplidoresDefaultPOSTResponse.fromJson(data);
      },
    );
  }
}
