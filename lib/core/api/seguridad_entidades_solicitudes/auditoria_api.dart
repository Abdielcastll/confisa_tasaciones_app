import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/auditoria_response.dart';

import '../../authentication_client.dart';
import '../http.dart';

class AuditoriaApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AuditoriaApi(this._http, this._authenticationClient);

  Future<Object> getAuditoria({
    int pageSize = 999,
    int pageNumber = 1,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/auditlogs/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return AuditoriaResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
