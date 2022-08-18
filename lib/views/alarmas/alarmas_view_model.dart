import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasaciones_app/core/api/alarmas.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/alarma_response.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/app_datetime_picker.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class AlarmasViewModel extends BaseViewModel {
  final _alarmasApi = locator<AlarmasApi>();
  final _userClient = locator<UserClient>();
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
  UsuariosData? usuario;

  AlarmasViewModel() {
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
      return a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    usuario = _userClient.loadUsuario;
    var resp = await _alarmasApi.getAlarmas(
        pageNumber: pageNumber, usuario: usuario!.email);
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
    cargando = false;
  }

  Future<void> cargarMasAlarmas() async {
    pageNumber += 1;
    var resp = await _alarmasApi.getAlarmas(pageNumber: pageNumber);
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
  }

  Future<void> buscarAlarmas(String query) async {
    cargando = true;
    var resp = await _alarmasApi.getAlarmas(
      titulo: query,
      pageSize: 0,
    );
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
    var resp = await _alarmasApi.getAlarmas();
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
    cargando = false;
  }

  Future<void> modificarAlarma(BuildContext ctx, AlarmasData adjunto) async {
    tcNewDescription.text = adjunto.descripcion;
    tcNewTitulo.text = adjunto.titulo;
    int idx = adjunto.fechaHora.indexOf("T");
    List parts = [
      adjunto.fechaHora.substring(0, idx).trim(),
      adjunto.fechaHora.substring(idx + 1).trim()
    ];
    tcNewFechaCompromiso.text = parts[0];
    tcNewHoraCompromiso.text = parts[1];
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
                          /* Navigator.pop(context);
                          Dialogs.confirm(ctx,
                              tittle: 'Eliminar Módulo',
                              description:
                                  '¿Esta seguro de eliminar el tipo adjunto ${adjunto.descripcion}?',
                              confirm: () async {
                            ProgressDialog.show(ctx);
                            var resp = await _.delete(id: modulo.id);
                            ProgressDialog.dissmiss(ctx);
                            if (resp is Failure) {
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is Success) {
                              Dialogs.success(msg: 'Módulo eliminado');
                              await onRefresh();
                            }
                          }); */
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
                            /* if (tcNewDescription.text.trim() !=
                                adjunto.descripcion) {
                              ProgressDialog.show(context);
                              var resp = await _.updateAdjunto(
                                  descripcion: tcNewDescription.text,
                                  id: adjunto.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg: 'Tipo Adjunto Actualizado');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }

                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewDescription.clear();
                            } else {
                              Dialogs.success(msg: 'Tipo Adjunto Actualizado');
                              Navigator.of(context).pop();
                            } */
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
                          /* if (_formKey.currentState!.validate()) {
                            ProgressDialog.show(context);
                            var resp = await _.createAdjunto(
                                descripcion: tcNewDescription.text.trim());
                            ProgressDialog.dissmiss(context);
                            if (resp is Success) {
                              Dialogs.success(msg: 'Tipo Adjunto Creado');
                              Navigator.of(context).pop();
                              await onRefresh();
                            }

                            if (resp is Failure) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            tcNewDescription.clear();
                            tcNewFechaCompromiso.clear();
                          tcNewHoraCompromiso.clear();
                          tcNewTitulo.clear();
                          } */
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
    tcNewFechaCompromiso.dispose();
    tcNewHoraCompromiso.dispose();
    tcNewTitulo.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
