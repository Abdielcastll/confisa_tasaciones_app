import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/base/base_view_model.dart';
import 'package:tasaciones_app/core/models/acciones_response.dart';
import 'package:tasaciones_app/core/models/recursos_response.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/formCrearPermiso.dart';
import 'package:tasaciones_app/widgets/app_circle_icon_button.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/table_permisos_widget.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/table_usuarios_widget.dart';

import '../../core/api/acciones_api.dart';
import '../../core/api/recursos_api.dart';
import '../../core/authentication_client.dart';
import '../../core/locator.dart';
import '../../core/models/permisos_response.dart';
import '../../core/models/sign_in_response.dart';
import '../../widgets/app_dialogs.dart';

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

  final _accionesApi = locator<AccionesAPI>();
  final _recursosApi = locator<RecursosAPI>();

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

  Future<void> onDropDownChangeButtons(
      String opcion, BuildContext context) async {
    switch (opcion) {
      case "Permisos":
        String firstName = "";
        String lastName = "";
        String bodyTemp = "";
        var measure;
        ProgressDialog.show(context);
        var resp = await _accionesApi.getAcciones(token: user.token);
        if (resp is Success<AccionesResponse>) {
          var resp2 = await _recursosApi.getRecursos(token: user.token);
          if (resp2 is Success<RecursosResponse>) {
            ProgressDialog.dissmiss(context);
            final GlobalKey<FormState> _formKey = GlobalKey();
            button1 = CircleIconButton(
                color: AppColors.green,
                icon: Icons.add,
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          clipBehavior: Clip.none,
                          content: formCrearPermiso(
                              _formKey,
                              firstName,
                              lastName,
                              bodyTemp,
                              measure,
                              () {},
                              resp.response.data,
                              resp2.response.data),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ));
                    }));
            notifyListeners();
          } else if (resp2 is Failure) {
            ProgressDialog.dissmiss(context);
            Dialogs.alert(
              context,
              tittle: 'Error',
              description: resp2.messages,
            );
            onDropDownChangeButtons("", context);
          }
        } else if (resp is Failure) {
          ProgressDialog.dissmiss(context);
          Dialogs.alert(
            context,
            tittle: 'Error',
            description: resp.messages,
          );
          onDropDownChangeButtons("", context);
        }

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
