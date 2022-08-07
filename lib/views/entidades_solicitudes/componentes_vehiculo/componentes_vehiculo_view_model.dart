import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/componentes_vehiculo_api.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/componentes_vehiculo.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class ComponentesVehiculoViewModel extends BaseViewModel {
  final _componentesVehiculoApi = locator<ComponentesVehiculoApi>();
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();

  List<ComponentesVehiculoData> componentesVehiculo = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late ComponentesVehiculoResponse componentesVehiculoResponse;

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
    cargando = false;
  }

  /* Future<void> modificarAdjunto(BuildContext ctx, AdjuntosData adjunto) async {
    tcNewDescription.text = adjunto.descripcion;
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /* TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Dialogs.confirm(ctx,
                              tittle: 'Eliminar Módulo',
                              description:
                                  '¿Esta seguro de eliminar el tipo adjunto ${adjunto.descripcion}?',
                              confirm: () async {
                            ProgressDialog.show(ctx);
                            var resp =
                                await _adjuntosApi.delete(id: modulo.id);
                            ProgressDialog.dissmiss(ctx);
                            if (resp is Failure) {
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is Success) {
                              Dialogs.success(msg: 'Módulo eliminado');
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
                      ), */
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewDescription.clear();
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
                                adjunto.descripcion) {
                              ProgressDialog.show(context);
                              var resp = await _adjuntosApi.updateAdjunto(
                                  descripcion: tcNewDescription.text,
                                  id: adjunto.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg: 'Tipo Adjunto Actualizado');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }

                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewDescription.clear();
                            } else {
                              Dialogs.success(msg: 'Tipo Adjunto Actualizado');
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

  Future<void> deleteComponentesVehiculo(
      BuildContext context, ComponentesVehiculoData componente) async {
    Dialogs.confirm(context,
        tittle: "Eliminar Vehículo Componente ${componente.descripcion}",
        description: "¿Está seguro que desea eliminar el Vehículo Componente?",
        confirm: () async {
      ProgressDialog.show(context);
      var resp = await _componentesVehiculoApi.deleteComponentesVehiculo(
          id: componente.id);
      if (resp is Success<ComponentesVehiculoPOSTResponse>) {
        ProgressDialog.dissmiss(context);
        Dialogs.success(msg: "Eliminado con éxito");
        onInit();
      } else if (resp is Failure) {
        ProgressDialog.dissmiss(context);
        Dialogs.error(msg: resp.messages.first);
      }
    });
  }

  Future<void> crearComponentesVehiculo(BuildContext ctx) async {
    /* final GlobalKey<FormState> _formKey = GlobalKey();
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownSearch<String>(
                                  validator: (value) => value == null
                                      ? 'Debe escojer un componente'
                                      : null,
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      hintText: "Componente",
                                      border: UnderlineInputBorder(),
                                    ),
                                  ),
                                  popupProps: const PopupProps.menu(
                                      fit: FlexFit.loose,
                                      showSelectedItems: true,
                                      searchDelay: Duration(microseconds: 0)),
                                  items: componentes
                                      .map((e) => e.descripcion)
                                      .toList(),
                                  onChanged: (value) {
                                    componente = componentes.firstWhere(
                                        (element) =>
                                            element.descripcion == value);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownSearch<String>(
                                  validator: (value) => value == null
                                      ? 'Debe escojer una '
                                      : null,
                                  popupProps: const PopupProps.menu(
                                      fit: FlexFit.loose,
                                      showSelectedItems: true,
                                      searchDelay: Duration(microseconds: 0)),
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      hintText: "",
                                      border: UnderlineInputBorder(),
                                    ),
                                  ),
                                  items:
                                      es.map((e) => e.nombre).toList(),
                                  onChanged: (value) {
                                     = es.firstWhere(
                                        (element) => element.nombre == value);
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
                                    .createComponenteVehiculo(
                                        idComponente: componente!.id,
                                        id:
                                            !.codigoRelacionado);
                                ProgressDialog.dissmiss(context);
                                if (resp is Success) {
                                  Dialogs.success(
                                      msg:
                                          'Vehículo Componente  Creado');
                                  Navigator.of(context).pop();
                                  await onRefresh();
                                }

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
        }); */
  }

  @override
  void dispose() {
    listController.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
