import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/modulos_api.dart';
import 'package:tasaciones_app/core/models/modulos_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/recursos_api.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/models/recursos_response.dart';
import '../../../theme/theme.dart';

class RecursosViewModel extends BaseViewModel {
  final _recursosApi = locator<RecursosAPI>();
  final _modulosApi = locator<ModulosApi>();
  final listController = ScrollController();
  TextEditingController tcNewName = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<RecursosData> recursos = [];
  List<ModulosData> modulos = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late RecursosResponse recursosResponse;
  ModulosData? modulo;

  RecursosViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasRecursos();
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
    var resp = await _recursosApi.getRecursos(pageNumber: pageNumber);
    if (resp is Success) {
      recursosResponse = resp.response as RecursosResponse;
      recursos = recursosResponse.data;
      hasNextPage = recursosResponse.hasNextPage;
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var modresp = await _modulosApi.getModulos();
    if (modresp is Success) {
      var data = modresp.response as ModulosResponse;
      modulos = data.data;
    }
    if (modresp is Failure) {
      Dialogs.error(msg: modresp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasRecursos() async {
    pageNumber += 1;
    var resp = await _recursosApi.getRecursos(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as RecursosResponse;
      recursosResponse.data.addAll(temp.data);
      recursos.addAll(temp.data);
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscarRecursos(String query) async {
    cargando = true;
    var resp = await _recursosApi.getRecursos(
      name: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as RecursosResponse;
      recursos = temp.data;
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
    recursos = recursosResponse.data;
    if (recursos.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    pageNumber = 1;
    var resp = await _recursosApi.getRecursos();
    if (resp is Success) {
      var temp = resp.response as RecursosResponse;
      recursosResponse = temp;
      recursos = temp.data;
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> modificarRecurso(BuildContext ctx, RecursosData recurso) async {
    tcNewName.text = recurso.nombre;
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
                      'Modificar Recurso',
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<ModulosData>(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      items: modulos
                          .map((e) => DropdownMenuItem<ModulosData>(
                                child: Text(e.nombre),
                                value: e,
                              ))
                          .toList(),
                      hint: Text(modulos
                          .firstWhere((e) => e.id == recurso.idModulo)
                          .nombre),
                      onChanged: (value) {
                        modulo = value;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (tcNewName.text.trim() != recurso.nombre ||
                                modulo?.id != recurso.idModulo) {
                              ProgressDialog.show(context);
                              var resp = await _recursosApi.updateRecursos(
                                idModulo: modulo == null
                                    ? recurso.idModulo
                                    : modulo!.id,
                                nombre: tcNewName.text.trim(),
                                id: recurso.id,
                              );
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(msg: 'Recurso actualizado');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }

                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewName.clear();
                            } else {
                              Dialogs.success(msg: 'Recurso actualizado');
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
                              tittle: 'Eliminar Recurso',
                              description:
                                  '¿Está seguro de eliminar el Recurso ${recurso.nombre}?',
                              confirm: () async {
                            ProgressDialog.show(ctx);
                            var resp = await _recursosApi.deleteRecursos(
                                id: recurso.id);
                            ProgressDialog.dissmiss(ctx);
                            if (resp is Failure) {
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is Success) {
                              Dialogs.success(msg: 'Recurso eliminado');
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

  Future<void> crearRecurso(BuildContext ctx) async {
    tcNewName.clear();
    modulo = null;
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
                      'Crear Recurso',
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<ModulosData>(
                      validator: (value) {
                        if (value == null) {
                          return 'Seleccione un módulo';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      items: modulos
                          .map((e) => DropdownMenuItem<ModulosData>(
                                child: Text(e.nombre),
                                value: e,
                              ))
                          .toList(),
                      hint: const Text('Seleccione un Módulo'),
                      onChanged: (value) {
                        modulo = value;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ProgressDialog.show(context);
                            var resp = await _recursosApi.createRecursos(
                              name: tcNewName.text.trim(),
                              idModulo: modulo!.id,
                            );
                            ProgressDialog.dissmiss(context);
                            if (resp is Success) {
                              Dialogs.success(msg: 'Recurso Creado');
                              Navigator.of(context).pop();
                              await onRefresh();
                            }

                            if (resp is Failure) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            tcNewName.clear();
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
