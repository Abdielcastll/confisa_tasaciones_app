import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_facturacion/tarifario_tasacion_api.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/tarifario_tasacion_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class TarifarioTasacionViewModel extends BaseViewModel {
  final _tarifarioTasacionApi = locator<TarifarioTasacionApi>();
  final listController = ScrollController();
  TextEditingController tcNewValor = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<TarifarioTasacionData> tarifarioTasacion = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  // bool hasNextPage = false;
  late TarifarioTasacionResponse tarifarioTasacionResponse;

  /* TarifarioTasacionViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasTarifarioTasacion();
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
    tarifarioTasacion.sort((a, b) {
      return a.valor.toLowerCase().compareTo(b.valor.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _tarifarioTasacionApi.getTarifariosTasacion(
        pageNumber: pageNumber);
    if (resp is Success) {
      tarifarioTasacionResponse = resp.response as TarifarioTasacionResponse;
      tarifarioTasacion = tarifarioTasacionResponse.data;
      ordenar();
      // hasNextPage = tarifarioTasacionResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasTarifarioTasacion() async {
    pageNumber += 1;
    var resp = await _tarifarioTasacionApi.getTarifariosTasacion(
        pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as TarifarioTasacionResponse;
      tarifarioTasacionResponse.data.addAll(temp.data);
      tarifarioTasacion.addAll(temp.data);
      ordenar();
      // hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscartarifarioTasacion(String query) async {
    cargando = true;
    var resp = await _tarifarioTasacionApi.getTarifariosTasacion(
      valor: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as TarifarioTasacionResponse;
      tarifarioTasacion = temp.data;
      ordenar();
      // hasNextPage = temp.hasNextPage;
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
    tarifarioTasacion = tarifarioTasacionResponse.data;
    // if (tarifarioTasacion.length >= 20) {
    //   hasNextPage = true;
    // }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    tarifarioTasacion = [];
    cargando = true;
    var resp = await _tarifarioTasacionApi.getTarifariosTasacion();
    if (resp is Success) {
      var temp = resp.response as TarifarioTasacionResponse;
      tarifarioTasacionResponse = temp;
      tarifarioTasacion = temp.data;
      ordenar();
      // hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> modificarTarifarioTasacion(
      BuildContext ctx, TarifarioTasacionData tarifarioTasacion) async {
    tcNewValor.text = tarifarioTasacion.valor;
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
                        'Modificar Tarifario Tasación',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                readOnly: true,
                                initialValue: tarifarioTasacion.suplidor,
                                decoration: const InputDecoration(
                                  label: Text("Suplidor"),
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
                                readOnly: true,
                                initialValue:
                                    tarifarioTasacion.descripcionTipoTasacion,
                                decoration: const InputDecoration(
                                  label: Text("Tipo de Tasación"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tcNewValor,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.trim() == '') {
                                    return 'Escriba un Valor';
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
                        ],
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
                            if (tcNewValor.text.trim() !=
                                tarifarioTasacion.valor) {
                              ProgressDialog.show(context);
                              var resp = await _tarifarioTasacionApi
                                  .updateTarifarioTasacion(
                                      valor: tcNewValor.text.trim(),
                                      idSuplidor: tarifarioTasacion.idSuplidor,
                                      idTipoTasacion:
                                          tarifarioTasacion.tipoTasacion);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg: 'Tarifario Tasación Actualizado');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }

                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewValor.clear();
                            } else {
                              Dialogs.success(
                                  msg: 'Tarifario Tasación Actualizado');
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
    tcNewValor.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
