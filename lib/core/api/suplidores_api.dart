import 'package:tasaciones_app/core/api/http.dart';

import '../authentication_client.dart';
import '../models/seguridad_entidades_generales/suplidores_response.dart';
import 'api_status.dart';

class SuplidoresAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  SuplidoresAPI(this._http, this._authenticationClient);

  Future<Object> getSuplidores() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
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
    } else {
      return TokenFail();
    }
  }
}
