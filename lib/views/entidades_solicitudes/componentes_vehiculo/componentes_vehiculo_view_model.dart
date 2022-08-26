import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/componentes_vehiculo_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/condiciones_componentes_vehiculo_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/segmentos_componentes_vehiculos_api.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/componentes_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/condiciones_componentes_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/segmentos_componentes_vehiculos_response.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/buscador.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/dialog_mostrar_informacion_roles.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class ComponentesVehiculoViewModel extends BaseViewModel {
  final _componentesVehiculoApi = locator<ComponentesVehiculoApi>();
  final _segmentosComponentesVehiculosApi =
      locator<SegmentosComponentesVehiculosApi>();
  final _condicionesComponenteVehiculo =
      locator<CondicionesComponentesVehiculoApi>();
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();
  TextEditingController tcNewDescripcion = TextEditingController();

  List<ComponentesVehiculoData> componentesVehiculo = [];
  List<SegmentosComponentesVehiculosData> segmentosComponentesVehiculos = [];
  List<CondicionesComponentesVehiculoData> condicionesComponenteVehiculo = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late ComponentesVehiculoResponse componentesVehiculoResponse;
  SegmentosComponentesVehiculosData? segmentoComponenteVehiculo;

  ComponentesVehiculoViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasComponentesVehiculo();
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
    componentesVehiculo.sort((a, b) {
      return a.descripcion.toLowerCase().compareTo(b.descripcion.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _componentesVehiculoApi.getComponentesVehiculo(
        pageNumber: pageNumber);
    if (resp is Success) {
      componentesVehiculoResponse =
          resp.response as ComponentesVehiculoResponse;
      componentesVehiculo = componentesVehiculoResponse.data;
      ordenar();
      hasNextPage = componentesVehiculoResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var respseg = await _segmentosComponentesVehiculosApi
        .getSegmentosComponentesVehiculos();
    if (respseg is Success) {
      var data = respseg.response as SegmentosComponentesVehiculosResponse;
      segmentosComponentesVehiculos = data.data;
    }
    if (respseg is Failure) {
      Dialogs.error(msg: respseg.messages.first);
    }
    cargando = false;
  }

  Future<void> cargarMasComponentesVehiculo() async {
    pageNumber += 1;
    var resp = await _componentesVehiculoApi.getComponentesVehiculo(
        pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as ComponentesVehiculoResponse;
      componentesVehiculoResponse.data.addAll(temp.data);
      componentesVehiculo.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscarComponentesVehiculo(String query) async {
    cargando = true;
    var resp = await _componentesVehiculoApi.getComponentesVehiculo(
      descripcion: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as ComponentesVehiculoResponse;
      componentesVehiculo = temp.data;
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
    componentesVehiculo = componentesVehiculoResponse.data;
    if (componentesVehiculo.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    componentesVehiculo = [];
    cargando = true;
    var resp = await _componentesVehiculoApi.getComponentesVehiculo();
    if (resp is Success) {
      var temp = resp.response as ComponentesVehiculoResponse;
      componentesVehiculoResponse = temp;
      componentesVehiculo = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var respseg = await _segmentosComponentesVehiculosApi
        .getSegmentosComponentesVehiculos();
    if (respseg is Success) {
      var data = respseg.response as SegmentosComponentesVehiculosResponse;
      segmentosComponentesVehiculos = data.data;
    }
    if (respseg is Failure) {
      Dialogs.error(msg: respseg.messages.first);
    }
    cargando = false;
  }

  Future<void> modificarComponentesVehiculo(
      BuildContext ctx, ComponentesVehiculoData componenteVehiculo) async {
    tcNewDescripcion.text = componenteVehiculo.descripcion;
    final GlobalKey<FormState> _formKey = GlobalKey();
    segmentoComponenteVehiculo = SegmentosComponentesVehiculosData(
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
                      items: segmentosComponentesVehiculos
                          .map((e) => e.descripcion)
                          .toList(),
                      onChanged: (value) {
                        segmentoComponenteVehiculo =
                            segmentosComponentesVehiculos.firstWhere(
                                (element) => element.descripcion == value);
                      },
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
                          List<CondicionesComponentesVehiculoData> list = [];
                          Size size = MediaQuery.of(ctx).size;
                          ProgressDialog.show(ctx);
                          var resp = await _condicionesComponenteVehiculo
                              .getCondicionesAsociadosComponentesVehiculo(
                                  idComponente: componenteVehiculo.id);
                          if (resp is Success<
                              AsociadosCondicionesComponentesVehiculoResponse>) {
                            var respcomp = await _condicionesComponenteVehiculo
                                .getCondicionesComponentesVehiculo();
                            if (respcomp is Success<
                                CondicionesComponentesVehiculoResponse>) {
                              ProgressDialog.dissmiss(context);
                              list = respcomp.response.data;
                              /* for (var element in componentes) {
                                list.add(ComponentesVehiculoSuplidorData(
                                    id: 0,
                                    componenteDescripcion: element.descripcion,
                                    estado: 0,
                                    idComponente: element.id,
                                    idSuplidor: 0,
                                    suplidorDescripcion: ""));
                              } */
                              list.sort((a, b) {
                                return a.descripcion
                                    .toLowerCase()
                                    .compareTo(b.descripcion.toLowerCase());
                              });
                              showDialog(
                                  context: ctx,
                                  builder: (BuildContext context) {
                                    List<CondicionesComponentesVehiculoData>
                                        selectedComponentes = [];
                                    for (var element in resp.response.data) {
                                      selectedComponentes.add(
                                          CondicionesComponentesVehiculoData(
                                              id: element.idCondicionParametroG,
                                              descripcion: element
                                                  .condicionDescripcion));
                                    }
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                        insetPadding: const EdgeInsets.all(15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        contentPadding: EdgeInsets.zero,
                                        content: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .75,
                                          child: dialogMostrarInformacionRoles(
                                            Container(
                                              height: size.height * .08,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                                color: AppColors.gold,
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                    "Condiciones de ${componenteVehiculo.descripcion}",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: AppColors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                            [
                                              DataTable(
                                                  onSelectAll: (isSelectedAll) {
                                                    setState(() => {
                                                          selectedComponentes =
                                                              isSelectedAll!
                                                                  ? list
                                                                      .toList()
                                                                  : [],
                                                        });
                                                  },
                                                  columns: const [
                                                    DataColumn(
                                                      label:
                                                          Text("Condiciones"),
                                                    ),
                                                  ],
                                                  rows: list
                                                      .map((e) => DataRow(
                                                              selected: selectedComponentes
                                                                  .any((element) =>
                                                                      element
                                                                          .id ==
                                                                      e.id),
                                                              onSelectChanged:
                                                                  (isSelected) =>
                                                                      setState(
                                                                          () {
                                                                        isSelected!
                                                                            ? selectedComponentes.add(
                                                                                e)
                                                                            : selectedComponentes.removeWhere((element) =>
                                                                                element.id ==
                                                                                e.id);
                                                                      }),
                                                              cells: [
                                                                DataCell(
                                                                  Text(
                                                                    e.descripcion,
                                                                  ),
                                                                  onTap: null,
                                                                ),
                                                              ]))
                                                      .toList())
                                            ],
                                            size,
                                            () async {
                                              ProgressDialog.show(context);
                                              List<int> condiciones = [];
                                              for (var element
                                                  in selectedComponentes) {
                                                condiciones.add(element.id);
                                              }
                                              var resp = await _condicionesComponenteVehiculo
                                                  .asociarComponenteVehiculoSuplidor(
                                                      idComponente:
                                                          componenteVehiculo.id,
                                                      idCondicionesComponentes:
                                                          condiciones);
                                              if (resp is Success<
                                                  CondicionesComponentesVehiculoPOSTResponse>) {
                                                ProgressDialog.dissmiss(
                                                    context);
                                                Dialogs.success(
                                                    msg:
                                                        "Actualización exitosa");
                                                Navigator.of(context).pop();
                                              } else if (resp is Failure) {
                                                ProgressDialog.dissmiss(
                                                    context);
                                                Dialogs.error(
                                                    msg: resp.messages.first);
                                              }
                                            },
                                            buscador(
                                              text: 'Buscar condiciones...',
                                              onChanged: (value) {
                                                setState(() {
                                                  list = [];
                                                  for (var element in respcomp
                                                      .response.data) {
                                                    if (element.descripcion
                                                        .toLowerCase()
                                                        .contains(value
                                                            .toLowerCase())) {
                                                      list.add(
                                                          CondicionesComponentesVehiculoData(
                                                              id: element.id,
                                                              descripcion: element
                                                                  .descripcion));
                                                    }
                                                  }
                                                  list.sort((a, b) {
                                                    return a.descripcion
                                                        .toLowerCase()
                                                        .compareTo(b.descripcion
                                                            .toLowerCase());
                                                  });
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  });
                            } else if (respcomp is Failure) {
                              ProgressDialog.dissmiss(ctx);
                              Dialogs.error(msg: respcomp.messages.first);
                            }
                          } else if (resp is Failure) {
                            ProgressDialog.dissmiss(ctx);
                            Dialogs.error(msg: resp.messages.first);
                          }
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              AppIcons.iconPlus,
                              color: AppColors.gold,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Condiciones"), // text
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
                              var resp = await _componentesVehiculoApi
                                  .updateComponentesVehiculo(
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
  }

  Future<void> crearComponentesVehiculo(BuildContext ctx) async {
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
                                  items: segmentosComponentesVehiculos
                                      .map((e) => e.descripcion)
                                      .toList(),
                                  onChanged: (value) {
                                    segmentoComponenteVehiculo =
                                        segmentosComponentesVehiculos
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
                                var resp = await _componentesVehiculoApi
                                    .createComponentesVehiculo(
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
  }

  @override
  void dispose() {
    listController.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
