import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_facturacion/aprobadores_facturas_api.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/aprobadores_facturas_response.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class AprobadoresFacturasViewModel extends BaseViewModel {
  final _aprobadoresFacturasApi = locator<AprobadoresFacturasApi>();
  final _navigationService = locator<NavigatorService>();
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();

  List<AprobadoresFacturasData> aprobadoresFacturas = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late AprobadoresFacturasResponse aprobadoresFacturasResponse;

  AprobadoresFacturasViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasAprobadoresFacturas();
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
    aprobadoresFacturas.sort((a, b) {
      return a.nombreCompleto
          .toLowerCase()
          .compareTo(b.nombreCompleto.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _aprobadoresFacturasApi.getTarifariosTasacion(
        pageNumber: pageNumber);
    if (resp is Success) {
      aprobadoresFacturasResponse =
          resp.response as AprobadoresFacturasResponse;
      aprobadoresFacturas = aprobadoresFacturasResponse.data;
      ordenar();
      hasNextPage = aprobadoresFacturasResponse.hasNextPage;
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

  Future<void> cargarMasAprobadoresFacturas() async {
    pageNumber += 1;
    var resp = await _aprobadoresFacturasApi.getTarifariosTasacion(
        pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as AprobadoresFacturasResponse;
      aprobadoresFacturasResponse.data.addAll(temp.data);
      aprobadoresFacturas.addAll(temp.data);
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

  Future<void> buscarAprobadoresFacturas(String query) async {
    cargando = true;
    var resp = await _aprobadoresFacturasApi.getTarifariosTasacion(
      nombreCompleto: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as AprobadoresFacturasResponse;
      aprobadoresFacturas = temp.data;
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
    aprobadoresFacturas = aprobadoresFacturasResponse.data;
    if (aprobadoresFacturas.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    aprobadoresFacturas = [];
    cargando = true;
    var resp = await _aprobadoresFacturasApi.getTarifariosTasacion();
    if (resp is Success) {
      var temp = resp.response as AprobadoresFacturasResponse;
      aprobadoresFacturasResponse = temp;
      aprobadoresFacturas = temp.data;
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

  Future<void> modificarAprobadoresFacturas(
      BuildContext ctx, AprobadoresFacturasData aprobadoresFacturas) async {
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
                        'Visualizar Aprobador Factura',
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
                                initialValue:
                                    aprobadoresFacturas.nombreCompleto,
                                decoration: const InputDecoration(
                                  label: Text("Nombre"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: aprobadoresFacturas.email,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  label: Text("Email"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: aprobadoresFacturas.phoneNumber,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  label: Text("Teléfono"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue:
                                    aprobadoresFacturas.estadoAprobadorFactura
                                        ? "Activo"
                                        : "Inactivo",
                                readOnly: true,
                                decoration: const InputDecoration(
                                  label: Text("Estado de Aprobación"),
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
                      TextButton(
                        onPressed: () async {
                          ProgressDialog.show(context);
                          var resp = await _aprobadoresFacturasApi
                              .updateEstadoAprobadoresFacturas(
                                  activateUser:
                                      aprobadoresFacturas.estadoAprobadorFactura
                                          ? false
                                          : true,
                                  userId: aprobadoresFacturas.id);
                          ProgressDialog.dissmiss(context);
                          if (resp is Success) {
                            Dialogs.success(msg: 'Estado Actualizado');
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
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              aprobadoresFacturas.estadoAprobadorFactura
                                  ? AppIcons.trash
                                  : AppIcons.checkCircle,
                              color: AppColors.grey,
                            ),
                            const SizedBox(
                              height: 3,
                            ), // icon
                            Text(aprobadoresFacturas.estadoAprobadorFactura
                                ? "Inactivar"
                                : "Activar"), // text
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
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
