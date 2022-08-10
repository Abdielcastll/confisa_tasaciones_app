import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/parametros_servidor_email_api.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/parametors_servidor_email_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class ParametrosServidorEmailViewModel extends BaseViewModel {
  final _parametrosServidorEmailApi = locator<ParametrosServidorEmailApi>();
  final listController = ScrollController();
  TextEditingController tcNewRemitente = TextEditingController();
  TextEditingController tcNewHost = TextEditingController();
  TextEditingController tcNewPuerto = TextEditingController();
  TextEditingController tcNewUsuario = TextEditingController();
  TextEditingController tcNewPassword = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<ParametrosServidorEmailData> parametrosServidorEmail = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late ParametrosServidorEmailResponse parametrosServidorEmailResponse;

  ParametrosServidorEmailViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasParametrosServidorEmail();
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
    parametrosServidorEmail.sort((a, b) {
      return a.remitente.toLowerCase().compareTo(b.remitente.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _parametrosServidorEmailApi.getParametrosServidorEmail(
        pageNumber: pageNumber);
    if (resp is Success) {
      parametrosServidorEmailResponse =
          resp.response as ParametrosServidorEmailResponse;
      parametrosServidorEmail = parametrosServidorEmailResponse.data;
      ordenar();
      hasNextPage = parametrosServidorEmailResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasParametrosServidorEmail() async {
    pageNumber += 1;
    var resp = await _parametrosServidorEmailApi.getParametrosServidorEmail(
        pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as ParametrosServidorEmailResponse;
      parametrosServidorEmailResponse.data.addAll(temp.data);
      parametrosServidorEmail.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscarParametroServidorEmail(String query) async {
    cargando = true;
    var resp = await _parametrosServidorEmailApi.getParametrosServidorEmail(
      remitente: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as ParametrosServidorEmailResponse;
      parametrosServidorEmail = temp.data;
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
    parametrosServidorEmail = parametrosServidorEmailResponse.data;
    if (parametrosServidorEmail.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    parametrosServidorEmail = [];
    cargando = true;
    var resp = await _parametrosServidorEmailApi.getParametrosServidorEmail();
    if (resp is Success) {
      var temp = resp.response as ParametrosServidorEmailResponse;
      parametrosServidorEmailResponse = temp;
      parametrosServidorEmail = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> modificarParametrosServidorEmail(BuildContext ctx,
      ParametrosServidorEmailData parametroServidorEmail) async {
    tcNewRemitente.text = parametroServidorEmail.remitente;
    tcNewHost.text = parametroServidorEmail.host;
    tcNewPassword.text = parametroServidorEmail.password;
    tcNewPuerto.text = parametroServidorEmail.puerto;
    tcNewUsuario.text = parametroServidorEmail.usuario;
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
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Modificar Servidor Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewRemitente,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un remitente';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          label: Text("Remitente"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: tcNewHost,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un host';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          label: Text("Host"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewUsuario,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un usuario';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          label: Text("Usuario"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewPassword,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba una contraseña';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          label: Text("Contraseña"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewPuerto,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un puerto';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          label: Text("Puerto"),
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
                              tittle: 'Eliminar Servidor Email',
                              description:
                                  '¿Esta seguro de eliminar el Servidor Email ${parametroServidorEmail.remitente}?',
                              confirm: () async {
                            ProgressDialog.show(ctx);
                            var resp = await _parametrosServidorEmailApi
                                .deleteParametrosServidorEmail(
                                    id: parametroServidorEmail.id);
                            ProgressDialog.dissmiss(ctx);
                            if (resp is Failure) {
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is Success) {
                              Dialogs.success(msg: 'Servidor Email eliminado');
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
                          tcNewRemitente.clear();
                          tcNewHost.clear();
                          tcNewPassword.clear();
                          tcNewPuerto.clear();
                          tcNewUsuario.clear();
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
                            if (tcNewRemitente.text.trim() !=
                                    parametroServidorEmail.remitente ||
                                tcNewHost.text.trim() !=
                                    parametroServidorEmail.host ||
                                tcNewPassword.text.trim() !=
                                    parametroServidorEmail.password ||
                                tcNewPuerto.text.trim() !=
                                    parametroServidorEmail.puerto ||
                                tcNewUsuario.text.trim() !=
                                    parametroServidorEmail.usuario) {
                              ProgressDialog.show(context);
                              var resp = await _parametrosServidorEmailApi
                                  .updateParametrosServidorEmail(
                                      host: parametroServidorEmail.host,
                                      password: parametroServidorEmail.password,
                                      puerto: parametroServidorEmail.puerto,
                                      remitente:
                                          parametroServidorEmail.remitente,
                                      usuario: parametroServidorEmail.usuario,
                                      id: parametroServidorEmail.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg:
                                        'Tipo parametroServidorEmail Actualizado');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }

                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewRemitente.clear();
                              tcNewHost.clear();
                              tcNewPassword.clear();
                              tcNewPuerto.clear();
                              tcNewUsuario.clear();
                            } else {
                              Dialogs.success(
                                  msg: 'Servidor Email Actualizado');
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

  Future<void> crearparametroServidorEmail(BuildContext ctx) async {
    tcNewRemitente.clear();
    tcNewHost.clear();
    tcNewPassword.clear();
    tcNewPuerto.clear();
    tcNewUsuario.clear();
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
                      'Crear Servidor Email',
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
                        controller: tcNewRemitente,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un remitente';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Remitente",
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewHost,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un host';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Host",
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewUsuario,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un usuario';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Usuario",
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewPassword,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba una contraseña';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewPuerto,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un puerto';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Puerto",
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
                          tcNewRemitente.clear();
                          tcNewHost.clear();
                          tcNewPassword.clear();
                          tcNewPuerto.clear();
                          tcNewUsuario.clear();
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
                            var resp = await _parametrosServidorEmailApi
                                .createParametrosServidorEmail(
                              host: tcNewHost.text.trim(),
                              password: tcNewPassword.text.trim(),
                              puerto: tcNewPuerto.text.trim(),
                              remitente: tcNewRemitente.text.trim(),
                              usuario: tcNewUsuario.text.trim(),
                            );
                            ProgressDialog.dissmiss(context);
                            if (resp is Success) {
                              Dialogs.success(
                                  msg: 'Tipo parametroServidorEmail Creado');
                              Navigator.of(context).pop();
                              await onRefresh();
                            }

                            if (resp is Failure) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            tcNewRemitente.clear();
                            tcNewHost.clear();
                            tcNewPassword.clear();
                            tcNewPuerto.clear();
                            tcNewUsuario.clear();
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
    tcNewRemitente.dispose();
    tcNewHost.dispose();
    tcNewPassword.dispose();
    tcNewPuerto.dispose();
    tcNewRemitente.dispose();
    tcNewUsuario.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
