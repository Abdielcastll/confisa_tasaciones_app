import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tasaciones_app/core/base/base_view_model.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/change_buttons.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/tables/table_permisos_widget.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/tables/table_roles_widget.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/tables/table_usuarios_widget.dart';

// import '../../core/api/acciones_api.dart';
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

  late Function buttonAdd;

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

  Future<void> onDropDownChangeButtons(
      String opcion, BuildContext context) async {
    button1 = SizedBox();
    Size size = MediaQuery.of(context).size;
    switch (opcion) {
      case "Permisos":
        button1 = await ChangeButtons(context: context, size: size)
            .addButtonPermisos();
        break;
      case "Roles":
        button1 =
            await ChangeButtons(context: context, size: size).addButtonRol();
        break;
      default:
    }
    notifyListeners();
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
      case "Roles":
        dataTable = PaginatedTableRoles(context: context).table();
        break;
      default:
    }
    notifyListeners();
  }

  void onInit() {
    user = _authenticationClient.loadSession;
  }
}
