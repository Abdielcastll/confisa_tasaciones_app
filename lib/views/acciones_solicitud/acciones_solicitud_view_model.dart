import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasaciones_app/core/api/acciones_solicitud_api.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/acciones_solicitud_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/app_datetime_picker.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class AccionesSolicitudViewModel extends BaseViewModel {
  final int idSolicitud;
  final _accionesSolicitudApi = locator<AccionesSolicitudApi>();
  final _userClient = locator<UserClient>();
  final listController = ScrollController();

  TextEditingController tcNewTipo = TextEditingController();
  TextEditingController tcNewComentario = TextEditingController();
  TextEditingController tcNewNotas = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<AccionesSolicitudData> accionesSolicitud = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late AccionesSolicitudResponse accionesSolicitudResponse;
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

  Future<void> onInit() async {
    cargando = true;
    usuario = _userClient.loadProfile;
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
    cargando = false;
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
    cargando = false;
  }

  Future<void> modificarAccionSolicitud(
      BuildContext ctx, AccionesSolicitudData accionSolicitud) async {
    tcNewNotas.text = accionSolicitud.notas;
    tcNewComentario.text = accionSolicitud.comentario;
    tcNewTipo.text = accionSolicitud.tipo.toString();
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
                        controller: tcNewNotas,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba una nota';
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
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewTipo,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un tipo';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Tipo"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Dialogs.confirm(ctx,
                              tittle: 'Eliminar Acción Solicitud',
                              description:
                                  '¿Esta seguro de eliminar la Acción Solicitud ${accionSolicitud.notas}?',
                              confirm: () async {
                            ProgressDialog.show(ctx);
                            var resp = await _accionesSolicitudApi
                                .deleteAccionSolicitud(id: accionSolicitud.id);
                            ProgressDialog.dissmiss(ctx);
                            if (resp is Failure) {
                              Dialogs.error(msg: resp.messages[0]);
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
                                tcNewTipo.text.trim() !=
                                    accionSolicitud.tipo.toString()) {
                              ProgressDialog.show(context);
                              var resp = await _accionesSolicitudApi
                                  .updateAccionSolicitud(
                                      comentario: tcNewComentario.text.trim(),
                                      listo: accionSolicitud.listo,
                                      notas: tcNewNotas.text.trim(),
                                      tipo: int.parse(tcNewTipo.text.trim()),
                                      id: accionSolicitud.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg: 'Tipo Acción Solicitud Actualizada');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }

                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewComentario.clear();
                              tcNewNotas.clear();
                              tcNewTipo.clear();
                            } else {
                              Dialogs.success(
                                  msg: 'Tipo Acción Solicitud Actualizada');
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
                          if (value!.trim() == '') {
                            return 'Escriba una nota';
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
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewTipo,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un tipo';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Tipo"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewComentario,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un comentario';
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
                                    tipo: int.parse(tcNewTipo.text.trim()),
                                    idSolicitud: idSolicitud);

                            if (resp is Success) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.success(
                                  msg: 'Tipo Acción Solicitud Creado');
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
