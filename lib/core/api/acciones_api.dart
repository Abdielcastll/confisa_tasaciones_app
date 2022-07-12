import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/acciones_response.dart';

class AccionesAPI {
  final Http _http;
  AccionesAPI(this._http);

  Future<Object> getAcciones(
      {required String token,
      int pageNumber = 1,
      int pageSize = 100,
      int estado = 1}) {
    return _http.request(
      '/api/acciones/get?PageSize=$pageSize&PageNumber=$pageNumber&Estado=$estado',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $token',
      },
      parser: (data) {
        return AccionesResponse.fromJson(data);
      },
    );
  }
}
