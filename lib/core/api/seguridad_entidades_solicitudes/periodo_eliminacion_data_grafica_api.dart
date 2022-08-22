import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/periodo_eliminacion_data_grafica_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class PeriodoEliminacionDataGraficaApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  PeriodoEliminacionDataGraficaApi(this._http, this._authenticationClient);

  Future<Object> getPeriodoEliminacionDataGraficaVencida({
    int pageSize = 900,
    int pageNumber = 1,
    String descripcion = "",
    int? id,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/periodoeliminaciondatagrafica/get-vencida',
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
        return PeriodoEliminacionDataGraficaResponse.fromJson(data);
      },
    );
  }

  Future<Object> updatePeriodoEliminacionDataGraficaVencida({
    required int id,
    required String descripcion,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/periodoeliminaciondatagrafica/update-vencida',
      method: 'PUT',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"id": id, "descripcion": descripcion},
      parser: (data) {
        return PeriodoEliminacionDataGraficaPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> getPeriodoEliminacionDataGraficaValorada({
    int pageSize = 900,
    int pageNumber = 1,
    String descripcion = "",
    int? id,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/periodoeliminaciondatagrafica/get-valorada',
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
        return PeriodoEliminacionDataGraficaResponse.fromJson(data);
      },
    );
  }

  Future<Object> updatePeriodoEliminacionDataGraficaValorada({
    required int id,
    required String descripcion,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/periodoeliminaciondatagrafica/update-valorada',
      method: 'PUT',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"id": id, "descripcion": descripcion},
      parser: (data) {
        return PeriodoEliminacionDataGraficaPOSTResponse.fromJson(data);
      },
    );
  }

  Future<Object> getPeriodoEliminacionDataGraficaRechazada({
    int pageSize = 900,
    int pageNumber = 1,
    String descripcion = "",
    int? id,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/periodoeliminaciondatagrafica/get-rechazada',
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
        return PeriodoEliminacionDataGraficaResponse.fromJson(data);
      },
    );
  }

  Future<Object> updatePeriodoEliminacionDataGraficaRechazada({
    required int id,
    required String descripcion,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/periodoeliminaciondatagrafica/update-rechazada',
      method: 'PUT',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {"id": id, "descripcion": descripcion},
      parser: (data) {
        return PeriodoEliminacionDataGraficaPOSTResponse.fromJson(data);
      },
    );
  }
}
