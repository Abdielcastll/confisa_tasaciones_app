import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/suplidores_api.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/suplidores_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class SuplidoresViewModel extends BaseViewModel {
  final _suplidoresApi = locator<SuplidoresApi>();
  final listController = ScrollController();
  TextEditingController tcNewDetalle = TextEditingController();
  TextEditingController tcNewRegistro = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<SuplidorData> suplidores = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late SuplidoresResponse suplidoresResponse;

  SuplidoresViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasSuplidores();
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
    suplidores.sort((a, b) {
      return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _suplidoresApi.getSuplidores(pageNumber: pageNumber);
    if (resp is Success) {
      suplidoresResponse = resp.response as SuplidoresResponse;
      suplidores = suplidoresResponse.data;
      ordenar();
      /* hasNextPage = suplidoresResponse.hasNextPage; */
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasSuplidores() async {
    pageNumber += 1;
    var resp = await _suplidoresApi.getSuplidores(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as SuplidoresResponse;
      suplidoresResponse.data.addAll(temp.data);
      suplidores.addAll(temp.data);
      ordenar();
      /* hasNextPage = temp.hasNextPage; */
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscarSuplidor(String query) async {
    cargando = true;
    var resp = await _suplidoresApi.getSuplidores(
      nombre: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as SuplidoresResponse;
      suplidores = temp.data;
      ordenar();
      /* hasNextPage = temp.hasNextPage; */
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
    suplidores = suplidoresResponse.data;
    if (suplidores.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    suplidores = [];
    cargando = true;
    var resp = await _suplidoresApi.getSuplidores();
    if (resp is Success) {
      var temp = resp.response as SuplidoresResponse;
      suplidoresResponse = temp;
      suplidores = temp.data;
      ordenar();
      /* hasNextPage = temp.hasNextPage; */
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> modificarSuplidor(
      BuildContext ctx, SuplidorData suplidor) async {
    tcNewDetalle.text = suplidor.detalles;
    tcNewRegistro.text = suplidor.registro;
    String selectEstado = suplidor.estado == 1 ? "Activo" : "Inactivo";
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: AppColors.brownLight,
                  child: const Text(
                    'Modificar suplidor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: suplidor.nombre,
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
                                readOnly: true,
                                initialValue: suplidor.identificacion,
                                decoration: const InputDecoration(
                                  label: Text("Identificación"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          suplidor.direccion != ""
                              ? SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      initialValue: suplidor.direccion,
                                      decoration: const InputDecoration(
                                        label: Text("Dirección"),
                                        border: UnderlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          suplidor.email != ""
                              ? SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      initialValue: suplidor.email,
                                      decoration: const InputDecoration(
                                        label: Text("Email"),
                                        border: UnderlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          suplidor.celular != ""
                              ? SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      initialValue: suplidor.celular,
                                      decoration: const InputDecoration(
                                        label: Text("Celular"),
                                        border: UnderlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          suplidor.telefono != ""
                              ? SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      initialValue: suplidor.telefono,
                                      decoration: const InputDecoration(
                                        label: Text("Teléfono"),
                                        border: UnderlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tcNewRegistro,
                                decoration: const InputDecoration(
                                  label: Text("Registro"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tcNewDetalle,
                                decoration: const InputDecoration(
                                  label: Text("Detalle"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              enabled: false,
                              initialValue:
                                  suplidor.estado == 1 ? "Activo" : "Inactivo",
                              decoration: const InputDecoration(
                                labelText: "Estado",
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () async {
                        ProgressDialog.show(context);
                        var resp = await _suplidoresApi.updateSuplidor(
                            detalles: suplidor.detalles,
                            registro: suplidor.registro,
                            estado: suplidor.estado == 1 ? 0 : 1,
                            idSuplidor: suplidor.codigoRelacionado);
                        ProgressDialog.dissmiss(context);
                        if (resp is Success) {
                          Dialogs.success(
                              msg:
                                  'Estado ${suplidor.estado == 1 ? "inactivado" : "activado"}');
                          Navigator.of(context).pop();
                          await onRefresh();
                        }

                        if (resp is Failure) {
                          ProgressDialog.dissmiss(context);
                          Dialogs.error(msg: resp.messages[0]);
                        }
                        tcNewDetalle.clear();
                        tcNewRegistro.clear();
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            suplidor.estado == 1
                                ? AppIcons.trash
                                : AppIcons.iconPlus,
                            color: suplidor.estado == 1
                                ? AppColors.grey
                                : AppColors.gold,
                          ),
                          const SizedBox(
                            height: 3,
                          ), // icon
                          Text(
                            suplidor.estado == 1 ? "Inactivar" : "Activar",
                            overflow: TextOverflow.ellipsis,
                          ), // text
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        tcNewDetalle.clear();
                        tcNewRegistro.clear();
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
                          if (tcNewDetalle.text.trim() != suplidor.detalles ||
                              tcNewRegistro.text.trim() != suplidor.registro ||
                              suplidor.estado !=
                                  (selectEstado == "Activo" ? 1 : 0)) {
                            ProgressDialog.show(context);
                            var resp = await _suplidoresApi.updateSuplidor(
                                detalles: tcNewDetalle.text.trim(),
                                registro: tcNewRegistro.text.trim(),
                                estado: suplidor.estado,
                                idSuplidor: suplidor.codigoRelacionado);
                            ProgressDialog.dissmiss(context);
                            if (resp is Success) {
                              Dialogs.success(msg: 'Suplidor Actualizado');
                              Navigator.of(context).pop();
                              await onRefresh();
                            }

                            if (resp is Failure) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            tcNewDetalle.clear();
                            tcNewRegistro.clear();
                          } else {
                            Dialogs.success(msg: 'Suplidor Actualizado');
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
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    listController.dispose();
    tcNewDetalle.dispose();
    tcNewRegistro.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
