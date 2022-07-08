import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/roles_claims_response.dart';

class PermisosProvider with ChangeNotifier {
  late final List<RolClaimsData> _permisos = [];

  List<RolClaimsData> get permisos => _permisos;
  set permiso(RolClaimsData value) {
    _permisos.add(value);
    notifyListeners();
  }
}
