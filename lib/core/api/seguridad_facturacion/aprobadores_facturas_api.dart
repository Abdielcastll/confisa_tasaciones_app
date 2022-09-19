import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/tarifario_tasacion_response.dart';

class AprobadoresFacturasApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AprobadoresFacturasApi(this._http, this._authenticationClient);

  Future<Object> getTarifariosTasacion({
    int pageNumber = 1,
    int pageSize = 999,
    int? tipoTasacion,
    int? idSuplidor,
    String valor = "",
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/tarifarios-servicios-tasacion/get',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "TipoTasacion": tipoTasacion,
          "IdSuplidor": idSuplidor,
          "Valor": valor,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        /* parser: (data) {
          return AprobadoresFacturasResponse.fromJson(data);
        }, */
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateAprobadoresFacturas(
      {required String valor,
      required int idSuplidor,
      required int idTipoTasacion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/tarifarios-servicios-tasacion/update',
        method: "PUT",
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "valor": valor,
          "idSuplidor": idSuplidor,
          "idTipoTasacion": idTipoTasacion
        },
        /* parser: (data) {
          return AprobadoresFacturasPOSTResponse.fromJson(data);
        }, */
      );
    } else {
      return TokenFail();
    }
  }
}
