import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/periodo_tasacion_promedio_api.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/periodo_tasacion_promedio_response.dart';
import 'package:tasaciones_app/theme/theme.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class PeriodoTasacionPromedioViewModel extends BaseViewModel {
  final _periodoTasacionPromedioApi = locator<PeriodoTasacionPromedioApi>();
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();
  TextEditingController tcNewDescripcion = TextEditingController();

  List<PeriodoTasacionPromedioData> periodoTasacionPromedio = [];
  List<OpcionesPeriodoTasacionPromedioData> opcionesPeriodoTasacionPromedio =
      [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late PeriodoTasacionPromedioResponse periodoTasacionPromedioResponse;
  OpcionesPeriodoTasacionPromedioData? opcionPeriodoTasacionPromedioData;

  PeriodoTasacionPromedioViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasPeriodoTasacionPromedio();
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
    periodoTasacionPromedio.sort((a, b) {
      return a.description.toLowerCase().compareTo(b.description.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _periodoTasacionPromedioApi.getPeriodoTasacionPromedio(
        pageNumber: pageNumber);
    if (resp is Success) {
      periodoTasacionPromedioResponse =
          resp.response as PeriodoTasacionPromedioResponse;
      periodoTasacionPromedio = periodoTasacionPromedioResponse.data;
      ordenar();
      hasNextPage = periodoTasacionPromedioResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var respopc =
        await _periodoTasacionPromedioApi.getOpcionesPeriodoTasacionPromedio();
    if (respopc is Success) {
      var resp = respopc.response as OpcionesPeriodoTasacionPromedioResponse;
      opcionPeriodoTasacionPromedioData = resp.data;
      notifyListeners();
    }
    if (respopc is Failure) {
      Dialogs.error(msg: respopc.messages.first);
    }
    cargando = false;
  }

  Future<void> cargarMasPeriodoTasacionPromedio() async {
    pageNumber += 1;
    var resp = await _periodoTasacionPromedioApi.getPeriodoTasacionPromedio(
        pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as PeriodoTasacionPromedioResponse;
      periodoTasacionPromedioResponse.data.addAll(temp.data);
      periodoTasacionPromedio.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  /* Future<void> buscarPeriodoTasacionPromedio(String query) async {
    cargando = true;
    var resp =
        await _periodoTasacionPromedioApi.getPeriodoTasacionPromedio(
      descripcion: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as PeriodoTasacionPromedioResponse;
      PeriodoTasacionPromedio = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      _busqueda = true;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  } */

  /* void limpiarBusqueda() {
    _busqueda = false;
    PeriodoTasacionPromedio = PeriodoTasacionPromedioResponse.data;
    if (PeriodoTasacionPromedio.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  } */

  Future<void> onRefresh() async {
    periodoTasacionPromedio = [];
    cargando = true;
    var resp = await _periodoTasacionPromedioApi.getPeriodoTasacionPromedio();
    if (resp is Success) {
      var temp = resp.response as PeriodoTasacionPromedioResponse;
      periodoTasacionPromedioResponse = temp;
      periodoTasacionPromedio = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var respopc =
        await _periodoTasacionPromedioApi.getOpcionesPeriodoTasacionPromedio();
    if (respopc is Success) {
      var resp = respopc.response as OpcionesPeriodoTasacionPromedioResponse;
      opcionPeriodoTasacionPromedioData = resp.data;
      notifyListeners();
    }
    if (respopc is Failure) {
      Dialogs.error(msg: respopc.messages.first);
    }
    cargando = false;
  }

  Future<void> modificarPeriodoTasacionPromedio(BuildContext ctx,
      PeriodoTasacionPromedioData periodoTasacionPromedio) async {
    tcNewDescripcion.text = periodoTasacionPromedio.description;
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
                        'Modificar Período Tasación Promedio',
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
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba una descripción';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            label: Text("Descripcion")),
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
                                periodoTasacionPromedio.description)) {
                              ProgressDialog.show(context);
                              var resp = await _periodoTasacionPromedioApi
                                  .updatePeriodoTasacionPromedio(
                                      descripcion: tcNewDescripcion.text.trim(),
                                      id: periodoTasacionPromedio.value);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg:
                                        'Período Tasación Promedio Actualizado');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }
                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewDescripcion.clear();
                            } else {
                              Dialogs.success(
                                  msg: 'Período Tasación Promedio Actualizado');
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
