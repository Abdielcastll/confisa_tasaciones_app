import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/seguridad_entidades_generales/adjuntos.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/models/seguridad_entidades_generales/adjuntos_response.dart';
import '../../../theme/theme.dart';

class TiposAdjuntosViewModel extends BaseViewModel {
  final _adjuntosApi = locator<AdjuntosApi>();
  final _navigationService = locator<NavigatorService>();
  final listController = ScrollController();
  TextEditingController tcNewDescription = TextEditingController();
  TextEditingController tcNewPrefijo = TextEditingController();
  TextEditingController tcNewOrden = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();
  bool esFoto = false;

  List<AdjuntosData> adjuntos = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late AdjuntosResponse adjuntosResponse;

  TiposAdjuntosViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasAdjuntos();
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
    adjuntos.sort((a, b) {
      return a.descripcion.toLowerCase().compareTo(b.descripcion.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _adjuntosApi.getAdjuntos(pageNumber: pageNumber);
    if (resp is Success) {
      adjuntosResponse = resp.response as AdjuntosResponse;
      adjuntos = adjuntosResponse.data;
      ordenar();
      hasNextPage = adjuntosResponse.hasNextPage;
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

  Future<void> cargarMasAdjuntos() async {
    pageNumber += 1;
    var resp = await _adjuntosApi.getAdjuntos(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as AdjuntosResponse;
      adjuntosResponse.data.addAll(temp.data);
      adjuntos.addAll(temp.data);
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

  Future<void> buscarAdjunto(String query) async {
    cargando = true;
    var resp = await _adjuntosApi.getAdjuntos(
      descripcion: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as AdjuntosResponse;
      adjuntos = temp.data;
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
    adjuntos = adjuntosResponse.data;
    if (adjuntos.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    adjuntos = [];
    cargando = true;
    var resp = await _adjuntosApi.getAdjuntos();
    if (resp is Success) {
      var temp = resp.response as AdjuntosResponse;
      adjuntosResponse = temp;
      adjuntos = temp.data;
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

  Future<void> modificarAdjunto(BuildContext ctx, AdjuntosData adjunto) async {
    tcNewDescription.text = adjunto.descripcion;
    tcNewPrefijo.text = adjunto.prefijo;
    tcNewOrden.text = adjunto.orden.toString();
    esFoto = adjunto.esFotoVehiculo == 1 ? true : false;
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
                        'Modificar Adjunto',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewOrden,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un orden';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Orden"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    CheckboxListTile(
                        title: const Text(
                          "Foto de Vehículo",
                        ),
                        value: esFoto,
                        onChanged: (newValue) {
                          setState(() {
                            esFoto = newValue!;
                          });
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewPrefijo,
                        maxLength: 3,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un prefijo';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Prefijo"),
                          border: UnderlineInputBorder(),
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
                            tcNewOrden.clear();
                            tcNewPrefijo.clear();
                            esFoto = false;
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
                              if (tcNewDescription.text.trim() !=
                                      adjunto.descripcion ||
                                  tcNewOrden.text.trim() !=
                                      adjunto.orden.toString() ||
                                  tcNewPrefijo.text.trim() != adjunto.prefijo ||
                                  adjunto.esFotoVehiculo !=
                                      (esFoto == true ? 1 : 0)) {
                                ProgressDialog.show(context);
                                var resp = await _adjuntosApi.updateAdjunto(
                                    esFotoVehiculo: esFoto == true ? 1 : 0,
                                    orden: int.parse(tcNewOrden.text.trim()),
                                    prefijo: tcNewPrefijo.text.trim(),
                                    descripcion: tcNewDescription.text.trim(),
                                    id: adjunto.id);
                                ProgressDialog.dissmiss(context);
                                if (resp is Success) {
                                  Dialogs.success(
                                      msg: 'Tipo Adjunto Actualizado');
                                  Navigator.of(context).pop();
                                  await onRefresh();
                                  tcNewDescription.clear();
                                  tcNewOrden.clear();
                                  tcNewPrefijo.clear();
                                  esFoto = false;
                                }

                                if (resp is Failure) {
                                  ProgressDialog.dissmiss(context);
                                  Dialogs.error(msg: resp.messages[0]);
                                }
                                if (resp is TokenFail) {
                                  _navigationService
                                      .navigateToPageAndRemoveUntil(
                                          LoginView.routeName);
                                  Dialogs.error(msg: 'Sesión expirada');
                                }
                              } else {
                                Dialogs.success(
                                    msg: 'Tipo Adjunto Actualizado');
                                tcNewDescription.clear();
                                tcNewOrden.clear();
                                tcNewPrefijo.clear();
                                esFoto = false;
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

  Future<void> crearAdjunto(BuildContext ctx) async {
    tcNewDescription.clear();
    tcNewOrden.clear();
    tcNewPrefijo.clear();
    esFoto = false;
    final GlobalKey<FormState> _formKey = GlobalKey();
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: ((context, setState) {
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
                        'Crear Tipo Adjunto',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewOrden,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un orden';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Orden"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    CheckboxListTile(
                        title: const Text(
                          "Foto de Vehículo",
                        ),
                        value: esFoto,
                        onChanged: (newValue) {
                          setState(() {
                            esFoto = newValue!;
                          });
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewPrefijo,
                        maxLength: 3,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un prefijo';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Prefijo"),
                          border: UnderlineInputBorder(),
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
                            tcNewOrden.clear();
                            tcNewPrefijo.clear();
                            esFoto = false;
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
                              var resp = await _adjuntosApi.createAdjunto(
                                  orden: int.parse(tcNewOrden.text.trim()),
                                  prefijo: tcNewPrefijo.text,
                                  esFotoVehiculo: esFoto == true ? 1 : 0,
                                  descripcion: tcNewDescription.text.trim());
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(msg: 'Tipo Adjunto Creado');
                                Navigator.of(context).pop();
                                tcNewDescription.clear();
                                tcNewOrden.clear();
                                tcNewPrefijo.clear();
                                esFoto = false;
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
          }));
        });
  }

  @override
  void dispose() {
    listController.dispose();
    tcNewDescription.dispose();
    tcNewOrden.dispose();
    tcNewPrefijo.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
