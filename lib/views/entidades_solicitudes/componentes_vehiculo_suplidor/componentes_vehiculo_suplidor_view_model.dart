import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/suplidores_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/componentes_vehiculo_api.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/componentes_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/suplidores_response.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/buscador.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/dialog_mostrar_informacion_roles.dart';

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
  final _userClient = locator<UserClient>();
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();

  List<ComponentesVehiculoSuplidorData> componentesVehiculoSuplidor = [];
  List<ComponentesVehiculoData> componentes = [];
  List<ComponentesVehiculoData> componentesAprobador = [];
  List<ComponentesVehiculoData> componentesSelected = [];
  List<SuplidorData> suplidores = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late SuplidoresResponse suplidoresResponse;
  SuplidorData? suplidor;
  Profile? usuario;
  ComponentesVehiculoData? componente;

  ComponentesVehiculoSuplidorViewModel() {
    /* listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasComponentesVehiculoSuplidor();
        }
      }
    }); */
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
    if (usuario!.idSuplidor != 0 ||
        usuario!.roles!
            .any((element) => element.roleName == "AprobadorTasaciones")) {
      componentes.sort((a, b) {
        return a.descripcion
            .toLowerCase()
            .compareTo(b.descripcion.toLowerCase());
      });
    }
    suplidores.sort((a, b) {
      return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    usuario = _userClient.loadProfile;
    componentesSelected = [];
    if (usuario!.idSuplidor != 0 ||
        usuario!.roles!
            .any((element) => element.roleName == "AprobadorTasaciones")) {
      var respcomp = await _componentesVehiculoApi.getComponentesVehiculo();
      if (respcomp is Success) {
        var data = respcomp.response as ComponentesVehiculoResponse;
        componentes = data.data;
        componentesAprobador = data.data;
      }
      if (respcomp is Failure) {
        Dialogs.error(msg: respcomp.messages.first);
      }
      var resp = await _componentesVehiculoSuplidorApi
          .getComponentesVehiculoSuplidor(idSuplidor: usuario!.idSuplidor);
      if (resp is Success) {
        var data = resp.response as ComponentesVehiculoSuplidorResponse;
        componentesVehiculoSuplidor = data.data;
        for (var element in componentesVehiculoSuplidor) {
          componentesSelected.add(ComponentesVehiculoData(
              id: element.idComponente,
              descripcion: element.componenteDescripcion,
              idSegmento: 0,
              segmentoDescripcion: ""));
        }
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages.first);
      }
      cargando = false;
      ordenar();
      return;
    }
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
    var respcomp = await _componentesVehiculoApi.getComponentesVehiculo();
    if (respcomp is Success) {
      var data = respcomp.response as ComponentesVehiculoResponse;
      componentes = data.data;
    }
    if (respcomp is Failure) {
      Dialogs.error(msg: respcomp.messages.first);
    }
    cargando = false;
  }

/*   Future<void> cargarMasComponentesVehiculoSuplidor() async {
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
  } */
  void selectAll(bool select) async {
    componentesSelected = select ? componentesAprobador.toList() : [];
    notifyListeners();
  }

  bool select(ComponentesVehiculoData componente) {
    return componentesSelected.any((element) => element.id == componente.id);
  }

  Future<void> guardar(BuildContext context) async {
    ProgressDialog.show(context);
    List<int> componentes = [];
    for (var element in componentesSelected) {
      componentes.add(element.id);
    }
    var resp =
        await _componentesVehiculoSuplidorApi.createComponenteVehiculoSuplidor(
            idSuplidor: usuario!.idSuplidor!, idComponentes: componentes);
    if (resp is Success<ComponentesVehiculoSuplidorData>) {
      ProgressDialog.dissmiss(context);
      Dialogs.success(msg: "Actualización exitosa");
      onInit();
    } else if (resp is Failure) {
      Dialogs.error(msg: resp.messages.first);
      ProgressDialog.dissmiss(context);
      onInit();
    }
  }

  void selectChange(bool select, ComponentesVehiculoData componente) {
    select
        ? componentesSelected.add(componente)
        : componentesSelected
            .removeWhere((element) => element.id == componente.id);
    notifyListeners();
  }

  void buscarAprobadorSuplidor(String query) async {
    componentesAprobador = [];
    for (var element in componentes) {
      if (element.descripcion.toLowerCase().contains(query.toLowerCase())) {
        componentesAprobador.add(element);
      }
    }
    componentesAprobador.sort((a, b) {
      return a.descripcion.toLowerCase().compareTo(b.descripcion.toLowerCase());
    });
    notifyListeners();
  }

  Future<void> buscarComponentesVehiculoSuplidor(String query) async {
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
    cargando = false;
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

  Future<void> onRefresh() async {
    suplidores = [];
    cargando = true;
    if (usuario!.idSuplidor != 0 ||
        usuario!.roles!
            .any((element) => element.roleName == "AprobadorTasaciones")) {
      var respcomp = await _componentesVehiculoApi.getComponentesVehiculo();
      if (respcomp is Success) {
        var data = respcomp.response as ComponentesVehiculoResponse;
        componentes = data.data;
        componentesAprobador = data.data;
      }
      if (respcomp is Failure) {
        Dialogs.error(msg: respcomp.messages.first);
      }
      var resp = await _componentesVehiculoSuplidorApi
          .getComponentesVehiculoSuplidor(idSuplidor: usuario!.idSuplidor);
      if (resp is Success) {
        var data = resp.response as ComponentesVehiculoSuplidorResponse;
        componentesVehiculoSuplidor = data.data;
        for (var element in componentesVehiculoSuplidor) {
          componentesSelected.add(ComponentesVehiculoData(
              id: element.idComponente,
              descripcion: element.componenteDescripcion,
              idSegmento: 0,
              segmentoDescripcion: ""));
        }
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages.first);
      }
      cargando = false;
      return;
    }
    var resp = await _suplidorApi.getSuplidores();
    if (resp is Success) {
      var temp = resp.response as SuplidoresResponse;
      suplidoresResponse = temp;
      suplidores = temp.data;
      ordenar();
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
    cargando = false;
  }

  Future<void> modificarComponentesVehiculoSuplidor(
      BuildContext ctx, SuplidorData suplidor) async {
    List<ComponentesVehiculoSuplidorData> list = [];
    Size size = MediaQuery.of(ctx).size;
    ProgressDialog.show(ctx);
    var resp = await _componentesVehiculoSuplidorApi
        .getComponentesVehiculoSuplidor(idSuplidor: suplidor.codigoRelacionado);
    if (resp is Success<ComponentesVehiculoSuplidorResponse>) {
      ProgressDialog.dissmiss(ctx);
      for (var element in componentes) {
        list.add(ComponentesVehiculoSuplidorData(
            id: 0,
            componenteDescripcion: element.descripcion,
            estado: 0,
            idComponente: element.id,
            idSuplidor: 0,
            suplidorDescripcion: ""));
      }
      list.sort((a, b) {
        return a.componenteDescripcion
            .toLowerCase()
            .compareTo(b.componenteDescripcion.toLowerCase());
      });
      showDialog(
          context: ctx,
          builder: (BuildContext context) {
            List<ComponentesVehiculoSuplidorData> selectedComponentes = [];
            selectedComponentes = resp.response.data;
            int first = 1;
            return StatefulBuilder(builder: (context, setState) {
              if (first == 1) {
                setState(() {
                  selectedComponentes = resp.response.data;
                  first = first + 1;
                });
              }

              return AlertDialog(
                insetPadding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.zero,
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  child: dialogMostrarInformacionRoles(
                    Container(
                      height: size.height * .08,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: AppColors.gold,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Componentes de ${suplidor.nombre}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    [
                      DataTable(
                          onSelectAll: (isSelectedAll) {
                            setState(() => {
                                  selectedComponentes =
                                      isSelectedAll! ? list.toList() : [],
                                });
                          },
                          columns: const [
                            DataColumn(
                              label: Text("Componente"),
                            ),
                          ],
                          rows: list
                              .map((e) => DataRow(
                                      selected: selectedComponentes.any(
                                          (element) =>
                                              element.idComponente ==
                                              e.idComponente),
                                      onSelectChanged: (isSelected) =>
                                          setState(() {
                                            isSelected!
                                                ? selectedComponentes.add(e)
                                                : selectedComponentes
                                                    .removeWhere((element) =>
                                                        element.idComponente ==
                                                        e.idComponente);
                                          }),
                                      cells: [
                                        DataCell(
                                          Text(
                                            e.componenteDescripcion,
                                          ),
                                          onTap: null,
                                        ),
                                      ]))
                              .toList())
                    ],
                    size,
                    () async {
                      ProgressDialog.show(context);
                      List<int> componentes = [];
                      for (var element in selectedComponentes) {
                        componentes.add(element.idComponente);
                      }
                      var resp = await _componentesVehiculoSuplidorApi
                          .createComponenteVehiculoSuplidor(
                              idSuplidor: suplidor.codigoRelacionado,
                              idComponentes: componentes);
                      if (resp is Success<ComponentesVehiculoSuplidorData>) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.success(msg: "Actualización exitosa");
                        Navigator.of(context).pop();
                      } else if (resp is Failure) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.error(msg: resp.messages.first);
                      }
                    },
                    buscador(
                      text: 'Buscar componentes...',
                      onChanged: (value) {
                        setState(() {
                          list = [];
                          for (var element in componentes) {
                            if (element.descripcion
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              list.add(ComponentesVehiculoSuplidorData(
                                  id: 0,
                                  componenteDescripcion: element.descripcion,
                                  estado: 0,
                                  idComponente: element.id,
                                  idSuplidor: 0,
                                  suplidorDescripcion: ""));
                            }
                          }
                          list.sort((a, b) {
                            return a.componenteDescripcion
                                .toLowerCase()
                                .compareTo(
                                    b.componenteDescripcion.toLowerCase());
                          });
                        });
                      },
                    ),
                  ),
                ),
              );
            });
          });
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(ctx);
      Dialogs.error(msg: resp.messages.first);
    }
  }

  Future<void> deleteComponentesVehiculoSuplidor(
      BuildContext context, ComponentesVehiculoSuplidorData componente) async {
    Dialogs.confirm(context,
        tittle:
            "Eliminar Vehículo Componente Suplidor ${componente.componenteDescripcion}",
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

  @override
  void dispose() {
    listController.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
