import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';

import 'http.dart';

class PersonalApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  PersonalApi(this._http, this._authenticationClient);

  Future<Object> getProfile() async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/personal/profile',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      parser: (data) {
        return ProfileResponse.fromJson(data);
      },
    );
  }

  Future<Object> updateProfile({
    required String id,
    required String fullName,
    required String phoneNumber,
    required String email,
  }) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/personal/profile',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      method: 'PUT',
      data: {
        "id": id,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "email": email,
      },
    );
  }

  Future<Object> changePasswordProfile({
    required String passWord,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    String _token = await _authenticationClient.accessToken;
    return _http.request(
      '/api/personal/profile',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      method: 'PUT',
      data: {
        "password": passWord,
        "newPassword": newPassword,
        "confirmNewPassword": confirmNewPassword,
      },
    );
  }
}
