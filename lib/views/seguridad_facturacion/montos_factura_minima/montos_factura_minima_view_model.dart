import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_facturacion/montos_factura_minima_api.dart';
import 'package:tasaciones_app/core/api/sucursales_api.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/montos_factura_minima_response.dart';
import 'package:tasaciones_app/core/models/sucursales_response.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class MontosFacturaMinimaViewModel extends BaseViewModel {
  final _montosFacturaMinimaApi = locator<MontosFacturaMinimaApi>();
  final _sucursalesApi = locator<SucursalesApi>();
  final _navigationService = locator<NavigatorService>();
  final listController = ScrollController();
  TextEditingController tcNewMonto = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<MontosFacturaMinimaData> montosFacturaMinima = [];
  List<SucursalesData> sucursales = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  // bool hasNextPage = false;
  late MontosFacturaMinimaResponse montosFacturaMinimaResponse;
  late SucursalesResponse sucursalesResponse;

  /*  MontosFacturaMinimaViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasMontosFacturaMinima();
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
    sucursales.sort((a, b) {
      return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _montosFacturaMinimaApi.getMontosFacturaMinima(
        pageNumber: pageNumber);
    if (resp is Success) {
      montosFacturaMinimaResponse =
          resp.response as MontosFacturaMinimaResponse;
      montosFacturaMinima = montosFacturaMinimaResponse.data;
      // hasNextPage = montosFacturaMinimaResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    var resp2 = await _sucursalesApi.getSucursales(pageNumber: pageNumber);
    if (resp2 is Success) {
      sucursalesResponse = resp2.response as SucursalesResponse;
      sucursales = sucursalesResponse.data;
      ordenar();
      notifyListeners();
    }
    if (resp2 is Failure) {
      Dialogs.error(msg: resp2.messages[0]);
      return onInit();
    }
    if (resp2 is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    cargando = false;
  }

  Future<void> cargarMasSucursales() async {
    pageNumber += 1;
    var resp = await _sucursalesApi.getSucursales(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as SucursalesResponse;
      sucursalesResponse.data.addAll(temp.data);
      sucursales.addAll(temp.data);
      ordenar();
      // hasNextPage = temp.hasNextPage;
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
    var resp2 = await _sucursalesApi.getSucursales(pageNumber: pageNumber);
    if (resp2 is Success) {
      var temp = resp2.response as SucursalesResponse;
      sucursales.addAll(temp.data);
      ordenar();
      // hasNextPage = MontosFacturaMinimaResponse.hasNextPage;
      notifyListeners();
    }
    if (resp2 is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp2.messages[0]);
    }
    if (resp2 is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
  }

  Future<void> buscarSucursal(String query) async {
    cargando = true;
    var resp = await _sucursalesApi.getSucursales(
      nombre: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as SucursalesResponse;
      sucursales = temp.data;
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
    sucursales = sucursalesResponse.data;
    // if (MontosFacturaMinima.length >= 20) {
    //   hasNextPage = true;
    // }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    montosFacturaMinima = [];
    sucursales = [];
    cargando = true;
    var resp = await _montosFacturaMinimaApi.getMontosFacturaMinima();
    if (resp is Success) {
      var temp = resp.response as MontosFacturaMinimaResponse;
      montosFacturaMinimaResponse = temp;
      montosFacturaMinima = temp.data;
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
    var resp2 = await _sucursalesApi.getSucursales(pageNumber: pageNumber);
    if (resp2 is Success) {
      sucursalesResponse = resp2.response as SucursalesResponse;
      sucursales = sucursalesResponse.data;
      ordenar();
      // hasNextPage = MontosFacturaMinimaResponse.hasNextPage;
      notifyListeners();
    }
    if (resp2 is Failure) {
      Dialogs.error(msg: resp2.messages[0]);
      return onRefresh();
    }
    if (resp2 is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    cargando = false;
  }

  Future<void> modificarMontosFacturaMinima(
      BuildContext ctx, SucursalesData sucursal) async {
    String monto = "";
    if (montosFacturaMinima
        .any((element) => element.codigoSucursal == sucursal.codigoSucursal)) {
      monto = montosFacturaMinima
          .firstWhere(
              (element) => element.codigoSucursal == sucursal.codigoSucursal)
          .valor;
    }
    tcNewMonto.text = monto;

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
                        'Modificar Monto Factura Mínima',
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
                                keyboardType: TextInputType.number,
                                readOnly: true,
                                initialValue: sucursal.nombre,
                                decoration: const InputDecoration(
                                  label: Text("Sucursal"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tcNewMonto,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.trim() == '') {
                                    return 'Escriba un Valor';
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
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /* TextButton(
                        onPressed: () async {
                          Dialogs.confirm(context,
                              tittle: "Eliminar Monto Factura Mínima",
                              description:
                                  "Está seguro que desea eliminar el Monto Factura Mínima ${sucursal.nombre}?",
                              confirm: () async {
                            ProgressDialog.show(context);
                            var resp = await _montosFacturaMinimaApi
                                .deleteMontosFacturaMinima(
                                    id: int.parse(sucursal.codigoSucursal));
                            ProgressDialog.dissmiss(context);
                            if (resp is Success) {
                              Dialogs.success(
                                  msg: 'Monto Facura Minima Eliminado');
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
                            tcNewMonto.clear();
                          });
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              AppIcons.trash,
                              color: AppColors.grey,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Eliminar"), // text
                          ],
                        ),
                      ), */
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewMonto.clear();
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
                            if (tcNewMonto.text.trim() != monto) {
                              ProgressDialog.show(context);
                              var resp = await _montosFacturaMinimaApi
                                  .updateMontosFacturaMinima(
                                      valor: tcNewMonto.text.trim(),
                                      codigoEntidad: sucursal.codigoEntidad,
                                      codigoSucursal: sucursal.codigoSucursal);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg: 'Monto Facura Minima Actualizado');
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
                              tcNewMonto.clear();
                            } else {
                              Dialogs.success(
                                  msg: 'Monto Facura Minima Actualizado');
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
    tcNewMonto.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
