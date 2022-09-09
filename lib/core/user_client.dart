import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasaciones_app/core/api/usuarios_api.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';

class UserClient {
  SharedPreferences _storage;
  final UsuariosAPI _usuariosApi;

  UserClient(this._storage, this._usuariosApi);

  Future<void> initPrefs() async {
    _storage = await SharedPreferences.getInstance();
  }

  Profile get loadProfile {
    final data = _storage.getString('USUARIO') ?? '';
    final profile = Profile.fromJson(jsonDecode(data));
    return profile;
  }

  void saveProfile(Profile perfil) {
    final data = jsonEncode(perfil.toJson());
    _storage.setString('USUARIO', data);
  }

  Future<void> signOut() async {
    await _storage.clear();
  }
}
