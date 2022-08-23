import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/segmentos_accesorios_vehiculos_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class SegmentosAccesoriosVehiculosApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  SegmentosAccesoriosVehiculosApi(this._http, this._authenticationClient);

  Future<Object> getSegmentosAccesoriosVehiculos(
      {int pageSize = 900,
      int pageNumber = 1,
      String descripcion = "",
      int? id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/segmentosaccesoriosvehiculos/get',
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
          return SegmentosAccesoriosVehiculosResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createSegmentoAccesorioVehiculo(
      {required String descripcion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/segmentosaccesoriosvehiculos/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"descripcion": descripcion},
        parser: (data) {
          return SegmentosAccesoriosVehiculosData.fromJson(data["data"]);
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
        '/api/segmentosaccesoriosvehiculos/update',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"descripcion": descripcion, "id": id},
        parser: (data) {
          return SegmentosAccesoriosVehiculosPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> deleteSegmentoAccesorioVehiculo({required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/segmentosaccesoriosvehiculos/delete/$id',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return SegmentosAccesoriosVehiculosPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
