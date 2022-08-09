import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/suplidores_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/componentes_vehiculo_api.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/componentes_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/suplidores_response.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/seguridad_entidades_solicitudes/componentes_vehiculo_suplidor_api.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

import '../../../core/models/seguridad_entidades_solicitudes/componentes_vehiculo_suplidor_response.dart';
import '../../../theme/theme.dart';

class ComponentesVehiculoSuplidorViewModel extends BaseViewModel {
  final _componentesVehiculoSuplidorApi =
      locator<ComponentesVehiculoSuplidorApi>();
  final _componentesVehiculoApi = locator<ComponentesVehiculoApi>();
  final _suplidorApi = locator<SuplidoresApi>();
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();

  List<ComponentesVehiculoSuplidorData> componentesVehiculoSuplidor = [];
  List<ComponentesVehiculoData> componentes = [];
  List<SuplidorData> suplidores = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late ComponentesVehiculoSuplidorResponse componentesVehiculoSuplidorResponse;
  SuplidorData? suplidor;
  ComponentesVehiculoData? componente;

  ComponentesVehiculoSuplidorViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasComponentesVehiculoSuplidor();
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
    componentesVehiculoSuplidor.sort((a, b) {
      return a.componentesDescripcion
          .toLowerCase()
          .compareTo(b.componentesDescripcion.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _componentesVehiculoSuplidorApi
        .getComponentesVehiculoSuplidor(pageNumber: pageNumber);
    if (resp is Success) {
      componentesVehiculoSuplidorResponse =
          resp.response as ComponentesVehiculoSuplidorResponse;
      componentesVehiculoSuplidor = componentesVehiculoSuplidorResponse.data;
      ordenar();
      hasNextPage = componentesVehiculoSuplidorResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var respcomp = await _componentesVehiculoApi.getComponentesVehiculo();
    if (respcomp is Success) {
      var data = respcomp.response as ComponentesVehiculoResponse;
      componentes = data.data;
    }
    if (respcomp is Failure) {
      Dialogs.error(msg: respcomp.messages.first);
    }
    var respsupli = await _suplidorApi.getSuplidores();
    if (respsupli is Success) {
      var data = respsupli.response as SuplidoresResponse;
      suplidores = data.data;
    }
    if (respcomp is Failure) {
      Dialogs.error(msg: respcomp.messages.first);
    }
    cargando = false;
  }

  Future<void> cargarMasComponentesVehiculoSuplidor() async {
    pageNumber += 1;
    var resp = await _componentesVehiculoSuplidorApi
        .getComponentesVehiculoSuplidor(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as ComponentesVehiculoSuplidorResponse;
      componentesVehiculoSuplidorResponse.data.addAll(temp.data);
      componentesVehiculoSuplidor.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscarComponentesVehiculoSuplidor(String query) async {
    cargando = true;
    var resp =
        await _componentesVehiculoSuplidorApi.getComponentesVehiculoSuplidor(
      componenteDescripcion: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as ComponentesVehiculoSuplidorResponse;
      componentesVehiculoSuplidor = temp.data;
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
    componentesVehiculoSuplidor = componentesVehiculoSuplidorResponse.data;
    if (componentesVehiculoSuplidor.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    componentesVehiculoSuplidor = [];
    cargando = true;
    var resp =
        await _componentesVehiculoSuplidorApi.getComponentesVehiculoSuplidor();
    if (resp is Success) {
      var temp = resp.response as ComponentesVehiculoSuplidorResponse;
      componentesVehiculoSuplidorResponse = temp;
      componentesVehiculoSuplidor = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var respcomp = await _componentesVehiculoApi.getComponentesVehiculo();
    if (respcomp is Success) {
      var data = respcomp.response as ComponentesVehiculoResponse;
      componentes = data.data;
    }
    if (respcomp is Failure) {
      Dialogs.error(msg: respcomp.messages.first);
    }
    var respsupli = await _suplidorApi.getSuplidores();
    if (respsupli is Success) {
      var data = respsupli.response as SuplidoresResponse;
      suplidores = data.data;
    }
    if (respcomp is Failure) {
      Dialogs.error(msg: respcomp.messages.first);
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

  Future<void> deleteComponentesVehiculoSuplidor(
      BuildContext context, ComponentesVehiculoSuplidorData componente) async {
    Dialogs.confirm(context,
        tittle:
            "Eliminar Vehículo Componente Suplidor ${componente.componentesDescripcion}",
        description:
            "¿Está seguro que desea eliminar el Vehículo Componente Suplidor?",
        confirm: () async {
      ProgressDialog.show(context);
      var resp = await _componentesVehiculoSuplidorApi
          .deleteComponentesVehiculoSuplidor(id: componente.id);
      if (resp is Success<ComponentesVehiculoSuplidorPOSTResponse>) {
        ProgressDialog.dissmiss(context);
        Dialogs.success(msg: "Eliminado con éxito");
        onInit();
      } else if (resp is Failure) {
        ProgressDialog.dissmiss(context);
        Dialogs.error(msg: resp.messages.first);
      }
    });
  }

  Future<void> crearComponentesVehiculoSuplidor(BuildContext ctx) async {
    suplidor = null;
    componente = null;
    final GlobalKey<FormState> _formKey = GlobalKey();
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
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Crear Vehiculo Componente Suplidor',
                            textAlign: TextAlign.center,
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
                                      ? 'Debe escojer una suplidor'
                                      : null,
                                  popupProps: const PopupProps.menu(
                                      fit: FlexFit.loose,
                                      showSelectedItems: true,
                                      searchDelay: Duration(microseconds: 0)),
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      hintText: "Suplidor",
                                      border: UnderlineInputBorder(),
                                    ),
                                  ),
                                  items:
                                      suplidores.map((e) => e.nombre).toList(),
                                  onChanged: (value) {
                                    suplidor = suplidores.firstWhere(
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
                                var resp = await _componentesVehiculoSuplidorApi
                                    .createComponenteVehiculoSuplidor(
                                        idComponente: componente!.id,
                                        idSuplidor:
                                            suplidor!.codigoRelacionado);
                                ProgressDialog.dissmiss(context);
                                if (resp is Success) {
                                  Dialogs.success(
                                      msg:
                                          'Vehículo Componente Suplidor Creado');
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
        });
  }

  @override
  void dispose() {
    listController.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
