import '../../authentication_client.dart';
import '../../models/seguridad_entidades_solicitudes/componentes_vehiculo_suplidor_response.dart';
import '../http.dart';

class ComponentesVehiculoSuplidorApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  ComponentesVehiculoSuplidorApi(this._http, this._authenticationClient);

  Future<Object> getComponentesVehiculoSuplidor(
      {int? idComponente,
      int? idSuplidor,
      int? estado,
      int pageSize = 900,
      int pageNumber = 1,
      String componenteDescripcion = "",
      int? id}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/componentes-vehiculo-suplidor/get',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        "Id": id,
        "IdComponenete": idComponente,
        "IdSuplidor": idSuplidor,
        "Estado": estado,
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return ComponentesVehiculoSuplidorResponse.fromJson(data);
      },
    );
  }

  Future<Object> createComponenteVehiculoSuplidor(
      {required int idComponente, required int idSuplidor}) async {
    String? _token = await _authenticationClient.accessToken;
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
        return ComponentesVehiculoSuplidorData.fromJson(data["data"]);
      },
    );
  }

  Future<Object> deleteComponentesVehiculoSuplidor({required int id}) async {
    String? _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/componentes-vehiculo-suplidor/delete/$id',
      method: 'DELETE',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return ComponentesVehiculoSuplidorPOSTResponse.fromJson(data);
      },
    );
  }
}
