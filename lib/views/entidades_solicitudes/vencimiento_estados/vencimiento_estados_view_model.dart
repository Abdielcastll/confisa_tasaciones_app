import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/vencimiento_estados_api.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/vencimiento_estados_response.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class VencimientoEstadosViewModel extends BaseViewModel {
  final _vencimientoEstadosApi = locator<VencimientoEstadosApi>();
  final _navigationService = locator<NavigatorService>();
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();
  TextEditingController tcNewPeriodo = TextEditingController();

  List<VencimientoEstadosData> vencimientoEstados = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late VencimientoEstadosResponse vencimientoEstadosResponse;

  VencimientoEstadosViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasVencimientoEstados();
        }
      }
    });
  }

  bool get cargando => _cargando;
  set cargando(bool value) {
    _cargando = value;
    notifyListeners();
  }

  bool get busqueda => _busqueda;
  set busqueda(bool value) {
    _busqueda = value;
    notifyListeners();
  }

  void ordenar() {
    vencimientoEstados.sort((a, b) {
      return a.estadoDescripcion
          .toLowerCase()
          .compareTo(b.estadoDescripcion.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _vencimientoEstadosApi.getVencimientoEstados(
        pageNumber: pageNumber);
    if (resp is Success) {
      vencimientoEstadosResponse = resp.response as VencimientoEstadosResponse;
      vencimientoEstados = vencimientoEstadosResponse.data;
      ordenar();
      hasNextPage = vencimientoEstadosResponse.hasNextPage;
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

  Future<void> cargarMasVencimientoEstados() async {
    pageNumber += 1;
    var resp = await _vencimientoEstadosApi.getVencimientoEstados(
        pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as VencimientoEstadosResponse;
      vencimientoEstadosResponse.data.addAll(temp.data);
      vencimientoEstados.addAll(temp.data);
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

  Future<void> buscarVencimientoEstados(String query) async {
    cargando = true;
    var resp = await _vencimientoEstadosApi.getVencimientoEstados(
      estadoDescripcion: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as VencimientoEstadosResponse;
      vencimientoEstados = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      _busqueda = true;
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

  void limpiarBusqueda() {
    _busqueda = false;
    vencimientoEstados = vencimientoEstadosResponse.data;
    if (vencimientoEstados.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    vencimientoEstados = [];
    cargando = true;
    var resp = await _vencimientoEstadosApi.getVencimientoEstados();
    if (resp is Success) {
      var temp = resp.response as VencimientoEstadosResponse;
      vencimientoEstadosResponse = temp;
      vencimientoEstados = temp.data;
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

  Future<void> modificarVencimientoEstados(
      BuildContext ctx, VencimientoEstadosData vencimientoEstado) async {
    tcNewPeriodo.text = vencimientoEstado.periodo.toString();
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    alignment: Alignment.center,
                    color: AppColors.brownLight,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Modificar Vencimiento Estados Solicitudes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewPeriodo,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un periodo';
                          } else {
                            if (int.parse(value.trim()) > 100) {
                              return "Debe ser menor a 100 días";
                            } else {
                              return null;
                            }
                          }
                        },
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            label: Text("Periodo")),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewPeriodo.clear();
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
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if ((tcNewPeriodo.text.trim() !=
                                vencimientoEstado.periodo.toString())) {
                              ProgressDialog.show(context);
                              var resp = await _vencimientoEstadosApi
                                  .updateVencimientoEstados(
                                      periodo: int.parse(tcNewPeriodo.text),
                                      id: vencimientoEstado.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg:
                                        'Vencimiento Estado Solicitud Actualizado');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }
                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              if (resp is TokenFail) {
                                _navigationService.navigateToPageAndRemoveUntil(
                                    LoginView.routeName);
                                Dialogs.error(msg: 'Sesión expirada');
                              }
                              tcNewPeriodo.clear();
                            } else {
                              Dialogs.success(
                                  msg:
                                      'Vencimiento Estado Solicitud Actualizado');
                              Navigator.of(context).pop();
                            }
                          }
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              AppIcons.save,
                              color: AppColors.green,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Guardar"), // text
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
