import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/montos_factura_minima_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class MontosFacturaMinimaApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  MontosFacturaMinimaApi(this._http, this._authenticationClient);

  Future<Object> getMontosFacturaMinima(
      {int? idSuplidor,
      String codigoEntidad = "",
      String codigoSucursal = "",
      int? idCatalogoParametro,
      int? idTipoTasacion,
      String valor = "",
      int pageSize = 999,
      int pageNumber = 1}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/monto-factura-minima-sucursal/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "IdSuplidor": idSuplidor,
          "CodigoEntidad": codigoEntidad,
          "CodigoSucursal": codigoSucursal,
          "IdTipoTasacion": idTipoTasacion,
          "Valor": valor,
          "PageSize": pageSize,
          "PageNumber": pageNumber
        },
        parser: (data) {
          return MontosFacturaMinimaResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateMontosFacturaMinima({
    required String codigoEntidad,
    required String codigoSucursal,
    required String valor,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/monto-factura-minima-sucursal/update',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "valor": valor,
          "codigoEntidad": codigoEntidad,
          "codigoSucursal": codigoSucursal
        },
        parser: (data) {
          return MontosFacturaMinimaPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> deleteMontosFacturaMinima({required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/monto-factura-minima-sucursal/delete/$id',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return MontosFacturaMinimaPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}