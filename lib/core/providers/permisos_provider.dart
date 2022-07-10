import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/permisos_response.dart';
import 'package:tasaciones_app/core/models/roles_claims_response.dart';

class PermisosUserProvider with ChangeNotifier {
  late final List<RolClaimsData> _permisosUser = [];
  late PermisosResponse _permisos;
  PermisosResponse get permisos => _permisos;
  List<RolClaimsData> get permisosUser => _permisosUser;
  set permisoUser(RolClaimsData value) {
    _permisosUser.add(value);
    notifyListeners();
  }

  set permisos(PermisosResponse value) {
    _permisos = value;
    notifyListeners();
  }
}
