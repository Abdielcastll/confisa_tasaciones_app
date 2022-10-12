import 'dart:convert';

import 'package:tasaciones_app/core/models/facturacion/factura_response.dart';

import '../../authentication_client.dart';
import '../../models/facturacion/detalle_aprobacion_factura.dart';
import '../../models/facturacion/detalle_factura.dart';
import '../api_status.dart';
import '../http.dart';

class FacturacionApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  FacturacionApi(this._http, this._authenticationClient);

  Future<Object> getFacturas({
    int? noFactura,
    int pageNumber = 1,
    int pageSize = 20,
    int? idSuplidor,
  }) async {
    final params = {
      "NoFactura": noFactura,
      "PageNumber": pageNumber,
      "PageSize": pageSize,
      "IdSuplidor": idSuplidor,
    };
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/facturaciontasacion/get-facturas',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: params,
        parser: (data) {
          return facturaFromJson(jsonEncode(data['data']));
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getDetalleAprobacionFactura({required int idFactura}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/facturaciontasacion/get-detalle-aprobacion-factura/$idFactura',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return detalleAprobacionFacturaFromJson(jsonEncode(data['data']));
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getDetalleFactura({required int noFactura}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/facturaciontasacion/get-detalle-factura/$noFactura',
        method: 'GET',
        headers: {'Authorization': 'Bearer $_token'},
        parser: (data) {
          return detalleFacturaFromJson(jsonEncode(data['data']));
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateNCF({
    required int noFactura,
    required String ncf,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/facturaciontasacion/update-ncf/$noFactura/$ncf',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> aprobar({
    required int noFactura,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/facturaciontasacion/aprobar_factura/$noFactura',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> rechazar({
    required int noFactura,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/facturaciontasacion/rechazar_factura/$noFactura',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
    } else {
      return TokenFail();
    }
  }
}
