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
  }

  /*  Future<Object> createComponenteVehiculo(
      {required int idComponente, required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/componentes-vehiculo/create',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      data: {
        "idComponente": idComponente,
        "id": id,
      },
      parser: (data) {
        return SegmentosAccesoriosVehiculosData.fromJson(data["data"]);
      },
    );
  } */

  /* Future<Object> deleteSegmentosAccesoriosVehiculos({required int id}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/componentes-vehiculo-/delete/$id',
      method: 'DELETE',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return SegmentosAccesoriosVehiculosPOSTResponse.fromJson(data);
      },
    );
  } */
}
