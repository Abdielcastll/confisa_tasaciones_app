import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/sucursales_response.dart';

import '../authentication_client.dart';
import 'api_status.dart';

class SucursalesApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  SucursalesApi(this._http, this._authenticationClient);

  Future<Object> getSucursales(
      {String codigoEntidad = "",
      String codigoSucursal = "",
      String nombre = "",
      int pageSize = 999,
      int pageNumber = 1}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/sucursales/get',
        method: 'GET',
        queryParameters: {
          "CodigoEntidad": codigoEntidad,
          "CodigoSucursal": codigoSucursal,
          "Nombre": nombre,
          "PageSize": pageSize,
          "PageNumber": pageNumber
        },
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return SucursalesResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
