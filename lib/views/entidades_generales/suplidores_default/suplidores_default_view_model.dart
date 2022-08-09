import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/suplidores_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/suplidores_default.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/suplidores_default_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/suplidores_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class SuplidoresDefaultViewModel extends BaseViewModel {
  final _suplidoresDefaultApi = locator<SuplidoresDefaultApi>();
  final _suplidoresApi = locator<SuplidoresApi>();
  final listController = ScrollController();
  TextEditingController tcNewValor = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<SuplidoresDefaultData> suplidoresDefault = [];
  List<SuplidorData> suplidores = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late SuplidoresDefaultResponse suplidoresDefaultResponse;
  SuplidorData? suplidor;

  SuplidoresDefaultViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasSuplidoresDefault();
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
    suplidoresDefault.sort((a, b) {
      return a.valor.toLowerCase().compareTo(b.valor.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _suplidoresDefaultApi.getSuplidoresDefault(
        pageNumber: pageNumber);
    if (resp is Success) {
      suplidoresDefaultResponse = resp.response as SuplidoresDefaultResponse;
      suplidoresDefault = suplidoresDefaultResponse.data;
      ordenar();
      hasNextPage = suplidoresDefaultResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var respsupli = await _suplidoresApi.getSuplidores();
    if (respsupli is Success) {
      var data = respsupli.response as SuplidoresResponse;
      suplidores = data.data;
    }
    if (respsupli is Failure) {
      Dialogs.error(msg: respsupli.messages.first);
    }
    cargando = false;
  }

  Future<void> cargarMasSuplidoresDefault() async {
    pageNumber += 1;
    var resp = await _suplidoresDefaultApi.getSuplidoresDefault(
        pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as SuplidoresDefaultResponse;
      suplidoresDefaultResponse.data.addAll(temp.data);
      suplidoresDefault.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscarSuplidorDefault(String query) async {
    cargando = true;
    var resp = await _suplidoresDefaultApi.getSuplidoresDefault(
      valor: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as SuplidoresDefaultResponse;
      suplidoresDefault = temp.data;
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
    suplidoresDefault = suplidoresDefaultResponse.data;
    if (suplidoresDefault.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    suplidoresDefault = [];
    cargando = true;
    var resp = await _suplidoresDefaultApi.getSuplidoresDefault();
    if (resp is Success) {
      var temp = resp.response as SuplidoresDefaultResponse;
      suplidoresDefaultResponse = temp;
      suplidoresDefault = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var respsupli = await _suplidoresApi.getSuplidores();
    if (respsupli is Success) {
      var data = respsupli.response as SuplidoresResponse;
      suplidores = data.data;
    }
    if (respsupli is Failure) {
      Dialogs.error(msg: respsupli.messages.first);
    }
    cargando = false;
  }

  Future<void> modificarSuplidorDefault(
      BuildContext ctx, SuplidoresDefaultData suplidorDefault) async {
    tcNewValor.text = suplidorDefault.valor;

    if (suplidor!.nombre !=
        suplidores
            .firstWhere((element) =>
                suplidor!.codigoRelacionado == element.codigoRelacionado)
            .nombre) {
      ProgressDialog.show(ctx);
      var resp = await _suplidoresDefaultApi.createOrUpdateSuplidoresDefault(
          valor: suplidor!.codigoRelacionado.toString(),
          codigoEntidad: suplidorDefault.codigoEntidad);
      ProgressDialog.dissmiss(ctx);
      if (resp is Success) {
        Dialogs.success(msg: 'Suplidor default Actualizado');
        Navigator.of(ctx).pop();
        await onRefresh();
      }

      if (resp is Failure) {
        ProgressDialog.dissmiss(ctx);
        Dialogs.error(msg: resp.messages[0]);
      }
      tcNewValor.clear();
    } else {
      Dialogs.success(msg: 'Suplidor default Actualizado');
      Navigator.of(ctx).pop();
    }
  }

  Future<void> crearsuplidorDefault(BuildContext ctx) async {
    tcNewValor.clear();
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
                      'Crear Suplidor Default',
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
                        controller: tcNewValor,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba un valor';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Valor"),
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
                          tcNewValor.clear();
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
                            var resp = await _suplidoresDefaultApi
                                .createOrUpdateSuplidoresDefault(
                                    codigoEntidad: "",
                                    valor: tcNewValor.text.trim());
                            ProgressDialog.dissmiss(context);
                            if (resp is Success) {
                              Dialogs.success(msg: 'Suplidor default Creado');
                              Navigator.of(context).pop();
                              await onRefresh();
                            }

                            if (resp is Failure) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            tcNewValor.clear();
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
    tcNewValor.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
