import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/recursos_response.dart';
import 'package:tasaciones_app/core/models/suplidores_response.dart';

import '../authentication_client.dart';

class SuplidoresAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  SuplidoresAPI(this._http, this._authenticationClient);

  Future<Object> getSuplidores() async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/suplidores/get',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return SuplidoresResponse.fromJson(data);
      },
    );
  }
}