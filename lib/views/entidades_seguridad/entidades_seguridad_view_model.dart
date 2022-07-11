import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tasaciones_app/core/base/base_view_model.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/app_circle_icon_button.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/table_permisos_widget.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/table_usuarios_widget.dart';

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

  late Function buttonAdd = () {};

  Widget dataTable = Container();

  late Widget button1 = Container();

  late Widget button2 = Container();

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

  void onDropDownChangeButtons(String opcion, BuildContext context) {
    switch (opcion) {
      case "Permisos":
        button1 = CircleIconButton(
            color: AppColors.green,
            icon: Icons.add,
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: Text("Hola"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ));
                }));
        break;
      case "Usuarios":
        break;
      default:
    }
  }

  void onDropDownChangeTable(String opcion, BuildContext context) {
    dataTable = Container();
    switch (opcion) {
      case "Permisos":
        dataTable = PaginatedTablePermisos(context: context).table();
        break;
      case "Usuarios":
        dataTable = PaginatedTableUsuarios(context: context).table();
        break;
      default:
    }
    notifyListeners();
  }

  void onInit() {
    user = _authenticationClient.loadSession;
  }
}
