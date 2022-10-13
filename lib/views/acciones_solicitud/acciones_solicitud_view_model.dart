import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/api/acciones_solicitud_api.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/acciones_solicitud_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/providers/profile_permisos_provider.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class AccionesSolicitudViewModel extends BaseViewModel {
  final int idSolicitud;
  final _accionesSolicitudApi = locator<AccionesSolicitudApi>();
  final _userClient = locator<UserClient>();
  final listController = ScrollController();
  final _navigationService = locator<NavigatorService>();

  TextEditingController tcNewTipo = TextEditingController();
  TextEditingController tcNewComentario = TextEditingController();
  TextEditingController tcNewNotas = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<AccionesSolicitudData> accionesSolicitud = [];
  List<TipoAccionesSolicitudData> tipoAccionesSolicitud = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;

  late TipoAccionesSolicitudData tipoAccionSeleccionada;
  late AccionesSolicitudResponse accionesSolicitudResponse;
  late TipoAccionesSolicitudResponse tipoAccionesSolicitudResponse;
  late ProfilePermisoResponse profilePermisoResponse;
  Profile? usuario;

  AccionesSolicitudViewModel({required this.idSolicitud}) {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasAccionesSolicitud();
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
    accionesSolicitud.sort((a, b) {
      return a.fechaHora.toLowerCase().compareTo(b.fechaHora.toLowerCase());
    });
    accionesSolicitud = accionesSolicitud.reversed.toList();
  }

  String formatFecha(String fecha) {
    var temp = DateTime.tryParse(fecha);

    String r = temp!.day.toString() +
        "-" +
        DateFormat.MMM().format(temp) +
        "-" +
        temp.year.toString();
    r = r.replaceAll("Jan", "Ene");
    r = r.replaceAll("Apr", "Abr");
    r = r.replaceAll("Aug", "Ago");
    r = r.replaceAll("Apr", "Abr");
    r = r.replaceAll("Dec", "Dic");
    return r;
  }

  Future<void> onInit(BuildContext context) async {
    cargando = true;
    usuario = _userClient.loadProfile;

    profilePermisoResponse =
        Provider.of<ProfilePermisosProvider>(context, listen: false)
            .profilePermisos;
    Object resp = Failure;
    if (idSolicitud == 0) {
      switch (usuario!.roles!
          .any((element) => element.roleName == "AprobadorTasaciones")) {
        case true:
          resp = await _accionesSolicitudApi.getAccionesSolicitud(
              pageNumber: pageNumber);
          break;
        case false:
          resp = await _accionesSolicitudApi.getAccionesSolicitud(
              pageNumber: pageNumber);
          break;
        default:
      }
    } else {
      switch (usuario!.roles!
          .any((element) => element.roleName == "AprobadorTasaciones")) {
        case true:
          resp = await _accionesSolicitudApi.getAccionesSolicitud(
              pageNumber: pageNumber, idSolicitud: idSolicitud);
          break;
        case false:
          resp = await _accionesSolicitudApi.getAccionesSolicitud(
              pageNumber: pageNumber, idSolicitud: idSolicitud);
          break;
        default:
      }
    }

    if (resp is Success) {
      accionesSolicitudResponse = resp.response as AccionesSolicitudResponse;
      accionesSolicitud = accionesSolicitudResponse.data;
      ordenar();
      hasNextPage = accionesSolicitudResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    var resp2 = await _accionesSolicitudApi.getTiposAccionesSolicitud();
    if (resp2 is Success) {
      tipoAccionesSolicitudResponse =
          resp2.response as TipoAccionesSolicitudResponse;
      tipoAccionesSolicitud = tipoAccionesSolicitudResponse.data;
      notifyListeners();
    }
    if (resp2 is Failure) {
      Dialogs.error(msg: resp2.messages[0]);
    }
    if (resp2 is TokenFail) {
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

  Future<void> cargarMasAccionesSolicitud() async {
    pageNumber += 1;
    var resp = await _accionesSolicitudApi.getAccionesSolicitud(
        pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as AccionesSolicitudResponse;
      accionesSolicitudResponse.data.addAll(temp.data);
      accionesSolicitud.addAll(temp.data);
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

  Future<void> buscarAccionesSolicitud(String query) async {
    cargando = true;
    Object resp = Failure;
    if (idSolicitud == 0) {
      switch (usuario!.roles!
          .any((element) => element.roleName == "AprobadorTasaciones")) {
        case true:
          resp = await _accionesSolicitudApi.getAccionesSolicitud(
              pageNumber: pageNumber, notas: query);
          break;
        case false:
          resp = await _accionesSolicitudApi.getAccionesSolicitud(
              pageNumber: pageNumber, notas: query);
          break;
        default:
      }
    } else {
      switch (usuario!.roles!
          .any((element) => element.roleName == "AprobadorTasaciones")) {
        case true:
          resp = await _accionesSolicitudApi.getAccionesSolicitud(
              pageNumber: pageNumber, idSolicitud: idSolicitud, notas: query);
          break;
        case false:
          resp = await _accionesSolicitudApi.getAccionesSolicitud(
              pageNumber: pageNumber, idSolicitud: idSolicitud, notas: query);
          break;
        default:
      }
    }
    if (resp is Success) {
      var temp = resp.response as AccionesSolicitudResponse;
      accionesSolicitud = temp.data;
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
    accionesSolicitud = accionesSolicitudResponse.data;
    if (accionesSolicitud.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    accionesSolicitud = [];
    cargando = true;
    Object resp = Failure;
    if (idSolicitud == 0) {
      switch (usuario!.roles!
          .any((element) => element.roleName == "AprobadorTasaciones")) {
        case true:
          resp = await _accionesSolicitudApi.getAccionesSolicitud(
              pageNumber: pageNumber);
          break;
        case false:
          resp = await _accionesSolicitudApi.getAccionesSolicitud(
              pageNumber: pageNumber);
          break;
        default:
      }
    } else {
      switch (usuario!.roles!
          .any((element) => element.roleName == "AprobadorTasaciones")) {
        case true:
          resp = await _accionesSolicitudApi.getAccionesSolicitud(
              pageNumber: pageNumber, idSolicitud: idSolicitud);
          break;
        case false:
          resp = await _accionesSolicitudApi.getAccionesSolicitud(
              pageNumber: pageNumber, idSolicitud: idSolicitud);
          break;
        default:
      }
    }
    if (resp is Success) {
      var temp = resp.response as AccionesSolicitudResponse;
      accionesSolicitudResponse = temp;
      accionesSolicitud = temp.data;
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

  Future<void> modificarAccionSolicitud(
      BuildContext ctx, AccionesSolicitudData accionSolicitud) async {
    tcNewNotas.text = accionSolicitud.notas;
    tcNewComentario.text = accionSolicitud.comentario;
    tcNewTipo.text = accionSolicitud.tipo.toString();

    bool readOnly = tienePermiso("Actualizar AccionesPendientes");
    bool eliminar = tienePermiso("Eliminar AccionesPendientes");

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
                      'Modificar Acción Solicitud',
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
                        controller: tcNewNotas,
                        validator: (value) {
                          if (value!.trim() == '' || value.length > 1500) {
                            return 'Escriba una nota válida';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Nota"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownSearch<String>(
                      selectedItem: tipoAccionesSolicitud
                          .firstWhere(
                              (element) => accionSolicitud.tipo == element.id)
                          .descripcion,
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              label: Text("Tipo Acción Solicitud"))),
                      validator: (value) => value == null
                          ? 'Debe escojer un tipo acción solicitud'
                          : null,
                      popupProps: const PopupProps.menu(
                          fit: FlexFit.loose,
                          showSelectedItems: true,
                          searchDelay: Duration(microseconds: 0)),
                      items: tipoAccionesSolicitud
                          .map((e) => e.descripcion)
                          .toList(),
                      onChanged: (newValue) {
                        tipoAccionSeleccionada =
                            tipoAccionesSolicitud.firstWhere(
                                (element) => element.descripcion == newValue);
                      },
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        readOnly: !readOnly,
                        controller: tcNewComentario,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un comentario';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Comentario"),
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
                            accionSolicitud.listo ? "Listo" : "Pendiente",
                        readOnly: true,
                        decoration: const InputDecoration(
                          label: Text("¿Listo?"),
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
                        initialValue: formatFecha(
                            accionSolicitud.fechaHora.split("T").first),
                        decoration: const InputDecoration(
                          label: Text("Fecha"),
                          suffixIcon: Icon(Icons.calendar_today),
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
                        initialValue: DateFormat("h:mma")
                            .format(DateTime.parse(accionSolicitud.fechaHora)),
                        decoration: const InputDecoration(
                          label: Text("Hora"),
                          suffixIcon: Icon(Icons.alarm),
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
                                Dialogs.confirm(ctx,
                                    tittle: 'Eliminar Acción Solicitud',
                                    description:
                                        '¿Esta seguro de eliminar la Acción Solicitud ${accionSolicitud.notas}?',
                                    confirm: () async {
                                  ProgressDialog.show(ctx);
                                  var resp = await _accionesSolicitudApi
                                      .deleteAccionSolicitud(
                                          id: accionSolicitud.id);
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
                                    Navigator.pop(context);
                                    Dialogs.success(
                                        msg: 'Acción Solicitud eliminada');
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
                          : const SizedBox(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Dialogs.confirm(ctx,
                              tittle:
                                  "Colocar como ${accionSolicitud.listo ? "Pendiente" : "Listo"}",
                              description:
                                  '¿Esta seguro de colocar como ${accionSolicitud.listo ? "pendiente" : "listo"} la acción pendiente ${accionSolicitud.notas}?',
                              confirm: () async {
                            ProgressDialog.show(ctx);
                            var resp = await _accionesSolicitudApi
                                .updateAccionSolicitud(
                                    id: accionSolicitud.id,
                                    tipo: accionSolicitud.tipo,
                                    notas: accionSolicitud.notas,
                                    listo: !accionSolicitud.listo,
                                    comentario: accionSolicitud.comentario);
                            ProgressDialog.dissmiss(ctx);
                            if (resp is Failure) {
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is Success) {
                              Dialogs.success(msg: 'Modificado con éxito');
                              await onRefresh();
                            }
                            if (resp is TokenFail) {
                              Dialogs.error(msg: 'Su sesión a expirado');
                              _navigationService.navigateToPageAndRemoveUntil(
                                  LoginView.routeName);
                            }
                          });
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              accionSolicitud.listo
                                  ? Icons.lock_clock_sharp
                                  : AppIcons.checkCircle,
                              color: AppColors.grey,
                            ),
                            const SizedBox(
                              height: 3,
                            ), // icon
                            Text(accionSolicitud.listo
                                ? "Pendiente"
                                : "Listo"), // text
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewComentario.clear();
                          tcNewNotas.clear();
                          tcNewTipo.clear();
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
                            if (tcNewNotas.text.trim() !=
                                    accionSolicitud.notas ||
                                tcNewComentario.text.trim() !=
                                    accionSolicitud.comentario ||
                                tipoAccionSeleccionada.id !=
                                    accionSolicitud.tipo) {
                              ProgressDialog.show(context);
                              var resp = await _accionesSolicitudApi
                                  .updateAccionSolicitud(
                                      comentario: tcNewComentario.text.trim(),
                                      listo: accionSolicitud.listo,
                                      notas: tcNewNotas.text.trim(),
                                      tipo: tipoAccionSeleccionada.id,
                                      id: accionSolicitud.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg: 'Acción Solicitud Actualizada');
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
                              tcNewComentario.clear();
                              tcNewNotas.clear();
                              tcNewTipo.clear();
                            } else {
                              Dialogs.success(
                                  msg: 'Acción Solicitud Actualizada');
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

  Future<void> crearAccionesSolicitud(BuildContext ctx) async {
    tcNewComentario.clear();
    tcNewNotas.clear();
    tcNewTipo.clear();
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
                      'Crear Acción Solicitud',
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
                        controller: tcNewNotas,
                        validator: (value) {
                          if (value!.trim() == '' || value.length > 1500) {
                            return 'Escriba una nota válida';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Nota"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownSearch<String>(
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              label: Text("Tipo Acción Solicitud"))),
                      validator: (value) => value == null
                          ? 'Debe escojer un tipo acción solicitud'
                          : null,
                      popupProps: const PopupProps.menu(
                          fit: FlexFit.loose,
                          showSelectedItems: true,
                          searchDelay: Duration(microseconds: 0)),
                      items: tipoAccionesSolicitud
                          .map((e) => e.descripcion)
                          .toList(),
                      onChanged: (newValue) {
                        tipoAccionSeleccionada =
                            tipoAccionesSolicitud.firstWhere(
                                (element) => element.descripcion == newValue);
                      },
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewComentario,
                        validator: (value) {
                          if (value!.trim() == '' || value.length > 1500) {
                            return 'Escriba un comentario válido';
                          } else {
                            return null;
                          }
                        },
                        maxLines: 5,
                        decoration: const InputDecoration(
                          label: Text("Comentario"),
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
                          tcNewComentario.clear();
                          tcNewNotas.clear();
                          tcNewTipo.clear();
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
                            var resp = await _accionesSolicitudApi
                                .createAccionSolicitud(
                                    comentario: tcNewComentario.text.trim(),
                                    notas: tcNewNotas.text.trim(),
                                    tipo: tipoAccionSeleccionada.id,
                                    idSolicitud: idSolicitud);

                            if (resp is Success) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.success(msg: 'Acción Solicitud Creada');
                              Navigator.of(context).pop();
                              await onRefresh();
                              tcNewComentario.clear();
                              tcNewNotas.clear();
                              tcNewTipo.clear();
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
  void dispose() {
    listController.dispose();
    tcNewComentario.dispose();
    tcNewNotas.dispose();
    tcNewTipo.dispose();
    super.dispose();
  }
}
