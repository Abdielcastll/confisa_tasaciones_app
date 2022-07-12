import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/recursos_response.dart';

class RecursosAPI {
  final Http _http;
  RecursosAPI(this._http);

  Future<Object> getRecursos(
      {required String token,
      int pageNumber = 1,
      int pageSize = 100,
      int estado = 1}) {
    return _http.request(
      '/api/recursos/get?PageSize=$pageSize&PageNumber=$pageNumber&Estado=$estado',
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $token',
      },
      parser: (data) {
        return RecursosResponse.fromJson(data);
      },
    );
  }
}
