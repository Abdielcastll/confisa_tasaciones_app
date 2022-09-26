import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/periodo_tasacion_promedio_response.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/periodo_facturacion_automatica_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class PeriodoFacturacionAutomaticaApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  PeriodoFacturacionAutomaticaApi(this._http, this._authenticationClient);

  Future<Object> getPeriodoFacturacionAutomatica({
    int? idSuplidor,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/periodo-facturacion-automatica/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return PeriodoFacturacionAutomaticaResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updatePeriodoFacturacionAutomatica({
    required int idSuplidor,
    required String valor,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/periodo-facturacion-automatica/update',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"valor": valor, "idSuplidor": idSuplidor},
        parser: (data) {
          return PeriodoFacturacionAutomaticaPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
