import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/corte_facturacion_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class CorteFacturacionApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  CorteFacturacionApi(this._http, this._authenticationClient);

  Future<Object> getCorteFacturacion(
      {int? idSuplidor,
      int? tipoTasacion,
      String valor = "",
      int pageSize = 999,
      int pageNumber = 1}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/dia-corte-facturacion/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "IdSuplidor": idSuplidor,
          "TipoTasacion": tipoTasacion,
          "Valor": valor,
          "PageSize": pageSize,
          "PageNumber": pageNumber
        },
        parser: (data) {
          return CorteFacturacionResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateCorteFacturacion(
      {required int idSuplidor,
      required String valor,
      required int idTipoTasacion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/dia-corte-facturacion/update',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "valor": valor,
          "idSuplidor": idSuplidor,
          "idTipoTasacion": idTipoTasacion
        },
        parser: (data) {
          return CorteFacturacionPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
