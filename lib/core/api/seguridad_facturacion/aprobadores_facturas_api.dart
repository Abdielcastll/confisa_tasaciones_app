import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/aprobadores_facturas_response.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/tarifario_tasacion_response.dart';

class AprobadoresFacturasApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AprobadoresFacturasApi(this._http, this._authenticationClient);

  Future<Object> getTarifariosTasacion({
    int pageNumber = 1,
    int pageSize = 999,
    String email = "",
    String nombreCompleto = "",
    bool? activo,
    bool? estadoAprobadorFactura,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/aprobadores-facturas-tasacion/get',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "Email": email,
          "NombreCompleto": nombreCompleto,
          "Activo": activo,
          "EstadoAprobadorFactura": estadoAprobadorFactura,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return AprobadoresFacturasResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateEstadoAprobadoresFacturas(
      {required String userId, required bool activateUser}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/aprobadores-facturas-tasacion/change-status',
        method: "POST",
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"activateUser": activateUser, "userId": userId},
        parser: (data) {
          return AprobadoresFacturasPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
