import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/condiciones_componentes_vehiculo_response.dart';

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
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
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
    } else {
      return TokenFail();
    }
  }

  Future<Object> getCondicionesAsociadosComponentesVehiculo(
      {int pageSize = 900,
      int pageNumber = 1,
      String condicionNombre = "",
      String componenteNombre = "",
      int? idCondicionParametroG,
      int? idComponente,
      int? estado,
      int? id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/condiciones-componentes-vehiculo/get-asociados',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "Id": id,
          "IdComponente": idComponente,
          "Estado": estado,
          "IdCondicionParametroG": idCondicionParametroG,
          "CondicionNombre": condicionNombre,
          "ComponenteNombre": componenteNombre,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return AsociadosCondicionesComponentesVehiculoResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateCondicionComponenteVehiculoSuplidor(
      {required int id, required String descripcion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/condiciones-componentes-vehiculo/update',
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
    } else {
      return TokenFail();
    }
  }

  Future<Object> createCondicionComponenteVehiculoSuplidor(
      {required String descripcion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/condiciones-componentes-vehiculo/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"descripcion": descripcion},
        parser: (data) {
          return CondicionesComponentesVehiculoResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> asociarComponenteVehiculoSuplidor(
      {required int idComponente,
      required List<int> idCondicionesComponentes}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/condiciones-componentes-vehiculo/asociar',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "idComponente": idComponente,
          "idCondicionesComponentes": idCondicionesComponentes
        },
        parser: (data) {
          return CondicionesComponentesVehiculoPOSTResponse.fromJson(
              data["data"][0]);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> deleteCondicionesComponentesVehiculo({required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
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
    } else {
      return TokenFail();
    }
  }
}
