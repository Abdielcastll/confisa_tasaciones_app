import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/periodo_eliminacion_data_grafica_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/periodo_tasacion_promedio_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class PeriodoTasacionPromedioApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  PeriodoTasacionPromedioApi(this._http, this._authenticationClient);

  Future<Object> getPeriodoTasacionPromedio({
    int pageSize = 900,
    int pageNumber = 1,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/periodo-tasacion-promedio/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return PeriodoTasacionPromedioResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getOpcionesPeriodoTasacionPromedio({
    int pageSize = 900,
    int pageNumber = 1,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/periodo-tasacion-promedio/get-opciones',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return OpcionesPeriodoTasacionPromedioResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updatePeriodoTasacionPromedio({
    required int id,
    required String descripcion,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/periodo-tasacion-promedio/update',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {"id": id, "descripcion": descripcion},
        parser: (data) {
          return PeriodoTasacionPromedioPOSTResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
