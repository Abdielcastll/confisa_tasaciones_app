import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/condiciones_componentes_vehiculo.dart';

import '../../authentication_client.dart';
import '../http.dart';

class CondicionesComponentesVehiculoApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  CondicionesComponentesVehiculoApi(this._http, this._authenticationClient);

  Future<Object> getCondicionesComponentesVehiculo(
      {int pageSize = 900,
      int pageNumber = 1,
      String descripcion = "",
      int? id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/condiciones-componentes-vehiculo/get',
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
        return CondicionesComponentesVehiculoResponse.fromJson(data);
      },
    );
  }

  Future<Object> updateComponenteVehiculoSuplidor(
      {required int id, required String descripcion}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/condiciones-componentes-vehiculo/create',
      method: 'PUT',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "id": id,
        "descripcion": descripcion,
      },
      parser: (data) {
        return CondicionesComponentesVehiculoPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> createComponenteVehiculoSuplidor(
      {required String descripcion}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/condiciones-componentes-vehiculo/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"descripcion": descripcion},
      parser: (data) {
        return CondicionesComponentesVehiculoPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> deleteCondicionesComponentesVehiculo({required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/condiciones-componentes-vehiculo/delete/$id',
      method: 'DELETE',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return CondicionesComponentesVehiculoPOSTResponse.fromJson(data);
      },
    );
  }
}
