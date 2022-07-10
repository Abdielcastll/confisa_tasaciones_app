import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:tasaciones_app/core/base/base_view_model.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/table_permisos_widget.dart';

import '../../core/authentication_client.dart';
import '../../core/locator.dart';
import '../../core/models/permisos_response.dart';
import '../../core/models/sign_in_response.dart';

class EntidadesSeguridadViewModel extends BaseViewModel {
  List<String> items = [
    'Acciones',
    'Módulos',
    'Recursos',
    'Permisos',
    'Usuarios',
    'Roles',
    'Endpoints',
  ];

  final _authenticationClient = locator<AuthenticationClient>();

  late Session _user;

  final logger = Logger();

  late PermisosResponse _permisos;

  late List<PermisosData> _dataPermisos = [];

  Widget dataTable = Container();

  String _dropdownvalue = 'Acciones';

  List<PermisosData> get dataPermisos => _dataPermisos;

  String get dropdownvalue => _dropdownvalue;

  PermisosResponse get permisos => _permisos;

  Session get user => _user;

  set permisos(PermisosResponse data) {
    _permisos = data;
    _dataPermisos = data.data;
    notifyListeners();
  }

  set user(Session value) {
    _user = value;
    notifyListeners();
  }

  set dropdownvalue(String newValue) {
    _dropdownvalue = newValue;
    notifyListeners();
  }

  void onDropDownChange(String opcion) {
    dataTable = Container();
    switch (opcion) {
      case "Permisos":
        dataTable = PaginatedTablePermisos(source: TablePermisos(pageSize: 12));
        break;
      default:
    }
    notifyListeners();
  }

  void onInit() {
    user = _authenticationClient.loadSession;
  }
}
