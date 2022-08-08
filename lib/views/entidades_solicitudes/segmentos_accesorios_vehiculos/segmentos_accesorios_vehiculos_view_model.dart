import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/segmentos_accesorios_vehiculos_api.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/segmentos_accesorios_vehiculos_response.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class SegmentosAccesoriosVehiculosViewModel extends BaseViewModel {
  final _segmentosAccesoriosVehiculosApi =
      locator<SegmentosAccesoriosVehiculosApi>();
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();
  TextEditingController tcNewDescripcion = TextEditingController();

  List<SegmentosAccesoriosVehiculosData> segmentosAccesoriosVehiculos = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late SegmentosAccesoriosVehiculosResponse
      segmentosAccesoriosVehiculosResponse;

  SegmentosAccesoriosVehiculosViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasSegmentosAccesoriosVehiculos();
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
    segmentosAccesoriosVehiculos.sort((a, b) {
      return a.descripcion.toLowerCase().compareTo(b.descripcion.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _segmentosAccesoriosVehiculosApi
        .getSegmentosAccesoriosVehiculos(pageNumber: pageNumber);
    if (resp is Success) {
      segmentosAccesoriosVehiculosResponse =
          resp.response as SegmentosAccesoriosVehiculosResponse;
      segmentosAccesoriosVehiculos = segmentosAccesoriosVehiculosResponse.data;
      ordenar();
      hasNextPage = segmentosAccesoriosVehiculosResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasSegmentosAccesoriosVehiculos() async {
    pageNumber += 1;
    var resp = await _segmentosAccesoriosVehiculosApi
        .getSegmentosAccesoriosVehiculos(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as SegmentosAccesoriosVehiculosResponse;
      segmentosAccesoriosVehiculosResponse.data.addAll(temp.data);
      segmentosAccesoriosVehiculos.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscarSegmentosAccesoriosVehiculos(String query) async {
    cargando = true;
    var resp =
        await _segmentosAccesoriosVehiculosApi.getSegmentosAccesoriosVehiculos(
      descripcion: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as SegmentosAccesoriosVehiculosResponse;
      segmentosAccesoriosVehiculos = temp.data;
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
    segmentosAccesoriosVehiculos = segmentosAccesoriosVehiculosResponse.data;
    if (segmentosAccesoriosVehiculos.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    segmentosAccesoriosVehiculos = [];
    cargando = true;
    var resp = await _segmentosAccesoriosVehiculosApi
        .getSegmentosAccesoriosVehiculos();
    if (resp is Success) {
      var temp = resp.response as SegmentosAccesoriosVehiculosResponse;
      segmentosAccesoriosVehiculosResponse = temp;
      segmentosAccesoriosVehiculos = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }

    cargando = false;
  }

  /* Future<void> modificarSegmentosAccesoriosVehiculos(BuildContext ctx,
      SegmentosAccesoriosVehiculosData componenteVehiculo) async {
    tcNewDescripcion.text = componenteVehiculo.descripcion;
    final GlobalKey<FormState> _formKey = GlobalKey();
    segmentoComponenteVehiculo = SegmentosSegmentosAccesoriosVehiculossData(
        id: componenteVehiculo.idSegmento,
        descripcion: componenteVehiculo.segmentoDescripcion);
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
                        'Modificar Componente Vehículo',
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
                            label: Text("Descripcion del Componente")),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownSearch<String>(
                      selectedItem: segmentoComponenteVehiculo!.descripcion,
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
                      items: segmentosSegmentosAccesoriosVehiculoss
                          .map((e) => e.descripcion)
                          .toList(),
                      onChanged: (value) {
                        segmentoComponenteVehiculo =
                            segmentosSegmentosAccesoriosVehiculoss.firstWhere(
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
                              tittle: 'Eliminar Componente Vehículo',
                              description:
                                  '¿Esta seguro de eliminar el componente ${componenteVehiculo.descripcion}?',
                              confirm: () async {
                            ProgressDialog.show(ctx);
                            var resp = await _SegmentosAccesoriosVehiculosApi
                                .deleteSegmentosAccesoriosVehiculos(
                                    id: componenteVehiculo.id);
                            ProgressDialog.dissmiss(ctx);
                            if (resp is Failure) {
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is Success) {
                              Dialogs.success(
                                  msg: 'Componente Vehículo eliminado');
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
                                    componenteVehiculo.descripcion) ||
                                componenteVehiculo.idSegmento !=
                                    segmentoComponenteVehiculo!.id) {
                              ProgressDialog.show(context);
                              var resp = await _SegmentosAccesoriosVehiculosApi
                                  .updateSegmentosAccesoriosVehiculos(
                                      idSegmento:
                                          segmentoComponenteVehiculo!.id,
                                      descripcion: tcNewDescripcion.text.trim(),
                                      id: componenteVehiculo.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(msg: 'Componente Actualizado');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }
                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewDescripcion.clear();
                            } else {
                              Dialogs.success(msg: 'Componente Actualizado');
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
  } */

  /* Future<void> deleteSegmentosAccesoriosVehiculos(BuildContext context,
      SegmentosAccesoriosVehiculosData componente) async {
    Dialogs.confirm(context,
        tittle: "Eliminar Vehículo Componente ${componente.descripcion}",
        description: "¿Está seguro que desea eliminar el Vehículo Componente?",
        confirm: () async {
      ProgressDialog.show(context);
      var resp = await _SegmentosAccesoriosVehiculosApi
          .deleteSegmentosAccesoriosVehiculos(id: componente.id);
      if (resp is Success<SegmentosAccesoriosVehiculosPOSTResponse>) {
        ProgressDialog.dissmiss(context);
        Dialogs.success(msg: "Eliminado con éxito");
        onInit();
      } else if (resp is Failure) {
        ProgressDialog.dissmiss(context);
        Dialogs.error(msg: resp.messages.first);
      }
    });
  } */

  /* Future<void> crearSegmentosAccesoriosVehiculos(BuildContext ctx) async {
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
                          'Crear Vehiculo Componente ',
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
                                      label: Text('Descripción del Componente'),
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
                                  items: segmentosSegmentosAccesoriosVehiculoss
                                      .map((e) => e.descripcion)
                                      .toList(),
                                  onChanged: (value) {
                                    segmentoComponenteVehiculo =
                                        segmentosSegmentosAccesoriosVehiculoss
                                            .firstWhere((element) =>
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
                                    await _SegmentosAccesoriosVehiculosApi
                                        .createSegmentosAccesoriosVehiculos(
                                            idSegmento:
                                                segmentoComponenteVehiculo!.id,
                                            descripcion:
                                                tcNewDescripcion.text.trim());
                                ProgressDialog.dissmiss(context);
                                if (resp is Success) {
                                  Dialogs.success(
                                      msg: 'Vehículo Componente  Creado');
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
  } */

  @override
  void dispose() {
    listController.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}