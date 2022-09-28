import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_facturacion/corte_facturacion_api.dart';
import 'package:tasaciones_app/core/api/seguridad_facturacion/periodo_facturacion_automatica_api.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/corte_facturacion_response.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/periodo_facturacion_automatica_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class CorteFacturacionViewModel extends BaseViewModel {
  final _corteFacturacionApi = locator<CorteFacturacionApi>();
  final _periodoFacturacionAutomaticaApi =
      locator<PeriodoFacturacionAutomaticaApi>();
  final listController = ScrollController();
  TextEditingController tcNewValor = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<CorteFacturacionData> cortesFacturacion = [];
  List<PeriodoFacturacionAutomaticaData> periodosFacturacion = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  // bool hasNextPage = false;
  late CorteFacturacionResponse corteFacturacionResponse;

  /* CorteFacturacionViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasCorteFacturacion();
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
    cortesFacturacion.sort((a, b) {
      return a.suplidor.toLowerCase().compareTo(b.suplidor.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _corteFacturacionApi.getCorteFacturacion();
    if (resp is Success) {
      corteFacturacionResponse = resp.response as CorteFacturacionResponse;
      cortesFacturacion = corteFacturacionResponse.data;
      ordenar();
      // hasNextPage = CorteFacturacionResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var resp2 = await _periodoFacturacionAutomaticaApi
        .getPeriodoFacturacionAutomatica();
    if (resp2 is Success<PeriodoFacturacionAutomaticaResponse>) {
      periodosFacturacion = resp2.response.data;
      ordenar();
      // hasNextPage = CorteFacturacionResponse.hasNextPage;
      notifyListeners();
    }
    if (resp2 is Failure) {
      Dialogs.error(msg: resp2.messages[0]);
      onInit();
    }
    cargando = false;
  }

  /* Future<void> cargarMasCorteFacturacion() async {
    pageNumber += 1;
    var resp = await _CorteFacturacionApi
        .getCorteFacturacion(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as CorteFacturacionResponse;
      CorteFacturacionResponse.data.addAll(temp.data);
      CorteFacturacion.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  } */

  Future<void> buscarCorteFacturacion(String query) async {
    cargando = true;
    var resp = await _corteFacturacionApi.getCorteFacturacion(
      valor: query,
    );
    if (resp is Success) {
      var temp = resp.response as CorteFacturacionResponse;
      cortesFacturacion = temp.data;
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
    cortesFacturacion = corteFacturacionResponse.data;
    // if (cortesFacturacion.length >= 20) {
    //   hasNextPage = true;
    // }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    cortesFacturacion = [];
    cargando = true;
    var resp = await _corteFacturacionApi.getCorteFacturacion();
    if (resp is Success) {
      var temp = resp.response as CorteFacturacionResponse;
      corteFacturacionResponse = temp;
      cortesFacturacion = temp.data;
      ordenar();
      // hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> modificarCorteFacturacion(
      BuildContext ctx, CorteFacturacionData corteFacturacion) async {
    tcNewValor.text = corteFacturacion.valor;
    String periodo = periodosFacturacion
        .firstWhere((element) =>
            corteFacturacion.idSuplidor.toString() == element.idSuplidor)
        .descripcion;
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
                        'Modificar Día Corte de Facturación',
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
                                initialValue: corteFacturacion.suplidor,
                                readOnly: true,
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
                                initialValue:
                                    corteFacturacion.descripcionTipoTasacion,
                                readOnly: true,
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
                                initialValue: periodo,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  label: Text("Periodo Tasación Automática"),
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
                                  if (periodo == "Quincenal") {
                                    if (int.parse(value!) > 15 ||
                                        int.parse(value) < 1) {
                                      tcNewValor.clear();
                                      return "Día de corte mayor a 15 o menor a 1";
                                    } else {
                                      return null;
                                    }
                                  } else {
                                    if (int.parse(value!) > 31 ||
                                        int.parse(value) < 1) {
                                      tcNewValor.clear();
                                      return "Día de corte mayor a 31 o menor a 1";
                                    } else {
                                      return null;
                                    }
                                  }
                                },
                                onChanged: (value) =>
                                    _formKey.currentState!.validate(),
                                decoration: const InputDecoration(
                                  label: Text("Día de Corte"),
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
                                corteFacturacion.valor) {
                              ProgressDialog.show(context);
                              var resp = await _corteFacturacionApi
                                  .updateCorteFacturacion(
                                      valor: tcNewValor.text.trim(),
                                      idSuplidor: corteFacturacion.idSuplidor,
                                      idTipoTasacion:
                                          corteFacturacion.tipoTasacion);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg:
                                        'Día Corte de Facturación Actualizado');
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
                                  msg: 'Día Corte de Facturación Actualizado');
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
