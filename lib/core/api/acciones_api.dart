import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/acciones_response.dart';

import '../authentication_client.dart';

class AccionesAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AccionesAPI(this._http, this._authenticationClient);

  Future<Object> getAcciones(
      {int pageNumber = 1, int pageSize = 100, int estado = 1}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/acciones/get?PageSize=$pageSize&PageNumber=$pageNumber&Estado=$estado',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return AccionesResponse.fromJson(data);
      },
    );
  }
}
