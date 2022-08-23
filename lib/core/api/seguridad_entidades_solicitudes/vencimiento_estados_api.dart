import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/vencimiento_estados_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class VencimientoEstadosApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  VencimientoEstadosApi(this._http, this._authenticationClient);

  Future<Object> getVencimientoEstados(
      {int pageSize = 900,
      int pageNumber = 1,
      int? estadoId,
      String estadoDescripcion = "",
      int? id,
      int? periodo}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/vencimientoestados/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "Id": id,
          "EstadoId": estadoId,
          "EstadoDescripcion": estadoDescripcion,
          "Periodo": periodo,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return VencimientoEstadosResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateVencimientoEstados({
    required int id,
    required int periodo,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/vencimientoestados/update',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"id": id, "periodo": periodo},
        parser: (data) {
          return VencimientoEstadosPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
