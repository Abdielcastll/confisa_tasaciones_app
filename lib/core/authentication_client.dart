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

  Future<String?> get accessToken async {
    final logger = Logger();
    final data = _storage.getString('SESSION') ?? '';
    final session = Session.fromJson(jsonDecode(data));
    final currentDate = DateTime.now();
    final difference =
        session.tokenExpiryTime.difference(currentDate).inMinutes;
    logger.wtf(difference);
    if (difference >= 20) {
      return session.token;
    } else if (difference <= 0) {
      isLogged = false;
      logger.wtf('IR A LOGIN');
      return null;
    } else {
      final resp = await _authenticationAPI.refreshToken(
          token: session.token, refreshToken: session.refreshToken);
      if (resp is Success<SignInResponse>) {
        saveSession(resp.response.data);
        logger.wtf('TOKEN ACTUALIZADO: ${resp.response.data.token}');
        return resp.response.data.token;
      } else {
        isLogged = false;
        return null;
      }
    }
  }

  set isLogged(bool v) {
    _storage.setBool('isLogged', v);
  }

  bool get isLogged {
    return _storage.getBool('isLogged') ?? false;
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
