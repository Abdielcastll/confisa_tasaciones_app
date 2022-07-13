import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/autentication_api.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';

class AuthenticationClient {
  SharedPreferences _storage;
  final AuthenticationAPI _authenticationAPI;

  AuthenticationClient(this._storage, this._authenticationAPI);

  Future<void> initPrefs() async {
    _storage = await SharedPreferences.getInstance();
  }

  Future<String> get accessToken async {
    final logger = Logger();
    final data = _storage.getString('SESSION') ?? '';
    final session = Session.fromJson(jsonDecode(data));
    final currentDate = DateTime.now();
    final difference =
        session.refreshTokenExpiryTime.difference(currentDate).inMinutes;
    logger.wtf(difference);
    if (difference >= 15) {
      return session.token;
    }
    final resp = await _authenticationAPI.refreshToken(
        token: session.token, refreshToken: session.refreshToken);
    if (resp is Success<SignInResponse>) {
      saveSession(resp.response.data);
      logger.wtf('TOKEN ACTUALIZADO');
      return resp.response.data.token;
    }
    return '';
  }

  Session get loadSession {
    final data = _storage.getString('SESSION') ?? '';
    final session = Session.fromJson(jsonDecode(data));
    return session;
  }

  void saveSession(Session session) {
    final data = jsonEncode(session.toJson());
    _storage.setString('SESSION', data);
  }

  Future<void> signOut() async {
    await _storage.clear();
  }
}