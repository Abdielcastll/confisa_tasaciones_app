import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/porcentajes_honorarios_entidad_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class PorcentajesHonorariosEntidadApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  PorcentajesHonorariosEntidadApi(this._http, this._authenticationClient);

  Future<Object> getPorcentajesHonorariosEntidad(
      {String valor = "",
      int pageSize = 900,
      int pageNumber = 1,
      String codigoEntidad = "",
      String descripcionEntidad = "",
      String descripcionCatalogoParametros = "",
      int? id,
      int? idCatalogoParametro}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
    } else {
      return TokenFail();
    }
    return _http.request(
      '/api/porcentajes-honorarios-entidad/get',
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
        return PorcentajesHonorariosEntidadResponse.fromJson(data);
      },
    );
  }

  Future<Object> createOrUpdatePorcentajesHonorariosEntidad(
      {required String codigoEntidad, required String valor}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/porcentajes-honorarios-entidad/create-or-update',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "valor": valor,
          "codigoEntidad": codigoEntidad,
        },
        parser: (data) {
          return PorcentajesHonorariosEntidadPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
