import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/modulos_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/modulos_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';
import '../../auth/login/login_view.dart';

class ModulosViewModel extends BaseViewModel {
  final user = locator<AuthenticationClient>().loadSession;
  final _modulosApi = locator<ModulosApi>();
  final listController = ScrollController();
  final _navigatorService = locator<NavigatorService>();
  TextEditingController tcNewName = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<ModulosData> modulos = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late ModulosResponse modulosResponse;

  ModulosViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasModulos();
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
    modulos.sort((a, b) {
      return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _modulosApi.getModulos(pageNumber: pageNumber);
    if (resp is Success) {
      modulosResponse = resp.response as ModulosResponse;
      modulos = modulosResponse.data;
      ordenar();
      hasNextPage = modulosResponse.hasNextPage;
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

  Future<void> cargarMasModulos() async {
    pageNumber += 1;
    var resp = await _modulosApi.getModulos(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as ModulosResponse;
      modulosResponse.data.addAll(temp.data);
      modulos.addAll(temp.data);
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

  Future<void> buscarModulos(String query) async {
    cargando = true;
    var resp = await _modulosApi.getModulos(
      name: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as ModulosResponse;
      modulos = temp.data;
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
    modulos = modulosResponse.data;
    if (modulos.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    var resp = await _modulosApi.getModulos();
    if (resp is Success) {
      var temp = resp.response as ModulosResponse;
      modulosResponse = temp;
      modulos = temp.data;
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

  Future<void> modificarModulo(BuildContext ctx, ModulosData modulo) async {
    tcNewName.text = modulo.nombre;
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
                      'Modificar Módulo',
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
                        decoration: const InputDecoration(
                          label: Text("Nombre"),
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
                          Navigator.pop(context);
                          Dialogs.confirm(ctx,
                              tittle: 'Eliminar Módulo',
                              description:
                                  '¿Esta seguro de eliminar el módulo ${modulo.nombre}?',
                              confirm: () async {
                            ProgressDialog.show(ctx);
                            var resp =
                                await _modulosApi.deleteModulos(id: modulo.id);
                            ProgressDialog.dissmiss(ctx);
                            if (resp is Failure) {
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is Success) {
                              Dialogs.success(msg: 'Módulo eliminado');
                              await onRefresh();
                            }
                            if (resp is TokenFail) {
                              Dialogs.error(msg: 'su sesión a expirado');
                              _navigatorService.navigateToPageAndRemoveUntil(
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
                            if (tcNewName.text.trim() != modulo.nombre) {
                              ProgressDialog.show(context);
                              var resp = await _modulosApi.updateModulos(
                                  name: tcNewName.text, id: modulo.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(msg: 'Módulo Actualizado');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }

                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              if (resp is TokenFail) {
                                Dialogs.error(msg: 'su sesión a expirado');
                                _navigatorService.navigateToPageAndRemoveUntil(
                                    LoginView.routeName);
                              }
                              tcNewName.clear();
                            } else {
                              Dialogs.success(msg: 'Módulo Actualizado');
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

  Future<void> crearModulo(BuildContext ctx) async {
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
                      'Crear Módulo',
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
                        decoration: const InputDecoration(
                          label: Text("Nombre"),
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
                            var resp = await _modulosApi.createModulos(
                                name: tcNewName.text.trim());
                            ProgressDialog.dissmiss(context);
                            if (resp is Success) {
                              Dialogs.success(msg: 'Módulo Creado');
                              Navigator.of(context).pop();
                              await onRefresh();
                            }

                            if (resp is Failure) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is TokenFail) {
                              Dialogs.error(msg: 'su sesión a expirado');
                              _navigatorService.navigateToPageAndRemoveUntil(
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
        });
  }

  @override
  void dispose() {
    listController.dispose();
    tcBuscar.dispose();
    tcNewName.dispose();
    super.dispose();
  }
}
