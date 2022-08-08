import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/componentes_vehiculo_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class ComponentesVehiculoApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  ComponentesVehiculoApi(this._http, this._authenticationClient);

  Future<Object> getComponentesVehiculo({
    int pageNumber = 1,
    int? id,
    int? idSegmento,
    int pageSize = 900,
    String descripcion = '',
  }) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/componentes-vehiculo/get',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        "Descripcion": descripcion,
        "Id": id,
        "IdSegmento": idSegmento,
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return ComponentesVehiculoResponse.fromJson(data);
      },
    );
  }

  Future<Object> createComponentesVehiculo(
      {required String descripcion, required int idSegmento}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/componentes-vehiculo/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"descripcion": descripcion, "idSegmento": idSegmento},
      parser: (data) {
        return ComponentesVehiculoPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> updateComponentesVehiculo(
      {required String descripcion,
      required int id,
      required int idSegmento}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/componentes-vehiculo/update',
      method: "PUT",
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"id": id, "descripcion": descripcion, "idSegmento": idSegmento},
      parser: (data) {
        return ComponentesVehiculoPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> deleteComponentesVehiculo({required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/componentes-vehiculo/delete/$id',
      method: "DELETE",
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return ComponentesVehiculoPOSTResponse.fromJson(data);
      },
    );
  }
}