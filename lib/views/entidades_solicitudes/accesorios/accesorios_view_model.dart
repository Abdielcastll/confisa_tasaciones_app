import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/accesorios_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/segmentos_accesorios_vehiculos_api.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/accesorios_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/segmentos_accesorios_vehiculos_response.dart';
import 'package:tasaciones_app/theme/theme.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class AccesoriosViewModel extends BaseViewModel {
  final _accesoriosApi = locator<AccesoriosApi>();
  final _segmentosAccesoriosVehiculosApi =
      locator<SegmentosAccesoriosVehiculosApi>();
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();
  TextEditingController tcNewDescripcion = TextEditingController();

  List<AccesoriosData> accesorios = [];
  List<SegmentosAccesoriosVehiculosData> segmentosAccesoriosVehiculos = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late AccesoriosResponse accesoriosResponse;
  SegmentosAccesoriosVehiculosData? segmentoaccesorioVehiculo;

  AccesoriosViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasAccesorios();
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
    accesorios.sort((a, b) {
      return a.descripcion.toLowerCase().compareTo(b.descripcion.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _accesoriosApi.getAccesorios(pageNumber: pageNumber);
    if (resp is Success) {
      accesoriosResponse = resp.response as AccesoriosResponse;
      accesorios = accesoriosResponse.data;
      ordenar();
      hasNextPage = accesoriosResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var respseg = await _segmentosAccesoriosVehiculosApi
        .getSegmentosAccesoriosVehiculos();
    if (respseg is Success) {
      var data = respseg.response as SegmentosAccesoriosVehiculosResponse;
      segmentosAccesoriosVehiculos = data.data;
    }
    if (respseg is Failure) {
      Dialogs.error(msg: respseg.messages.first);
    }
    cargando = false;
  }

  Future<void> cargarMasAccesorios() async {
    pageNumber += 1;
    var resp = await _accesoriosApi.getAccesorios(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as AccesoriosResponse;
      accesoriosResponse.data.addAll(temp.data);
      accesorios.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscarAccesorios(String query) async {
    cargando = true;
    var resp = await _accesoriosApi.getAccesorios(
      descripcion: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as AccesoriosResponse;
      accesorios = temp.data;
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
    accesorios = accesoriosResponse.data;
    if (accesorios.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    accesorios = [];
    cargando = true;
    var resp = await _accesoriosApi.getAccesorios();
    if (resp is Success) {
      var temp = resp.response as AccesoriosResponse;
      accesoriosResponse = temp;
      accesorios = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var respseg = await _segmentosAccesoriosVehiculosApi
        .getSegmentosAccesoriosVehiculos();
    if (respseg is Success) {
      var data = respseg.response as SegmentosAccesoriosVehiculosResponse;
      segmentosAccesoriosVehiculos = data.data;
    }
    if (respseg is Failure) {
      Dialogs.error(msg: respseg.messages.first);
    }
    cargando = false;
  }

  Future<void> modificarAccesorios(
      BuildContext ctx, AccesoriosData accesorioVehiculo) async {
    tcNewDescripcion.text = accesorioVehiculo.descripcion;
    final GlobalKey<FormState> _formKey = GlobalKey();
    segmentoaccesorioVehiculo = SegmentosAccesoriosVehiculosData(
        id: accesorioVehiculo.idSegmento,
        descripcion: accesorioVehiculo.segmentoDescripcion);
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
                        'Modificar Accesorio Vehículo',
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
                            label: Text("Descripcion del Accesorio")),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownSearch<String>(
                      selectedItem: segmentoaccesorioVehiculo!.descripcion,
                      validator: (value) =>
                          value == null ? 'Debe escojer un segmento' : null,
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        textAlignVertical: TextAlignVertical.center,
                        dropdownSearchDecoration: InputDecoration(
                          hintText: "Segmento",
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      popupProps: const PopupProps.menu(
                          fit: FlexFit.loose,
                          showSelectedItems: true,
                          searchDelay: Duration(microseconds: 0)),
                      items: segmentosAccesoriosVehiculos
                          .map((e) => e.descripcion)
                          .toList(),
                      onChanged: (value) {
                        segmentoaccesorioVehiculo =
                            segmentosAccesoriosVehiculos.firstWhere(
                                (element) => element.descripcion == value);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Dialogs.confirm(ctx,
                              tittle: 'Eliminar Accesorio Vehículo',
                              description:
                                  '¿Esta seguro de eliminar el accesorio ${accesorioVehiculo.descripcion}?',
                              confirm: () async {
                            ProgressDialog.show(ctx);
                            var resp = await _accesoriosApi.deleteAccesorios(
                                id: accesorioVehiculo.id);
                            ProgressDialog.dissmiss(ctx);
                            if (resp is Failure) {
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is Success) {
                              Dialogs.success(
                                  msg: 'Accesorio Vehículo eliminado');
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
                                    accesorioVehiculo.descripcion) ||
                                accesorioVehiculo.idSegmento !=
                                    segmentoaccesorioVehiculo!.id) {
                              ProgressDialog.show(context);
                              var resp = await _accesoriosApi.updateAccesorios(
                                  idSegmento: segmentoaccesorioVehiculo!.id,
                                  descripcion: tcNewDescripcion.text.trim(),
                                  id: accesorioVehiculo.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(msg: 'Accesorio Actualizado');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }
                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewDescripcion.clear();
                            } else {
                              Dialogs.success(msg: 'Accesorio Actualizado');
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

  Future<void> crearAccesorios(BuildContext ctx) async {
    final GlobalKey<FormState> _formKey = GlobalKey();
    tcNewDescripcion.clear();
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
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
                          'Crear Vehiculo Accesorio',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
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
                                      isDense: true,
                                      fillColor: Colors.white,
                                      label: Text('Descripción del Accesorio'),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownSearch<String>(
                                  validator: (value) => value == null
                                      ? 'Debe escojer un segmento'
                                      : null,
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    textAlignVertical: TextAlignVertical.center,
                                    dropdownSearchDecoration: InputDecoration(
                                      hintText: "Segmento",
                                      border: UnderlineInputBorder(),
                                    ),
                                  ),
                                  popupProps: const PopupProps.menu(
                                      fit: FlexFit.loose,
                                      showSelectedItems: true,
                                      searchDelay: Duration(microseconds: 0)),
                                  items: segmentosAccesoriosVehiculos
                                      .map((e) => e.descripcion)
                                      .toList(),
                                  onChanged: (value) {
                                    segmentoaccesorioVehiculo =
                                        segmentosAccesoriosVehiculos.firstWhere(
                                            (element) =>
                                                element.descripcion == value);
                                  },
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
                                ProgressDialog.show(context);
                                var resp =
                                    await _accesoriosApi.createAccesorios(
                                        idSegmento:
                                            segmentoaccesorioVehiculo!.id,
                                        descripcion:
                                            tcNewDescripcion.text.trim());
                                ProgressDialog.dissmiss(context);
                                if (resp is Success) {
                                  Dialogs.success(
                                      msg: 'Vehículo Accesorio Creado');
                                  Navigator.of(context).pop();
                                  await onRefresh();
                                }
                                tcNewDescripcion.clear();
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
            },
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
