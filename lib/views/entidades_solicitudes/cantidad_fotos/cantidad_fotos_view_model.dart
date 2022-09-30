import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/suplidores_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/fotos_api.dart';
import 'package:tasaciones_app/core/models/cantidad_fotos_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/suplidores_response.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class CantidadFotosViewModel extends BaseViewModel {
  final _cantidadfotosApi = locator<FotosApi>();
  final _suplidorApi = locator<SuplidoresApi>();
  final _userClient = locator<UserClient>();
  final _navigationService = locator<NavigatorService>();
  /* final _segmentosCantidadFotosVehiculosApi =
      locator<SegmentosCantidadFotosVehiculosApi>(); */
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();
  TextEditingController tcNewDescripcion = TextEditingController();

  List<SuplidorData> suplidores = [];
  EntidadData foto = EntidadData();
  EntidadData opcionesTipos = EntidadData();
  Profile? usuario;
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;

  late EntidadResponse cantidadfotosResponse;
  EntidadResponse? opcionesResponse;
  late SuplidoresResponse suplidoresResponse;
  SuplidorData? suplidor;

  /* CantidadFotosViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasCantidadFotos();
        }
      }
    });
  } */

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
    (usuario!.idSuplidor != 0 ||
            usuario!.roles!
                .any((element) => element.roleName == "AprobadorTasaciones"))
        ? {}
        : suplidores.sort((a, b) {
            return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
          });
  }

  void limpiarBusqueda() {
    _busqueda = false;
    suplidores = suplidoresResponse.data;
    if (suplidores.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> buscarSuplidor(String query) async {
    cargando = true;
    var resp = await _suplidorApi.getSuplidores(
      nombre: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as SuplidoresResponse;
      suplidores = temp.data;
      ordenar();
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

  Future<void> onInit() async {
    cargando = true;
    usuario = _userClient.loadProfile;
    if (usuario!.idSuplidor != 0 ||
        usuario!.roles!
            .any((element) => element.roleName == "AprobadorTasaciones")) {
      var resp = await _cantidadfotosApi.getCantidadFotos(
          idSuplidor: usuario!.idSuplidor);

      if (resp is Success) {
        cantidadfotosResponse = resp.response as EntidadResponse;
        foto = cantidadfotosResponse.data;
        // ordenar();
        /* hasNextPage = CantidadfotosResponse.hasNextPage; */
        notifyListeners();
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
      }
      if (resp is TokenFail) {
        _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'Sesión expirada');
      }
      var respop = await _cantidadfotosApi.getOpcionesTipos();
      if (respop is Success) {
        var data = respop.response as EntidadResponse;
        opcionesTipos = data.data;
      }
      if (respop is Failure) {
        Dialogs.error(msg: respop.messages.first);
      }
      if (resp is TokenFail) {
        _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'Sesión expirada');
      }
    } else {
      var respsupli = await _suplidorApi.getSuplidores();
      if (respsupli is Success) {
        suplidoresResponse = respsupli.response as SuplidoresResponse;
        suplidores = suplidoresResponse.data;
        ordenar();
        notifyListeners();
      }
      if (respsupli is Failure) {
        Dialogs.error(msg: respsupli.messages.first);
      }
      if (respsupli is TokenFail) {
        _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'Sesión expirada');
      }
    }

    cargando = false;
  }

  Future<void> onRefresh() async {
    foto = EntidadData();
    cargando = true;
    usuario = _userClient.loadProfile;
    if (usuario!.idSuplidor != 0 &&
        usuario!.roles!
            .any((element) => element.roleName == "AprobadorTasaciones")) {
      var resp = await _cantidadfotosApi.getCantidadFotos(
          idSuplidor: usuario!.idSuplidor);

      if (resp is Success) {
        cantidadfotosResponse = resp.response as EntidadResponse;
        foto = cantidadfotosResponse.data;
        // ordenar();
        /* hasNextPage = CantidadfotosResponse.hasNextPage; */
        notifyListeners();
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
      }
      if (resp is TokenFail) {
        _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'Sesión expirada');
      }
      var respop = await _cantidadfotosApi.getOpcionesTipos();
      if (respop is Success) {
        var data = respop.response as EntidadResponse;
        opcionesTipos = data.data;
      }
      if (respop is Failure) {
        Dialogs.error(msg: respop.messages.first);
      }
      if (resp is TokenFail) {
        _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'Sesión expirada');
      }
    } else {
      var respsupli = await _suplidorApi.getSuplidores();
      if (respsupli is Success) {
        suplidoresResponse = respsupli.response as SuplidoresResponse;
        suplidores = suplidoresResponse.data;
        ordenar();
        notifyListeners();
      }
      if (respsupli is Failure) {
        Dialogs.error(msg: respsupli.messages.first);
      }
      if (respsupli is TokenFail) {
        _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'Sesión expirada');
      }
    }

    cargando = false;
  }

  Future<void> modificarFotosSuplidor(
      BuildContext ctx, SuplidorData suplidor) async {
    Size size = MediaQuery.of(ctx).size;
    ProgressDialog.show(ctx);
    var resp = await _cantidadfotosApi.getCantidadFotos(
        idSuplidor: suplidor.codigoRelacionado);
    if (resp is Success<EntidadResponse>) {
      ProgressDialog.dissmiss(ctx);
      tcNewDescripcion.text = resp.response.data.descripcion!;
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
                          'Modificar Cantidad Foto',
                          textAlign: TextAlign.center,
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
                          controller: tcNewDescripcion,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.trim() == '') {
                              return 'Escriba una descripción';
                            } else {
                              if (int.parse(value.trim()) >= 20) {
                                return 'La cantidad de fotos no puede ser mayor a 20';
                              }
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              label: Text("Descripción")),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            tcNewDescripcion.clear();
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
                              if ((tcNewDescripcion.text.trim() !=
                                  foto.descripcion.toString())) {
                                ProgressDialog.show(context);

                                var resp =
                                    await _cantidadfotosApi.updateCantidad(
                                        descripcion: tcNewDescripcion.text,
                                        id: suplidor.codigoRelacionado);

                                ProgressDialog.dissmiss(context);
                                if (resp is Success) {
                                  Dialogs.success(
                                      msg: 'Cantidad Foto Actualizada');
                                  Navigator.of(context).pop();
                                  await onRefresh();
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
                                tcNewDescripcion.clear();
                              } else {
                                Dialogs.success(
                                    msg: 'Cantidad Foto Actualizada');
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
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(ctx);
      Dialogs.error(msg: resp.messages.first);
    }
  }

  Future<void> modificarFotosCantidad(
      BuildContext ctx, EntidadData foto) async {
    tcNewDescripcion.text = foto.descripcion!;
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
                        'Modificar Cantidad Foto',
                        textAlign: TextAlign.center,
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
                        controller: tcNewDescripcion,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba una descripción';
                          } else {
                            if (int.parse(value.trim()) >= 20) {
                              return 'La cantidad de fotos no puede ser mayor a 20';
                            }
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            label: Text("Descripción")),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewDescripcion.clear();
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
                            if ((tcNewDescripcion.text.trim() !=
                                foto.descripcion.toString())) {
                              ProgressDialog.show(context);

                              var resp = await _cantidadfotosApi.updateCantidad(
                                  descripcion: tcNewDescripcion.text,
                                  id: usuario!.idSuplidor);

                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg: 'Cantidad Foto Actualizada');
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
                              tcNewDescripcion.clear();
                            } else {
                              Dialogs.success(msg: 'Cantidad Foto Actualizada');
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

  @override
  void dispose() {
    listController.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
