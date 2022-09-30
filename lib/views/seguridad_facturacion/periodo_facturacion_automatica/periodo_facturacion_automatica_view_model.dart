import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_facturacion/periodo_facturacion_automatica_api.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/periodo_facturacion_automatica_response.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class PeriodoFacturacionAutomaticaViewModel extends BaseViewModel {
  final _periodoFacturacionAutomaticaApi =
      locator<PeriodoFacturacionAutomaticaApi>();
  final _navigationService = locator<NavigatorService>();
  final listController = ScrollController();
  TextEditingController tcNewDescripcion = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<PeriodoFacturacionAutomaticaData> periodosFacturacionAutomatica = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  final List<String> opciones = ["Quincenal", "Mensual"];
  // bool hasNextPage = false;
  late PeriodoFacturacionAutomaticaResponse
      periodoFacturacionAutomaticaResponse;

  /* PeriodoFacturacionAutomaticaViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasPeriodoFacturacionAutomatica();
        }
      }
    });
  } */

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
    periodosFacturacionAutomatica.sort((a, b) {
      return a.suplidor.toLowerCase().compareTo(b.suplidor.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _periodoFacturacionAutomaticaApi
        .getPeriodoFacturacionAutomatica();
    if (resp is Success) {
      periodoFacturacionAutomaticaResponse =
          resp.response as PeriodoFacturacionAutomaticaResponse;
      periodosFacturacionAutomatica = periodoFacturacionAutomaticaResponse.data;
      ordenar();
      // hasNextPage = PeriodoFacturacionAutomaticaResponse.hasNextPage;
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

  /* Future<void> cargarMasPeriodoFacturacionAutomatica() async {
    pageNumber += 1;
    var resp = await _periodoFacturacionAutomaticaApi
        .getPeriodoFacturacionAutomatica(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as PeriodoFacturacionAutomaticaResponse;
      PeriodoFacturacionAutomaticaResponse.data.addAll(temp.data);
      PeriodoFacturacionAutomatica.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  } */

  Future<void> buscarPeriodoFacturacionAutomatica(String query) async {
    cargando = true;
    var resp =
        await _periodoFacturacionAutomaticaApi.getPeriodoFacturacionAutomatica(
      idSuplidor: int.parse(query),
    );
    if (resp is Success) {
      var temp = resp.response as PeriodoFacturacionAutomaticaResponse;
      periodosFacturacionAutomatica = temp.data;
      ordenar();
      // hasNextPage = temp.hasNextPage;
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
    periodosFacturacionAutomatica = periodoFacturacionAutomaticaResponse.data;
    // if (periodosFacturacionAutomatica.length >= 20) {
    //   hasNextPage = true;
    // }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    periodosFacturacionAutomatica = [];
    cargando = true;
    var resp = await _periodoFacturacionAutomaticaApi
        .getPeriodoFacturacionAutomatica();
    if (resp is Success) {
      var temp = resp.response as PeriodoFacturacionAutomaticaResponse;
      periodoFacturacionAutomaticaResponse = temp;
      periodosFacturacionAutomatica = temp.data;
      ordenar();
      // hasNextPage = temp.hasNextPage;
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

  Future<void> modificarPeriodoFacturacionAutomatica(BuildContext ctx,
      PeriodoFacturacionAutomaticaData periodoFacturacionAutomatica) async {
    tcNewDescripcion.text = periodoFacturacionAutomatica.descripcion;
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
                        'Modificar Periodo Tasación Automática',
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
                                initialValue:
                                    periodoFacturacionAutomatica.suplidor,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  label: Text("Suplidor"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<String>(
                              selectedItem:
                                  periodoFacturacionAutomatica.valor == "62"
                                      ? "Mensula"
                                      : "Quincenal",
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          label: Text("Periodo"))),
                              popupProps: const PopupProps.menu(
                                  fit: FlexFit.loose,
                                  showSelectedItems: true,
                                  searchDelay: Duration(microseconds: 0)),
                              items: opciones,
                              onChanged: (newValue) {
                                tcNewDescripcion.text = newValue!;
                              },
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
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (tcNewDescripcion.text.trim() !=
                                periodoFacturacionAutomatica.descripcion) {
                              ProgressDialog.show(context);
                              var resp = await _periodoFacturacionAutomaticaApi
                                  .updatePeriodoFacturacionAutomatica(
                                      valor: tcNewDescripcion.text.trim() ==
                                              "Quincenal"
                                          ? "63"
                                          : "62",
                                      idSuplidor: int.parse(
                                          periodoFacturacionAutomatica
                                              .idSuplidor));
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg:
                                        'Periodo Facturación Automática Actualizado');
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
                                      'Periodo Facturación Automática Actualizado');
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
    tcNewDescripcion.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
