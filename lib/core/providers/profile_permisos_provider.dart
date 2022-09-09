import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';

class ProfilePermisosProvider with ChangeNotifier {
  late ProfilePermisoResponse _profilePermisos =
      ProfilePermisoResponse(data: []);
  ProfilePermisoResponse get profilePermisos => _profilePermisos;
  set profilePermisos(ProfilePermisoResponse value) {
    _profilePermisos = value;
    notifyListeners();
  }
}
