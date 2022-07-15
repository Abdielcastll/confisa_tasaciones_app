import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tasaciones_app/core/base/base_view_model.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/change_buttons.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/table_acciones_widget.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/table_permisos_widget.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/table_recursos_widget.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/table_usuarios_widget.dart';

// import '../../core/api/acciones_api.dart';
import '../../core/authentication_client.dart';
import '../../core/locator.dart';
import '../../core/models/permisos_response.dart';
import '../../core/models/sign_in_response.dart';

class EntidadesSeguridadViewModel extends BaseViewModel {
  List<String> items = [];

  final _authenticationClient = locator<AuthenticationClient>();

  late Session _user;

  final logger = Logger();

  late PermisosResponse _permisos;

  late List<PermisosData> _dataPermisos = [];

  late Function buttonAdd;

  Widget dataTable = Container();

  late Widget button1 = Container();

  late Widget button2 = Container();

  String? _dropdownvalue;
  String get dropdownvalue => _dropdownvalue ?? items.first;

  List<PermisosData> get dataPermisos => _dataPermisos;

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

  void onInit(BuildContext context) {
    user = _authenticationClient.loadSession;
    initMenu();
    initTable(context);
  }

  void initMenu() {
    if (user.role.contains('Administrador')) {
      items.addAll([
        'Acciones',
        'Módulos',
        'Recursos',
        'Permisos',
        'Usuarios',
        'Roles',
        'Endpoints',
      ]);
    }
    if (user.role.contains('Aprobador Tasaciones')) {
      items.addAll([
        'Usuarios',
      ]);
    }
  }

  void initTable(BuildContext context) async {
    onDropDownChangeTable(items.first, context);
    onDropDownChangeButtons(items.first, context);
  }

  Future<void> onDropDownChangeButtons(
      String opcion, BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    button1 = const SizedBox();
    switch (opcion) {
      case "Acciones":
        button1 = await ChangeButtons(context: context, size: size)
            .addButtonAcciones();
        break;
      case "Recursos":
        button1 = await ChangeButtons(context: context, size: size)
            .addButtonRecursos();
        break;
      case "Permisos":
        button1 = await ChangeButtons(context: context, size: size)
            .addButtonPermisos();
        break;
      case "Usuarios":
        break;
      default:
    }
    notifyListeners();
  }

  void onDropDownChangeTable(String opcion, BuildContext context) {
    dataTable = const SizedBox();
    switch (opcion) {
      case "Acciones":
        dataTable = PaginatedTableAcciones(context: context).table();
        break;
      case "Recursos":
        dataTable = PaginatedTableRecursos(context: context).table();
        break;
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
}
