import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/periodo_eliminacion_data_grafica_api.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/periodo_eliminacion_data_grafica_response.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class PeriodoEliminacionDataGraficaViewModel extends BaseViewModel {
  final _periodoEliminacionDataGraficaApi =
      locator<PeriodoEliminacionDataGraficaApi>();
  final _navigationService = locator<NavigatorService>();
  /* final _segmentosPeriodoEliminacionDataGraficaVehiculosApi =
      locator<SegmentosPeriodoEliminacionDataGraficaVehiculosApi>(); */
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();
  TextEditingController tcNewDescripcion = TextEditingController();

  List<PeriodoEliminacionDataGraficaData> periodoEliminacionDataGrafica = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  String _opcion = "Vencida";
  bool hasNextPage = false;

  late PeriodoEliminacionDataGraficaResponse
      periodoEliminacionDataGraficaResponse;

  PeriodoEliminacionDataGraficaViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasPeriodoEliminacionDataGrafica();
        }
      }
    });
  }

  bool get cargando => _cargando;
  set cargando(bool value) {
    _cargando = value;
    notifyListeners();
  }

  String get opcion => _opcion;
  set opcion(String value) {
    _opcion = value;
    notifyListeners();
    onInit();
  }

  bool get busqueda => _busqueda;
  set busqueda(bool value) {
    _busqueda = value;
    notifyListeners();
  }

  void ordenar() {
    periodoEliminacionDataGrafica.sort((a, b) {
      return a.descripcion.toLowerCase().compareTo(b.descripcion.toLowerCase());
    });
  }

  List<DropdownMenuItem<String>> opciones() {
    List<String> opciones = ["Vencida", "Valorada", "Rechazada"];

    return opciones
        .map((e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ))
        .toList();
  }

  Future<void> onInit() async {
    cargando = true;
    Object resp;
    switch (_opcion) {
      case "Vencida":
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaVencida(pageNumber: pageNumber);
        break;
      case "Valorada":
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaValorada(pageNumber: pageNumber);
        break;
      case "Rechazada":
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaRechazada(pageNumber: pageNumber);
        break;
      default:
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaVencida(pageNumber: pageNumber);
    }
    if (resp is Success) {
      periodoEliminacionDataGraficaResponse =
          resp.response as PeriodoEliminacionDataGraficaResponse;
      periodoEliminacionDataGrafica =
          periodoEliminacionDataGraficaResponse.data;
      ordenar();
      hasNextPage = periodoEliminacionDataGraficaResponse.hasNextPage;
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

  Future<void> cargarMasPeriodoEliminacionDataGrafica() async {
    pageNumber += 1;
    Object resp;
    switch (_opcion) {
      case "Vencida":
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaVencida(pageNumber: pageNumber);
        break;
      case "Valorada":
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaValorada(pageNumber: pageNumber);
        break;
      case "Rechazada":
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaRechazada(pageNumber: pageNumber);
        break;
      default:
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaVencida(pageNumber: pageNumber);
    }
    if (resp is Success) {
      var temp = resp.response as PeriodoEliminacionDataGraficaResponse;
      periodoEliminacionDataGraficaResponse.data.addAll(temp.data);
      periodoEliminacionDataGrafica.addAll(temp.data);
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

  Future<void> buscarPeriodoEliminacionDataGrafica(String query) async {
    cargando = true;
    Object resp;
    switch (_opcion) {
      case "Vencida":
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaVencida(
          descripcion: query,
          pageSize: 0,
        );
        break;
      case "Valorada":
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaValorada(
          descripcion: query,
          pageSize: 0,
        );
        break;
      case "Rechazada":
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaRechazada(
          descripcion: query,
          pageSize: 0,
        );
        break;
      default:
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaVencida(
          descripcion: query,
          pageSize: 0,
        );
    }
    if (resp is Success) {
      var temp = resp.response as PeriodoEliminacionDataGraficaResponse;
      periodoEliminacionDataGrafica = temp.data;
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
    periodoEliminacionDataGrafica = periodoEliminacionDataGraficaResponse.data;
    if (periodoEliminacionDataGrafica.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    periodoEliminacionDataGrafica = [];
    cargando = true;
    Object resp;
    switch (_opcion) {
      case "Vencida":
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaVencida(pageNumber: pageNumber);
        break;
      case "Valorada":
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaValorada(pageNumber: pageNumber);
        break;
      case "Rechazada":
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaRechazada(pageNumber: pageNumber);
        break;
      default:
        resp = await _periodoEliminacionDataGraficaApi
            .getPeriodoEliminacionDataGraficaVencida(pageNumber: pageNumber);
    }
    if (resp is Success) {
      var temp = resp.response as PeriodoEliminacionDataGraficaResponse;
      periodoEliminacionDataGraficaResponse = temp;
      periodoEliminacionDataGrafica = temp.data;
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

  Future<void> modificarPeriodoEliminacionDataGrafica(BuildContext ctx,
      PeriodoEliminacionDataGraficaData periodoEliminacionDataGrafica) async {
    tcNewDescripcion.text = periodoEliminacionDataGrafica.descripcion;
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
                        'Modificar Período Eliminación Data Gráfica',
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
                        controller: tcNewDescripcion,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba una descripción';
                          } else {
                            if (int.parse(value.trim()) > 30) {
                              tcNewDescripcion.text =
                                  periodoEliminacionDataGrafica.descripcion;
                              return "No puede ser mayor a 30";
                            }
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            label: Text("Descripción")),
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
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if ((tcNewDescripcion.text.trim() !=
                                periodoEliminacionDataGrafica.descripcion
                                    .toString())) {
                              ProgressDialog.show(context);
                              Object resp;
                              switch (_opcion) {
                                case "Vencida":
                                  resp = await _periodoEliminacionDataGraficaApi
                                      .updatePeriodoEliminacionDataGraficaVencida(
                                          descripcion: tcNewDescripcion.text,
                                          id: periodoEliminacionDataGrafica.id);
                                  break;
                                case "Valorada":
                                  resp = await _periodoEliminacionDataGraficaApi
                                      .updatePeriodoEliminacionDataGraficaValorada(
                                          descripcion: tcNewDescripcion.text,
                                          id: periodoEliminacionDataGrafica.id);
                                  break;
                                case "Rechazada":
                                  resp = await _periodoEliminacionDataGraficaApi
                                      .updatePeriodoEliminacionDataGraficaRechazada(
                                          descripcion: tcNewDescripcion.text,
                                          id: periodoEliminacionDataGrafica.id);
                                  break;
                                default:
                                  resp = await _periodoEliminacionDataGraficaApi
                                      .getPeriodoEliminacionDataGraficaVencida(
                                          pageNumber: pageNumber);
                              }

                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg:
                                        'Período Eliminación Data Gráfica Actualizada');
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
                              tcNewDescripcion.clear();
                            } else {
                              Dialogs.success(
                                  msg:
                                      'Período Eliminación Data Gráfica Actualizada');
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
