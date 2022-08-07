import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/acciones_pendientes_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/seguridad_entidades_generales/accion_pendiente.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class AccionesPendientesViewModel extends BaseViewModel {
  final _accionesPendientes = locator<AccionesPendientesApi>();
  final listController = ScrollController();
  TextEditingController tcNewDescription = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<AccionesPendientesData> accionesPendientes = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late AccionesPendientesResponse accionesPendientesResponse;

  AccionesPendientesViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasAccionesPendientes();
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
    accionesPendientes.sort((a, b) {
      return a.descripcion.toLowerCase().compareTo(b.descripcion.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp =
        await _accionesPendientes.getAccionesPendientes(pageNumber: pageNumber);
    if (resp is Success) {
      accionesPendientesResponse = resp.response as AccionesPendientesResponse;
      accionesPendientes = accionesPendientesResponse.data;
      ordenar();
      hasNextPage = accionesPendientesResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasAccionesPendientes() async {
    pageNumber += 1;
    var resp =
        await _accionesPendientes.getAccionesPendientes(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as AccionesPendientesResponse;
      accionesPendientesResponse.data.addAll(temp.data);
      accionesPendientes.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscarAccionesPendientes(String query) async {
    cargando = true;
    var resp = await _accionesPendientes.getAccionesPendientes(
      descripcion: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as AccionesPendientesResponse;
      accionesPendientes = temp.data;
      ordenar();
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
    accionesPendientes = accionesPendientesResponse.data;
    if (accionesPendientes.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    accionesPendientes = [];
    cargando = true;
    var resp = await _accionesPendientes.getAccionesPendientes();
    if (resp is Success) {
      var temp = resp.response as AccionesPendientesResponse;
      accionesPendientesResponse = temp;
      accionesPendientes = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> modificarAccionesPendientes(
      BuildContext ctx, AccionesPendientesData accionPendiente) async {
    tcNewDescription.text = accionPendiente.descripcion;
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
                      'Modificar Adjunto',
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
                        controller: tcNewDescription,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba una descripción';
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
                        onPressed: () {
                          Navigator.pop(context);
                          Dialogs.confirm(ctx,
                              tittle: 'Eliminar Tipo Acción Pendiente',
                              description:
                                  '¿Esta seguro de eliminar el tipo adjunto ${accionPendiente.descripcion}?',
                              confirm: () async {
                            ProgressDialog.show(ctx);
                            var resp = await _accionesPendientes
                                .deleteAccionesPendientes(
                                    id: accionPendiente.id);
                            ProgressDialog.dissmiss(ctx);
                            if (resp is Failure) {
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is Success) {
                              Dialogs.success(
                                  msg: 'Tipo Acción Pendiente eliminado');
                              await onRefresh();
                            }
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
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewDescription.clear();
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
                            if (tcNewDescription.text.trim() !=
                                accionPendiente.descripcion) {
                              ProgressDialog.show(context);
                              var resp = await _accionesPendientes
                                  .updateAccionesPendientes(
                                      descripcion: tcNewDescription.text,
                                      id: accionPendiente.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg: 'Tipo Acción Pendiente Actualizado');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }

                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewDescription.clear();
                            } else {
                              Dialogs.success(
                                  msg: 'Tipo Acción Pendiente Actualizado');
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

  Future<void> crearAccionesPendientes(BuildContext ctx) async {
    tcNewDescription.clear();
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
                      'Crear Acción Pendiente Adjunto',
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
                        controller: tcNewDescription,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba una descripción';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Descripción",
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
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewDescription.clear();
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
                            var resp = await _accionesPendientes
                                .createAccionesPendientes(
                                    descripcion: tcNewDescription.text.trim());
                            ProgressDialog.dissmiss(context);
                            if (resp is Success) {
                              Dialogs.success(
                                  msg: 'Tipo Acción Pendiente Creado');
                              Navigator.of(context).pop();
                              await onRefresh();
                            }

                            if (resp is Failure) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            tcNewDescription.clear();
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
    tcNewDescription.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
