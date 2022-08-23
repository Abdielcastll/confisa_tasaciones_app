import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/segmentos_componentes_vehiculos_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class SegmentosComponentesVehiculosApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  SegmentosComponentesVehiculosApi(this._http, this._authenticationClient);

  Future<Object> getSegmentosComponentesVehiculos(
      {int pageSize = 900,
      int pageNumber = 1,
      String descripcion = "",
      int? id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/segmentoscomponentesvehiculos/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "Id": id,
          "Descripcion": descripcion,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return SegmentosComponentesVehiculosResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createSegmentoComponenteVehiculo(
      {required String descripcion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/segmentoscomponentesvehiculos/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"descripcion": descripcion},
        parser: (data) {
          return SegmentosComponentesVehiculosData.fromJson(data["data"]);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateSegmentoComponenteVehiculo(
      {required String descripcion, required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/segmentoscomponentesvehiculos/update',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"descripcion": descripcion, "id": id},
        parser: (data) {
          return SegmentosComponentesVehiculosPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> deleteSegmentosComponentesVehiculos({required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/segmentoscomponentesvehiculos/delete/$id',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return SegmentosComponentesVehiculosPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
