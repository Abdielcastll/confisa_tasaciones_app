import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/recursos_response.dart';

import '../authentication_client.dart';

class RecursosAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  RecursosAPI(this._http, this._authenticationClient);

  Future<Object> getRecursos(
      {int pageNumber = 1, int pageSize = 100, int estado = 1}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/recursos/get?PageSize=$pageSize&PageNumber=$pageNumber&Estado=$estado',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return RecursosResponse.fromJson(data);
      },
    );
  }
}
