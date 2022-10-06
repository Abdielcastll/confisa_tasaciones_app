import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/documentos_facturacion_response.dart';

class DocumentosFacturacionApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  DocumentosFacturacionApi(this._http, this._authenticationClient);

  Future<Object> getDocumentoFacturacion(
      {int pageNumber = 1,
      int pageSize = 999,
      String descripcion = "",
      int? id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/documentosrequeridosfacturacion/get',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "Descripcion": descripcion,
          "Id": id,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return DocumentosFacturacionResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createDocumentoFacturacion(
      {required String descripcion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/documentosrequeridosfacturacion/create',
        method: "POST",
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "descripcion": descripcion,
        },
        parser: (data) {
          return DocumentosFacturacionData.fromJson(data["data"]);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateDocumentosFacturacion(
      {required int id, required String descripcion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/documentosrequeridosfacturacion/update',
        method: "PUT",
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"id": id, "descripcion": descripcion},
        parser: (data) {
          return DocumentosFacturacionPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> deleteDocumentosFacturacion({required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/documentosrequeridosfacturacion/delete/$id',
        method: "DELETE",
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return DocumentosFacturacionPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
