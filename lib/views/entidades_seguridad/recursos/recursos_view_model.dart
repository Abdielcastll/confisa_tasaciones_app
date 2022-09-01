import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/modulos_api.dart';
import 'package:tasaciones_app/core/models/modulos_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/recursos_api.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/models/recursos_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';
import '../../auth/login/login_view.dart';

class RecursosViewModel extends BaseViewModel {
  final _recursosApi = locator<RecursosAPI>();
  final _modulosApi = locator<ModulosApi>();
  final _navigatorService = locator<NavigatorService>();
  final listController = ScrollController();
  TextEditingController tcNewName = TextEditingController();
  TextEditingController tcDecripcionMenu = TextEditingController();
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

  void ordenar() {
    recursos.sort((a, b) {
      return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _recursosApi.getRecursos(pageNumber: pageNumber);
    if (resp is Success) {
      recursosResponse = resp.response as RecursosResponse;
      recursos = recursosResponse.data;
      ordenar();
      hasNextPage = recursosResponse.hasNextPage;
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
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
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
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
      ordenar();
      hasNextPage = temp.hasNextPage;
      _busqueda = true;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
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
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
  }

  Future<void> modificarRecurso(BuildContext ctx, RecursosData recurso) async {
    tcNewName.text = recurso.nombre;
    tcDecripcionMenu.text = recurso.descripcionMenuConfiguracion;
    bool mostrarEnMenu = recurso.esMenuConfiguracion == 0 ? false : true;
    final GlobalKey<FormState> _formKey = GlobalKey();
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
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
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(children: [
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
                                  decoration: const InputDecoration(
                                      border: UnderlineInputBorder()),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField<ModulosData>(
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder()),
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
                            CheckboxListTile(
                                title: const Text('Mostrar en el menú'),
                                value: mostrarEnMenu,
                                onChanged: (value) {
                                  setState(() {
                                    mostrarEnMenu = value!;
                                  });
                                }),
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: tcDecripcionMenu,
                                  validator: (value) {
                                    if (value!.trim() == '' && mostrarEnMenu) {
                                      return 'Escriba una descrpción para el menú';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    label: Text('Descripción para menú'),
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
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
                                if (resp is TokenFail) {
                                  Dialogs.error(msg: 'su sesión a expirado');
                                  _navigatorService
                                      .navigateToPageAndRemoveUntil(
                                          LoginView.routeName);
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
                              tcNewName.clear();
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
                                if (tcNewName.text.trim() != recurso.nombre ||
                                    modulo?.id != recurso.idModulo) {
                                  ProgressDialog.show(context);
                                  var resp = await _recursosApi.updateRecursos(
                                    descripcionMenuConfiguracion:
                                        tcDecripcionMenu.text.trim(),
                                    esMenuConfiguracion: mostrarEnMenu ? 1 : 0,
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
                                  if (resp is TokenFail) {
                                    Dialogs.error(msg: 'su sesión a expirado');
                                    _navigatorService
                                        .navigateToPageAndRemoveUntil(
                                            LoginView.routeName);
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
            },
          );
        });
  }

  Future<void> crearRecurso(BuildContext ctx) async {
    tcNewName.clear();
    modulo = null;
    bool mostrarEnMenu = false;
    final GlobalKey<FormState> _formKey = GlobalKey();
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
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
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
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
                                    decoration: const InputDecoration(
                                      hintText: 'Nombre del recurso',
                                      border: UnderlineInputBorder(),
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
                                      border: UnderlineInputBorder()),
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
                              CheckboxListTile(
                                  title: const Text('Mostrar en el menú'),
                                  value: mostrarEnMenu,
                                  onChanged: (value) {
                                    setState(() {
                                      mostrarEnMenu = value!;
                                    });
                                  }),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: tcDecripcionMenu,
                                    validator: (value) {
                                      if (value!.trim() == '' &&
                                          mostrarEnMenu) {
                                        return 'Escriba una descrpción para el menú';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      label: Text('Descripción para menú'),
                                      hintText: 'Descripción para menú',
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
                            onPressed: () {
                              Navigator.of(context).pop();
                              tcNewName.clear();
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
                                var resp = await _recursosApi.createRecursos(
                                  name: tcNewName.text.trim(),
                                  idModulo: modulo!.id,
                                  descripcionMenuConfiguracion:
                                      tcDecripcionMenu.text.trim(),
                                  esMenuConfiguracion: mostrarEnMenu ? 1 : 0,
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
                                if (resp is TokenFail) {
                                  Dialogs.error(msg: 'su sesión a expirado');
                                  _navigatorService
                                      .navigateToPageAndRemoveUntil(
                                          LoginView.routeName);
                                }
                                tcNewName.clear();
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
            },
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
