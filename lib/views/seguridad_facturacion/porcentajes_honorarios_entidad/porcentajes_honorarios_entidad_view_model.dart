import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_facturacion/porcentajes_honorarios_entidad_api.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/porcentajes_honorarios_entidad_response.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class PorcentajesHonorariosEntidadViewModel extends BaseViewModel {
  final _porcentajesHonorariosEntidadApi =
      locator<PorcentajesHonorariosEntidadApi>();
  final _navigationService = locator<NavigatorService>();
  final listController = ScrollController();
  TextEditingController tcNewValor = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<PorcentajesHonorariosEntidadData> porcentajesHonorariosEntidad = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;

  late PorcentajesHonorariosEntidadResponse
      porcentajesHonorariosEntidadResponse;

  PorcentajesHonorariosEntidadViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasPorcentajesHonorariosEntidad();
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
    porcentajesHonorariosEntidad.sort((a, b) {
      return a.descripcionEntidad
          .toLowerCase()
          .compareTo(b.descripcionEntidad.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _porcentajesHonorariosEntidadApi
        .getPorcentajesHonorariosEntidad(pageNumber: pageNumber);
    if (resp is Success) {
      porcentajesHonorariosEntidadResponse =
          resp.response as PorcentajesHonorariosEntidadResponse;
      porcentajesHonorariosEntidad = porcentajesHonorariosEntidadResponse.data;
      ordenar();
      hasNextPage = porcentajesHonorariosEntidadResponse.hasNextPage;
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

  Future<void> cargarMasPorcentajesHonorariosEntidad() async {
    pageNumber += 1;
    var resp = await _porcentajesHonorariosEntidadApi
        .getPorcentajesHonorariosEntidad(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as PorcentajesHonorariosEntidadResponse;
      porcentajesHonorariosEntidadResponse.data.addAll(temp.data);
      porcentajesHonorariosEntidad.addAll(temp.data);
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

  Future<void> buscarPorcentajeHonorarioEntidad(String query) async {
    cargando = true;
    var resp =
        await _porcentajesHonorariosEntidadApi.getPorcentajesHonorariosEntidad(
      valor: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as PorcentajesHonorariosEntidadResponse;
      porcentajesHonorariosEntidad = temp.data;
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
    porcentajesHonorariosEntidad = porcentajesHonorariosEntidadResponse.data;
    if (porcentajesHonorariosEntidad.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    porcentajesHonorariosEntidad = [];
    cargando = true;
    var resp = await _porcentajesHonorariosEntidadApi
        .getPorcentajesHonorariosEntidad();
    if (resp is Success) {
      var temp = resp.response as PorcentajesHonorariosEntidadResponse;
      porcentajesHonorariosEntidadResponse = temp;
      porcentajesHonorariosEntidad = temp.data;
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

  Future<void> modificarPorcentajeHonorarioEntidad(
      BuildContext ctx,
      PorcentajesHonorariosEntidadData porcentajeHonorarioEntidad,
      String valor) async {
    tcNewValor.text = porcentajeHonorarioEntidad.valor;

    if (valor != porcentajeHonorarioEntidad.valor) {
      ProgressDialog.show(ctx);
      var resp = await _porcentajesHonorariosEntidadApi
          .createOrUpdatePorcentajesHonorariosEntidad(
              valor: valor,
              codigoEntidad: porcentajeHonorarioEntidad.codigoEntidad);
      ProgressDialog.dissmiss(ctx);
      if (resp is Success) {
        Dialogs.success(msg: 'Porcentaje Honorario Entidad Actualizado');
        await onRefresh();
      }

      if (resp is Failure) {
        ProgressDialog.dissmiss(ctx);
        Dialogs.error(msg: resp.messages[0]);
      }
      if (resp is TokenFail) {
        _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'Sesión expirada');
      }
      tcNewValor.clear();
    } else {
      Dialogs.success(msg: 'Porcentaje Honorario Entidad Actualizado');
    }
  }

  Future<void> crearPorcentajeHonorarioEntidad(BuildContext ctx) async {
    tcNewValor.clear();
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
                    child: const Text(
                      'Crear Porcentaje Honorario Entidad',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewValor,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un valor';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Valor"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewValor.clear();
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
                            ProgressDialog.show(context);
                            var resp = await _porcentajesHonorariosEntidadApi
                                .createOrUpdatePorcentajesHonorariosEntidad(
                                    codigoEntidad: "",
                                    valor: tcNewValor.text.trim());
                            ProgressDialog.dissmiss(context);
                            if (resp is Success) {
                              Dialogs.success(
                                  msg: 'Porcentaje Honorario Entidad Creado');
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
                            tcNewValor.clear();
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
    tcNewValor.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
