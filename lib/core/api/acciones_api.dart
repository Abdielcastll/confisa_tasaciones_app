import '../authentication_client.dart';
import '../models/acciones_response.dart';
import 'http.dart';

class AccionesApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  AccionesApi(this._http, this._authenticationClient);

  Future<Object> getAcciones({int pageNumber = 1, int pageSize = 12}) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/acciones/get',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      queryParameters: {
        // "id": "ac4ded05-a7ea-43d3-b01a-b0a8c55dae73",
        "PageSize": pageSize,
        "PageNumber": pageNumber,
      },
      parser: (data) {
        return AccionesResponse.fromJson(data);
      },
    );
  }
}
