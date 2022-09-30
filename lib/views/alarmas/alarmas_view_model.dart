import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/api/alarmas.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/alarma_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/providers/profile_permisos_provider.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/widgets/app_datetime_picker.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';
import 'package:tasaciones_app/widgets/appbar_widget.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class AlarmasViewModel extends BaseViewModel {
  final int idSolicitud;
  final Appbar appbar;
  final _alarmasApi = locator<AlarmasApi>();
  final _userClient = locator<UserClient>();
  final _navigationService = locator<NavigatorService>();
  final listController = ScrollController();
  TextEditingController tcNewDescription = TextEditingController();
  TextEditingController tcNewFechaCompromiso = TextEditingController();
  TextEditingController tcNewHoraCompromiso = TextEditingController();
  TextEditingController tcNewTitulo = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<AlarmasData> alarmas = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late AlarmasResponse alarmasResponse;
  late ProfilePermisoResponse profilePermisoResponse;
  Profile? usuario;

  AlarmasViewModel({required this.idSolicitud, required this.appbar}) {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasAlarmas();
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
    alarmas.sort((a, b) {
      return a.fechaCompromiso
          .toLowerCase()
          .compareTo(b.fechaCompromiso.toLowerCase());
    });
    alarmas = alarmas.reversed.toList();
  }

  Future<void> onInit(BuildContext context) async {
    cargando = true;
    usuario = _userClient.loadProfile;
    profilePermisoResponse =
        Provider.of<ProfilePermisosProvider>(context, listen: false)
            .profilePermisos;
    Object resp = Failure;
    if (idSolicitud == 0) {
      switch (usuario!.roles!.any((element) =>
          element.roleName == "AprobadorTasaciones" ||
          element.roleName == "Administrador")) {
        case true:
          resp = await _alarmasApi.getAlarmas(pageNumber: pageNumber);
          break;
        case false:
          resp = await _alarmasApi.getAlarmas(
              pageNumber: pageNumber, usuario: usuario!.id ?? "");
          break;
        default:
      }
    } else {
      switch (usuario!.roles!.any((element) =>
          element.roleName == "AprobadorTasaciones" ||
          element.roleName == "Administrador")) {
        case true:
          resp = await _alarmasApi.getAlarmas(
              pageNumber: pageNumber, idSolicitud: idSolicitud);
          break;
        case false:
          resp = await _alarmasApi.getAlarmas(
              pageNumber: pageNumber,
              usuario: usuario!.id ?? "",
              idSolicitud: idSolicitud);
          break;
        default:
      }
    }

    if (resp is Success) {
      alarmasResponse = resp.response as AlarmasResponse;
      alarmas = alarmasResponse.data;
      ordenar();
      hasNextPage = alarmasResponse.hasNextPage;
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

  bool tienePermiso(String permisoRequerido) {
    for (var permisoRol in profilePermisoResponse.data) {
      for (var permiso in permisoRol.permisos!) {
        if (permiso.descripcion == permisoRequerido) return true;
      }
    }
    return false;
  }

  Future<void> cargarMasAlarmas() async {
    pageNumber += 1;
    var resp = await _alarmasApi.getAlarmas(
        pageNumber: pageNumber, usuario: usuario!.id ?? "");
    if (resp is Success) {
      var temp = resp.response as AlarmasResponse;
      alarmasResponse.data.addAll(temp.data);
      alarmas.addAll(temp.data);
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

  Future<void> buscarAlarmas(String query) async {
    cargando = true;
    Object resp = Failure;
    if (idSolicitud == 0) {
      switch (usuario!.roles!.any((element) =>
          element.roleName == "AprobadorTasaciones" ||
          element.roleName == "Administrador")) {
        case true:
          resp = await _alarmasApi.getAlarmas(
              pageNumber: pageNumber, titulo: query);
          break;
        case false:
          resp = await _alarmasApi.getAlarmas(
              pageNumber: pageNumber,
              usuario: usuario!.id ?? "",
              titulo: query);
          break;
        default:
      }
    } else {
      switch (usuario!.roles!
          .any((element) => element.roleName == "AprobadorTasaciones")) {
        case true:
          resp = await _alarmasApi.getAlarmas(
              pageNumber: pageNumber, idSolicitud: idSolicitud, titulo: query);
          break;
        case false:
          resp = await _alarmasApi.getAlarmas(
              pageNumber: pageNumber,
              usuario: usuario!.id ?? "",
              idSolicitud: idSolicitud,
              titulo: query);
          break;
        default:
      }
    }
    if (resp is Success) {
      var temp = resp.response as AlarmasResponse;
      alarmas = temp.data;
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
    alarmas = alarmasResponse.data;
    if (alarmas.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    alarmas = [];
    cargando = true;
    Object resp = Failure;
    if (idSolicitud == 0) {
      switch (usuario!.roles!.any((element) =>
          element.roleName == "AprobadorTasaciones" ||
          element.roleName == "Administrador")) {
        case true:
          resp = await _alarmasApi.getAlarmas(pageNumber: pageNumber);
          break;
        case false:
          resp = await _alarmasApi.getAlarmas(
              pageNumber: pageNumber, usuario: usuario!.id ?? "");
          break;
        default:
      }
    } else {
      switch (usuario!.roles!
          .any((element) => element.roleName == "AprobadorTasaciones")) {
        case true:
          resp = await _alarmasApi.getAlarmas(
              pageNumber: pageNumber, idSolicitud: idSolicitud);
          break;
        case false:
          resp = await _alarmasApi.getAlarmas(
              pageNumber: pageNumber,
              usuario: usuario!.id ?? "",
              idSolicitud: idSolicitud);
          break;
        default:
      }
    }
    if (resp is Success) {
      var temp = resp.response as AlarmasResponse;
      alarmasResponse = temp;
      alarmas = temp.data;
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

  Future<void> modificarAlarma(BuildContext ctx, AlarmasData alarma) async {
    tcNewDescription.text = alarma.descripcion;
    tcNewTitulo.text = alarma.titulo;
    int idx = alarma.fechaHora.indexOf("T");
    List parts = [
      alarma.fechaHora.substring(0, idx).trim(),
      alarma.fechaHora.substring(idx + 1).trim()
    ];
    tcNewFechaCompromiso.text = parts[0];
    tcNewHoraCompromiso.text = parts[1];

    bool readOnly = tienePermiso("Actualizar Alarmas");
    bool eliminar = tienePermiso("Eliminar Alarmas");

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
                      'Modificar Alarma',
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
                        readOnly: !readOnly,
                        controller: tcNewTitulo,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un titulo';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Titulo",
                          label: Text("Titulo"),
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
                        keyboardType: TextInputType.datetime,
                        controller: tcNewFechaCompromiso,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Seleccione una fecha';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Fecha"),
                          suffixIcon: Icon(Icons.calendar_today),
                          border: UnderlineInputBorder(),
                        ),
                        onTap: readOnly
                            ? () async {
                                tcNewFechaCompromiso.text =
                                    await Pickers.selectDate(context);
                              }
                            : () {},
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        readOnly: true,
                        keyboardType: TextInputType.datetime,
                        controller: tcNewHoraCompromiso,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Seleccione una hora';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Hora"),
                          suffixIcon: Icon(Icons.alarm),
                          border: UnderlineInputBorder(),
                        ),
                        onTap: readOnly
                            ? () async {
                                tcNewHoraCompromiso.text =
                                    await Pickers.selectTime(context);
                              }
                            : () {},
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        readOnly: !readOnly,
                        controller: tcNewDescription,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba una descripción';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Descripción"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      eliminar
                          ? TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Dialogs.confirm(ctx,
                                    tittle: 'Eliminar Alarma',
                                    description:
                                        '¿Esta seguro de eliminar la alarma ${alarma.titulo}?',
                                    confirm: () async {
                                  ProgressDialog.show(ctx);
                                  var resp = await _alarmasApi.deleteAlarma(
                                      id: alarma.id);
                                  ProgressDialog.dissmiss(ctx);
                                  if (resp is Failure) {
                                    Dialogs.error(msg: resp.messages[0]);
                                  }
                                  if (resp is TokenFail) {
                                    _navigationService
                                        .navigateToPageAndRemoveUntil(
                                            LoginView.routeName);
                                    Dialogs.error(msg: 'Sesión expirada');
                                  }
                                  if (resp is Success) {
                                    Dialogs.success(msg: 'Alarma eliminada');
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
                            )
                          : TextButton(
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
                      eliminar
                          ? TextButton(
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
                            )
                          : const SizedBox.shrink(),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (tcNewDescription.text.trim() !=
                                    alarma.descripcion ||
                                tcNewFechaCompromiso.text.trim() +
                                        "T" +
                                        tcNewHoraCompromiso.text.trim() !=
                                    alarma.fechaCompromiso ||
                                tcNewTitulo.text.trim() != alarma.titulo) {
                              ProgressDialog.show(context);
                              var resp = await _alarmasApi.updateAlarma(
                                  correo: alarma.correo,
                                  titulo: tcNewTitulo.text.trim(),
                                  fechaCompromiso:
                                      tcNewFechaCompromiso.text.trim() +
                                          "T" +
                                          tcNewHoraCompromiso.text.trim(),
                                  descripcion: tcNewDescription.text.trim(),
                                  id: alarma.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(msg: 'Alarma Actualizada');
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
                              tcNewDescription.clear();
                            } else {
                              Dialogs.success(msg: 'Alarma Actualizada');
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

  Future<void> crearAlarmas(BuildContext ctx) async {
    tcNewDescription.clear();
    tcNewFechaCompromiso.clear();
    tcNewHoraCompromiso.clear();
    tcNewTitulo.clear();
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
                      'Crear Alarma',
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
                        controller: tcNewTitulo,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un titulo';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Titulo",
                          label: Text("Titulo"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        controller: tcNewFechaCompromiso,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Seleccione una fecha';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Fecha"),
                          suffixIcon: Icon(Icons.calendar_today),
                          border: UnderlineInputBorder(),
                        ),
                        onTap: () async {
                          tcNewFechaCompromiso.text =
                              await Pickers.selectDate(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        controller: tcNewHoraCompromiso,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Seleccione una hora';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Hora"),
                          suffixIcon: Icon(Icons.alarm),
                          border: UnderlineInputBorder(),
                        ),
                        onTap: () async {
                          tcNewHoraCompromiso.text =
                              await Pickers.selectTime(context);
                        },
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
                        maxLines: 5,
                        decoration: const InputDecoration(
                          label: Text("Descripción"),
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
                          tcNewDescription.clear();
                          tcNewFechaCompromiso.clear();
                          tcNewHoraCompromiso.clear();
                          tcNewTitulo.clear();
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
                            var resp = await _alarmasApi.createAlarma(
                                correo: usuario!.email!,
                                fechaCompromiso:
                                    tcNewFechaCompromiso.text.trim() +
                                        "T" +
                                        tcNewHoraCompromiso.text.trim(),
                                titulo: tcNewTitulo.text.trim(),
                                idSolicitud: idSolicitud,
                                descripcion: tcNewDescription.text.trim());

                            if (resp is Success) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.success(msg: 'Alarma Creada');
                              Navigator.of(context).pop();
                              await onRefresh();
                              tcNewDescription.clear();
                              tcNewFechaCompromiso.clear();
                              tcNewHoraCompromiso.clear();
                              tcNewTitulo.clear();
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
  Future<void> dispose() async {
    await appbar.getAlarmas;
    listController.dispose();
    tcNewDescription.dispose();
    tcNewFechaCompromiso.dispose();
    tcNewHoraCompromiso.dispose();
    tcNewTitulo.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
