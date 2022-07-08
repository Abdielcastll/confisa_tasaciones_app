import 'dart:developer';

import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';

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
      parser: (data) {
        return SignInResponse.fromJson(data);
      },
    );
  }

  Future<Object> refreshToken({
    required String token,
    required String refreshToken,
  }) {
    return _http.request(
      '/api/tokens/refresh',
      method: 'POST',
      data: {
        "token": token,
        "refreshToken": refreshToken,
      },
      parser: (data) {
        return SignInResponse.fromJson(data);
      },
    );
  }
}
