import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/acciones_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/acciones_api.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class AccionesViewModel extends BaseViewModel {
  final _accionesApi = locator<AccionesApi>();
  final listController = ScrollController();
  TextEditingController tcNewName = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<AccionesData> acciones = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late AccionesResponse accionesResponse;

  AccionesViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasAcciones();
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

  Future<void> onInit() async {
    cargando = true;
    var resp = await _accionesApi.getAcciones(pageNumber: pageNumber);
    if (resp is Success) {
      accionesResponse = resp.response as AccionesResponse;
      acciones = accionesResponse.data;
      hasNextPage = accionesResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasAcciones() async {
    pageNumber += 1;
    var resp = await _accionesApi.getAcciones(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as AccionesResponse;
      accionesResponse.data.addAll(temp.data);
      acciones.addAll(temp.data);
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscarAccion(String query) async {
    cargando = true;
    var resp = await _accionesApi.getAcciones(
      name: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as AccionesResponse;
      acciones = temp.data;
      hasNextPage = temp.hasNextPage;
      _busqueda = true;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  void limpiarBusqueda() {
    _busqueda = false;
    acciones = accionesResponse.data;
    if (acciones.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    var resp = await _accionesApi.getAcciones();
    if (resp is Success) {
      var temp = resp.response as AccionesResponse;
      accionesResponse = temp;
      acciones = temp.data;
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> modificarAccion(BuildContext ctx, AccionesData accion) async {
    tcNewName.text = accion.nombre;
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
                      'Modificar Acción',
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
                        controller: tcNewName,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un nombre';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (tcNewName.text.trim() != accion.nombre) {
                              ProgressDialog.show(context);
                              var resp = await _accionesApi.updateAcciones(
                                  name: tcNewName.text, id: accion.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(msg: 'Acción Modificada');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }

                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewName.clear();
                            } else {
                              Dialogs.success(msg: 'Acción Modificada');
                              Navigator.of(context).pop();
                            }
                          }
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.save,
                              color: AppColors.green,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Guardar"), // text
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewName.clear();
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.cancel,
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
                        onPressed: () {
                          Navigator.pop(context);
                          Dialogs.confirm(ctx,
                              tittle: 'Eliminar Acción',
                              description:
                                  '¿Esta seguro de eliminar la acción ${accion.nombre}?',
                              confirm: () async {
                            ProgressDialog.show(ctx);
                            var resp = await _accionesApi.deleteAcciones(
                                id: accion.id);
                            ProgressDialog.dissmiss(ctx);
                            if (resp is Failure) {
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is Success) {
                              Dialogs.success(msg: 'Acción eliminada');
                              await onRefresh();
                            }
                          });
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.delete,
                              color: AppColors.grey,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Eliminar"), // text
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

  Future<void> crearAccion(BuildContext ctx) async {
    tcNewName.clear();
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
                      'Crear Acción',
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
                        controller: tcNewName,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un nombre';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ProgressDialog.show(context);
                            var resp = await _accionesApi.createAcciones(
                                name: tcNewName.text.trim());
                            ProgressDialog.dissmiss(context);
                            if (resp is Success) {
                              Dialogs.success(msg: 'Acción Creada');
                              Navigator.of(context).pop();
                              await onRefresh();
                            }

                            if (resp is Failure) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            tcNewName.clear();
                          } else {
                            Dialogs.success(msg: 'Acción Modificada');
                            Navigator.of(context).pop();
                          }
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.save,
                              color: AppColors.green,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Guardar"), // text
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewName.clear();
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.cancel,
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
    tcNewName.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
