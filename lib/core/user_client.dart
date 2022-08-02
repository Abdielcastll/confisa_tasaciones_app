import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasaciones_app/core/api/usuarios_api.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';

class UserClient {
  SharedPreferences _storage;
  final UsuariosAPI _usuariosApi;

  UserClient(this._storage, this._usuariosApi);

  Future<void> initPrefs() async {
    _storage = await SharedPreferences.getInstance();
  }

  UsuariosData get loadUsuario {
    final data = _storage.getString('USUARIO') ?? '';
    final usuario = UsuariosData.fromJson(jsonDecode(data));
    return usuario;
  }

  void saveUsuario(UsuariosData usuario) {
    final data = jsonEncode(usuario.toJson());
    _storage.setString('USUARIO', data);
  }

  Future<void> signOut() async {
    await _storage.clear();
  }
}
