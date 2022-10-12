import 'package:dropdown_search/dropdown_search.dart';
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
  TextEditingController tcNewCssIcon = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<ModulosData> modulos = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  int idModuloPadre = 0;
  bool tieneModuloPadre = false;
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
    idModuloPadre = 0;
    tieneModuloPadre = false;
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
    tcNewCssIcon.text = modulo.cssIcon;
    tieneModuloPadre = modulo.moduloPadre == 0 ? false : true;
    idModuloPadre = modulo.moduloPadre == 0 ? 0 : modulo.moduloPadre;
    final GlobalKey<FormState> _formKey = GlobalKey();
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
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
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: tcNewCssIcon,
                          decoration: const InputDecoration(
                            label: Text("Css Icon"),
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    CheckboxListTile(
                        title: const Text('¿Módulo Padre?'),
                        value: tieneModuloPadre,
                        onChanged: (value) {
                          setState(() {
                            tieneModuloPadre = value!;
                          });
                        }),
                    tieneModuloPadre
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<String>(
                              selectedItem: tieneModuloPadre
                                  ? modulos
                                      .firstWhere((element) =>
                                          element.id == modulo.moduloPadre)
                                      .nombre
                                  : "",
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          label: Text("Módulo Padre"))),
                              validator: (value) => value == null
                                  ? tieneModuloPadre
                                      ? 'Debe escojer un módulo padre o seleccionar ninguno'
                                      : null
                                  : null,
                              popupProps: const PopupProps.menu(
                                  fit: FlexFit.loose,
                                  showSelectedItems: true,
                                  searchDelay: Duration(microseconds: 0)),
                              items: modulos.map((e) => e.nombre).toList(),
                              onChanged: (newValue) {
                                idModuloPadre = modulos
                                    .firstWhere(
                                        (element) => element.nombre == newValue)
                                    .id;
                              },
                            ),
                          )
                        : const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Dialogs.confirm(ctx,
                                tittle:
                                    '${modulo.estado == 1 ? "Inactivar" : "Activar"} Módulo',
                                description:
                                    '¿Esta seguro de ${modulo.estado == 1 ? "inactivar" : "activar"} el módulo ${modulo.nombre}?',
                                confirm: () async {
                              if (modulo.estado == 0) {
                                cargando = true;
                                var resp = await _modulosApi.updateModulos(
                                    cssIcon: modulo.cssIcon,
                                    estado: 1,
                                    moduloPadre: modulo.moduloPadre,
                                    name: modulo.nombre,
                                    id: modulo.id);
                                if (resp is Success) {
                                  Dialogs.success(
                                      msg: 'Estado modificado con éxito');
                                  await onRefresh();
                                }

                                if (resp is Failure) {
                                  Dialogs.error(msg: resp.messages[0]);
                                }
                                if (resp is TokenFail) {
                                  Dialogs.error(msg: 'su sesión a expirado');
                                  _navigatorService
                                      .navigateToPageAndRemoveUntil(
                                          LoginView.routeName);
                                }
                                cargando = false;
                              } else if (modulo.estado == 1) {
                                cargando = true;
                                var resp = await _modulosApi.deleteModulos(
                                    id: modulo.id);
                                if (resp is Failure) {
                                  Dialogs.error(msg: resp.messages[0]);
                                }
                                if (resp is Success) {
                                  Dialogs.success(
                                      msg: 'Estado modificado con éxito');
                                  await onRefresh();
                                }
                                if (resp is TokenFail) {
                                  Dialogs.error(msg: 'Su sesión a expirado');
                                  _navigatorService
                                      .navigateToPageAndRemoveUntil(
                                          LoginView.routeName);
                                }
                                cargando = false;
                              }
                            });
                          }, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                modulo.estado == 1
                                    ? AppIcons.uncheckCircle
                                    : AppIcons.checkCircle,
                                color: AppColors.grey,
                              ),
                              const SizedBox(
                                height: 3,
                              ), // icon
                              Text(modulo.estado == 1
                                  ? "Inactivar"
                                  : "Activar"), // text
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            tcNewName.clear();
                            tcNewCssIcon.clear();
                            idModuloPadre = 0;
                            tieneModuloPadre = false;
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
                              if (tcNewName.text.trim() != modulo.nombre ||
                                  idModuloPadre != modulo.moduloPadre ||
                                  tieneModuloPadre == false ||
                                  modulo.cssIcon != tcNewCssIcon.text.trim()) {
                                ProgressDialog.show(context);
                                var resp = await _modulosApi.updateModulos(
                                    cssIcon: tcNewCssIcon.text.isEmpty
                                        ? ""
                                        : tcNewCssIcon.text.trim(),
                                    estado: modulo.estado,
                                    moduloPadre:
                                        tieneModuloPadre ? idModuloPadre : 0,
                                    name: tcNewName.text,
                                    id: modulo.id);
                                ProgressDialog.dissmiss(context);
                                if (resp is Success) {
                                  tcNewName.clear();
                                  tcNewCssIcon.clear();
                                  idModuloPadre = 0;
                                  tieneModuloPadre = false;
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
                                  _navigatorService
                                      .navigateToPageAndRemoveUntil(
                                          LoginView.routeName);
                                }
                              } else {
                                tcNewName.clear();
                                tcNewCssIcon.clear();
                                idModuloPadre = 0;
                                tieneModuloPadre = false;
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
        });
  }

  Future<void> crearModulo(BuildContext ctx) async {
    tcNewName.clear();
    tcNewCssIcon.clear();
    idModuloPadre = 0;
    tieneModuloPadre = false;
    final GlobalKey<FormState> _formKey = GlobalKey();
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
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
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: tcNewCssIcon,
                          decoration: const InputDecoration(
                            label: Text("Css Icon"),
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    CheckboxListTile(
                        title: const Text('¿Módulo Padre?'),
                        value: tieneModuloPadre,
                        onChanged: (value) {
                          setState(() {
                            tieneModuloPadre = value!;
                          });
                        }),
                    tieneModuloPadre
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<String>(
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          label: Text("Módulo Padre"))),
                              validator: (value) => value == null
                                  ? tieneModuloPadre
                                      ? 'Debe escojer un módulo padre o seleccionar ninguno'
                                      : null
                                  : null,
                              popupProps: const PopupProps.menu(
                                  fit: FlexFit.loose,
                                  showSelectedItems: true,
                                  searchDelay: Duration(microseconds: 0)),
                              items: modulos.map((e) => e.nombre).toList(),
                              onChanged: (newValue) {
                                idModuloPadre = modulos
                                    .firstWhere(
                                        (element) => element.nombre == newValue)
                                    .id;
                              },
                            ),
                          )
                        : const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            tcNewName.clear();
                            tcNewCssIcon.clear();
                            idModuloPadre = 0;
                            tieneModuloPadre = false;
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
                                  cssIcon: tcNewCssIcon.text.isEmpty
                                      ? ""
                                      : tcNewCssIcon.text.trim(),
                                  idModuloPadre:
                                      tieneModuloPadre ? idModuloPadre : 0,
                                  name: tcNewName.text.trim());
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(msg: 'Módulo Creado');
                                Navigator.of(context).pop();
                                tcNewName.clear();
                                tcNewCssIcon.clear();
                                idModuloPadre = 0;
                                tieneModuloPadre = false;
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
        });
  }

  @override
  void dispose() {
    listController.dispose();
    tcBuscar.dispose();
    tcNewName.dispose();
    idModuloPadre = 0;
    tieneModuloPadre = false;
    super.dispose();
  }
}
