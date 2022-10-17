import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/permisos_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';

class ProfilePermisosProvider with ChangeNotifier {
  late ProfilePermisoResponse _profilePermisos;
  List<PermisosData> _permisos = [];

  ProfilePermisoResponse get profilePermisos => _profilePermisos;
  set profilePermisos(ProfilePermisoResponse value) {
    _profilePermisos = value;
    notifyListeners();
  }

  List<PermisosData> get permisos => _permisos;
  set permisos(List<PermisosData> data) {
    _permisos.addAll(data);
  }
}
