import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/auditoria_api.dart';
import 'package:tasaciones_app/core/api/usuarios_api.dart';
import 'package:tasaciones_app/core/models/auditoria_response.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class AuditoriaViewModel extends BaseViewModel {
  final _auditoriaApi = locator<AuditoriaApi>();
  final _usuariosApi = locator<UsuariosAPI>();
  final _navigationService = locator<NavigatorService>();
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();
  TextEditingController tcNewDescripcion = TextEditingController();

  List<AuditoriaData> auditorias = [];
  List<AuditoriaData> auditoriasTemp = [];
  List<UsuariosData> usuarios = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  String _opcion1 = "Tabla";
  String _opcion2 = "";
  List<String> opciones2 = [];
  bool primeraConsulta = false;
  bool hasNextPage = false;

  late AuditoriaResponse auditoriaResponse;

  AuditoriaViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasAuditoria();
        }
      }
    });
  }

  bool get cargando => _cargando;
  set cargando(bool value) {
    _cargando = value;
    notifyListeners();
  }

  String get opcion1 => _opcion1;
  set opcion(String value) {
    _opcion1 = value;
    opciones2 = [];

    switch (_opcion1) {
      case "Tabla":
        for (var opcion in auditorias) {
          if (!opciones2.any((element) => element == opcion.nombreTabla)) {
            opciones2.add(opcion.nombreTabla);
          }
        }
        break;
      case "Usuario":
        for (var opcion in auditorias) {
          if (!opciones2.any((element) => element == opcion.userName)) {
            opciones2.add(opcion.userName);
          }
        }
        break;
      case "Fecha":
        for (var opcion in auditorias) {
          var temp = opcion.fecha.split("T");
          if (!opciones2.any((element) => element == temp.first)) {
            var temp = opcion.fecha.split("T");
            opciones2.add(temp.first);
          }
        }
        opciones2.sort();
        break;
      default:
    }
    primeraConsulta = true;
    opcion2 = "";
    notifyListeners();
    ordenar();
  }

  String get opcion2 => _opcion2;
  set opcion2(String value) {
    _opcion2 = value;
    for (var element in auditorias) {
      auditoriasTemp.add(element);
    }
    switch (_opcion1) {
      case "Tabla":
        auditoriasTemp.removeWhere((element) => element.nombreTabla != value);
        break;
      case "Usuario":
        auditoriasTemp.removeWhere((element) => element.userName != value);
        break;
      case "Fecha":
        auditoriasTemp
            .removeWhere((element) => element.fecha.split("T").first != value);

        break;
      default:
    }
    notifyListeners();
  }

  bool get busqueda => _busqueda;
  set busqueda(bool value) {
    _busqueda = value;
    notifyListeners();
  }

  void ordenar() {
    switch (_opcion1) {
      case "Usuario":
        auditorias.sort((a, b) {
          return a.nombreTabla
              .toLowerCase()
              .compareTo(b.nombreTabla.toLowerCase());
        });
        break;
      case "Tabla":
        auditorias.sort((a, b) {
          return a.nombreTabla
              .toLowerCase()
              .compareTo(b.nombreTabla.toLowerCase());
        });
        break;
      case "Fecha":
        auditorias.sort((a, b) {
          return a.nombreTabla
              .toLowerCase()
              .compareTo(b.nombreTabla.toLowerCase());
        });
        break;
      default:
    }
  }

  List<String> opciones({required int numeroOpcion}) {
    List<String> opciones = ["Tabla", "Usuario", "Fecha"];
    switch (numeroOpcion) {
      case 1:
        return opciones;
      case 2:
        return opciones2;
      default:
        return opciones;
    }
  }

  Future<void> onInit() async {
    cargando = true;
    Object resp;
    resp = await _auditoriaApi.getAuditoria(pageNumber: pageNumber);
    if (resp is Success) {
      auditoriaResponse = resp.response as AuditoriaResponse;
      auditorias = auditoriaResponse.data;
      ordenar();
      hasNextPage = auditoriaResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    for (var opcion in auditorias) {
      if (!opciones2.any((element) => element == opcion.nombreTabla)) {
        opciones2.add(opcion.nombreTabla);
      }
    }
    cargando = false;
  }

  Future<void> cargarMasAuditoria() async {
    pageNumber += 1;
    Object resp;
    resp = await _auditoriaApi.getAuditoria(pageNumber: pageNumber);

    if (resp is Success) {
      var temp = resp.response as AuditoriaResponse;
      auditoriaResponse.data.addAll(temp.data);
      auditorias.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
  }

  Future<void> onRefresh() async {
    auditorias = [];
    cargando = true;
    Object resp;
    resp = await _auditoriaApi.getAuditoria(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as AuditoriaResponse;
      auditoriaResponse = temp;
      auditorias = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    cargando = false;
  }

  Future<void> modificarAuditoria(
      BuildContext ctx, AuditoriaData auditoria) async {
    final GlobalKey<FormState> _formKey = GlobalKey();
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.zero,
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    alignment: Alignment.center,
                    color: AppColors.brownLight,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Visualizar Auditoria',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: auditoria.nombreTabla,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    label: Text("Nombre Tabla")),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: auditoria.userName,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    label: Text("Usuario")),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: auditoria.fecha.split("T").first,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    label: Text("Fecha")),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: auditoria.fecha.split("T")[1],
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    label: Text("Hora")),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: auditoria.tipo,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    label: Text("Tipo")),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: auditoria.columnasAfectadas,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    label: Text("Columnas Afectadas")),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: auditoria.valoresAnteriores,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    label: Text("Valores Anteriores")),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: auditoria.valoresNuevos,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    label: Text("Valores Nuevos")),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: auditoria.primaryKey,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    label: Text("Primary Key")),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewDescripcion.clear();
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              AppIcons.closeCircle,
                              color: Colors.red,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Cancelar"), // text
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    listController.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
