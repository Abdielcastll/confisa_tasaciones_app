import 'package:tasaciones_app/core/api/http.dart';

class AuthenticationAPI {
  final Http _http;
  AuthenticationAPI(this._http);

  Future<Object> signIn({
    required String email,
    required String password,
  }) {
    return _http.request(
      '/api/tokens',
      method: 'POST',
      data: {
        "email": email,
        "password": password,
      },
    );
  }
}
