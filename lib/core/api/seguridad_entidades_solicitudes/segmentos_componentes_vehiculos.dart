import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/segmentos_componentes_vehiculos.dart';

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
    String _token = await _authenticationClient.accessToken;
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
  }

  Future<Object> createComponenteVehiculoSuplidor(
      {required int idComponente, required int idSuplidor}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/componentes-vehiculo-suplidor/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "idComponente": idComponente,
        "idSuplidor": idSuplidor,
      },
      parser: (data) {
        return SegmentosComponentesVehiculosData.fromJson(data["data"]);
      },
    );
  }

  Future<Object> deleteSegmentosComponentesVehiculos({required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/componentes-vehiculo-suplidor/delete/$id',
      method: 'DELETE',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return SegmentosComponentesVehiculosPOSTResponse.fromJson(data);
      },
    );
  }
}
