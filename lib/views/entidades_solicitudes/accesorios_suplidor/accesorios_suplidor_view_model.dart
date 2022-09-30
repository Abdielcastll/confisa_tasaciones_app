import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/suplidores_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/accesorios_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/accesorios_suplidor_api.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/accesorios_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/accesorios_suplidor_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/suplidores_response.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/buscador.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/dialog_mostrar_informacion_roles.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

import '../../../theme/theme.dart';

class AccesoriosSuplidorViewModel extends BaseViewModel {
  final _accesoriosSuplidorApi = locator<AccesoriosSuplidorApi>();
  final _accesoriosApi = locator<AccesoriosApi>();
  final _suplidorApi = locator<SuplidoresApi>();
  final _userClient = locator<UserClient>();
  final _navigationService = locator<NavigatorService>();
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();

  List<AccesoriosSuplidorData> accesoriosSuplidor = [];
  List<AccesoriosData> accesorios = [];
  List<SuplidorData> suplidores = [];
  List<AccesoriosData> accesoriosAprobador = [];
  List<AccesoriosData> accesoriosSelected = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late AccesoriosSuplidorResponse accesoriosSuplidorResponse;
  late SuplidoresResponse suplidoresResponse;
  SuplidorData? suplidor;
  Profile? usuario;
  AccesoriosData? componente;

  AccesoriosSuplidorViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasAccesoriosSuplidor();
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
    if (usuario!.idSuplidor != 0 ||
        usuario!.roles!
            .any((element) => element.roleName == "AprobadorTasaciones")) {
      accesorios.sort((a, b) {
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
    accesoriosSelected = [];
    if (usuario!.idSuplidor != 0 ||
        usuario!.roles!
            .any((element) => element.roleName == "AprobadorTasaciones")) {
      var respacc = await _accesoriosApi.getAccesorios();
      if (respacc is Success) {
        var data = respacc.response as AccesoriosResponse;
        accesorios = data.data;
        accesoriosAprobador = data.data;
      }
      if (respacc is Failure) {
        Dialogs.error(msg: respacc.messages.first);
      }
      if (respacc is TokenFail) {
        _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'Sesión expirada');
      }
      var resp = await _accesoriosSuplidorApi.getAccesoriosSuplidor(
          idSuplidor: usuario!.idSuplidor);
      if (resp is Success) {
        var data = resp.response as AccesoriosSuplidorResponse;
        accesoriosSuplidor = data.data;
        for (var element in accesoriosSuplidor) {
          accesoriosSelected.add(AccesoriosData(
              id: element.idAccesorio,
              descripcion: element.accesorioDescripcion,
              idSegmento: 0,
              segmentoDescripcion: ""));
        }
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages.first);
      }
      if (resp is TokenFail) {
        _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'Sesión expirada');
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
    if (respsupli is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    var respcomp = await _accesoriosApi.getAccesorios();
    if (respcomp is Success) {
      var data = respcomp.response as AccesoriosResponse;
      accesorios = data.data;
    }
    if (respcomp is Failure) {
      Dialogs.error(msg: respcomp.messages.first);
    }
    if (respcomp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    cargando = false;
  }

  void selectAll(bool select) async {
    accesoriosSelected = select ? accesoriosAprobador.toList() : [];
    notifyListeners();
  }

  bool select(AccesoriosData componente) {
    return accesoriosSelected.any((element) => element.id == componente.id);
  }

  Future<void> guardar(BuildContext context) async {
    ProgressDialog.show(context);
    List<int> accesorios = [];
    for (var element in accesoriosSelected) {
      accesorios.add(element.id);
    }
    var resp = await _accesoriosSuplidorApi.createAccesoriosSuplidor(
        idSuplidor: usuario!.idSuplidor!, idAccesorios: accesorios);
    if (resp is Success<AccesoriosSuplidorData>) {
      ProgressDialog.dissmiss(context);
      Dialogs.success(msg: "Actualización exitosa");
      onInit();
    } else if (resp is Failure) {
      Dialogs.error(msg: resp.messages.first);
      ProgressDialog.dissmiss(context);
      onInit();
    }
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
  }

  void selectChange(bool select, AccesoriosData componente) {
    select
        ? accesoriosSelected.add(componente)
        : accesoriosSelected
            .removeWhere((element) => element.id == componente.id);
    notifyListeners();
  }

  void buscarAprobadorSuplidor(String query) async {
    accesoriosAprobador = [];
    for (var element in accesorios) {
      if (element.descripcion.toLowerCase().contains(query.toLowerCase())) {
        accesoriosAprobador.add(element);
      }
    }
    accesoriosAprobador.sort((a, b) {
      return a.descripcion.toLowerCase().compareTo(b.descripcion.toLowerCase());
    });
    notifyListeners();
  }

  Future<void> cargarMasAccesoriosSuplidor() async {
    pageNumber += 1;
    var resp = await _accesoriosSuplidorApi.getAccesoriosSuplidor(
        pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as AccesoriosSuplidorResponse;
      accesoriosSuplidorResponse.data.addAll(temp.data);
      accesoriosSuplidor.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
  }

  Future<void> buscarAccesoriosSuplidor(String query) async {
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
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
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
    accesoriosSelected = [];
    if (usuario!.idSuplidor != 0 ||
        usuario!.roles!
            .any((element) => element.roleName == "AprobadorTasaciones")) {
      var respacc = await _accesoriosApi.getAccesorios();
      if (respacc is Success) {
        var data = respacc.response as AccesoriosResponse;
        accesorios = data.data;
        accesoriosAprobador = data.data;
      }
      if (respacc is Failure) {
        Dialogs.error(msg: respacc.messages.first);
      }
      if (respacc is TokenFail) {
        _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'Sesión expirada');
      }
      var resp = await _accesoriosSuplidorApi.getAccesoriosSuplidor(
          idSuplidor: usuario!.idSuplidor);
      if (resp is Success) {
        var data = resp.response as AccesoriosSuplidorResponse;
        accesoriosSuplidor = data.data;
        for (var element in accesoriosSuplidor) {
          accesoriosSelected.add(AccesoriosData(
              id: element.idAccesorio,
              descripcion: element.accesorioDescripcion,
              idSegmento: 0,
              segmentoDescripcion: ""));
        }
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages.first);
      }
      if (resp is TokenFail) {
        _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'Sesión expirada');
      }
      cargando = false;
      ordenar();
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
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    var respcomp = await _accesoriosApi.getAccesorios();
    if (respcomp is Success) {
      var data = respcomp.response as AccesoriosResponse;
      accesorios = data.data;
    }
    if (respcomp is Failure) {
      Dialogs.error(msg: respcomp.messages.first);
    }
    if (respcomp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    cargando = false;
  }

  Future<void> modificarAccesoriosSuplidor(
      BuildContext ctx, SuplidorData suplidor) async {
    List<AccesoriosSuplidorData> list = [];
    Size size = MediaQuery.of(ctx).size;
    ProgressDialog.show(ctx);
    var resp = await _accesoriosSuplidorApi.getAccesoriosSuplidor(
        idSuplidor: suplidor.codigoRelacionado);
    if (resp is Success<AccesoriosSuplidorResponse>) {
      ProgressDialog.dissmiss(ctx);
      for (var element in accesorios) {
        list.add(AccesoriosSuplidorData(
            id: 0,
            estado: 0,
            idSuplidor: 0,
            suplidorDescripcion: "",
            accesorioDescripcion: element.descripcion,
            idAccesorio: element.id));
      }
      list.sort((a, b) {
        return a.accesorioDescripcion
            .toLowerCase()
            .compareTo(b.accesorioDescripcion.toLowerCase());
      });
      showDialog(
          context: ctx,
          builder: (BuildContext context) {
            List<AccesoriosSuplidorData> selectedaccesorios = [];
            selectedaccesorios = resp.response.data;
            int first = 1;
            return StatefulBuilder(builder: (context, setState) {
              if (first == 1) {
                setState(() {
                  selectedaccesorios = resp.response.data;
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
                        child: Text("Accesorios de ${suplidor.nombre}",
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
                                  selectedaccesorios =
                                      isSelectedAll! ? list.toList() : [],
                                });
                          },
                          columns: const [
                            DataColumn(
                              label: Text("Accesorio"),
                            ),
                          ],
                          rows: list
                              .map((e) => DataRow(
                                      selected: selectedaccesorios.any(
                                          (element) =>
                                              element.idAccesorio ==
                                              e.idAccesorio),
                                      onSelectChanged: (isSelected) =>
                                          setState(() {
                                            isSelected!
                                                ? selectedaccesorios.add(e)
                                                : selectedaccesorios
                                                    .removeWhere((element) =>
                                                        element.idAccesorio ==
                                                        e.idAccesorio);
                                          }),
                                      cells: [
                                        DataCell(
                                          Text(
                                            e.accesorioDescripcion,
                                          ),
                                          onTap: null,
                                        ),
                                      ]))
                              .toList())
                    ],
                    size,
                    () async {
                      ProgressDialog.show(context);
                      List<int> accesorios = [];
                      for (var element in selectedaccesorios) {
                        accesorios.add(element.idAccesorio);
                      }
                      var resp =
                          await _accesoriosSuplidorApi.createAccesoriosSuplidor(
                              idSuplidor: suplidor.codigoRelacionado,
                              idAccesorios: accesorios);
                      if (resp is Success<AccesoriosSuplidorData>) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.success(msg: "Actualización exitosa");
                        Navigator.of(context).pop();
                      } else if (resp is Failure) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.error(msg: resp.messages.first);
                      }
                      if (resp is TokenFail) {
                        _navigationService
                            .navigateToPageAndRemoveUntil(LoginView.routeName);
                        Dialogs.error(msg: 'Sesión expirada');
                      }
                    },
                    buscador(
                      text: 'Buscar accesorios...',
                      onChanged: (value) {
                        setState(() {
                          list = [];
                          for (var element in accesorios) {
                            if (element.descripcion
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              list.add(AccesoriosSuplidorData(
                                  id: 0,
                                  accesorioDescripcion: element.descripcion,
                                  estado: 0,
                                  idAccesorio: element.id,
                                  idSuplidor: 0,
                                  suplidorDescripcion: ""));
                            }
                          }
                          list.sort((a, b) {
                            return a.accesorioDescripcion
                                .toLowerCase()
                                .compareTo(
                                    b.accesorioDescripcion.toLowerCase());
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

  /* Future<void> deleteAccesoriosSuplidor(
      BuildContext context, AccesoriosSuplidorData componente) async {
    Dialogs.confirm(context,
        tittle:
            "Eliminar Vehículo Componente Suplidor ${componente.accesorioDescripcion}",
        description:
            "¿Está seguro que desea eliminar el Vehículo Componente Suplidor?",
        confirm: () async {
      ProgressDialog.show(context);
      var resp = await _accesoriosSuplidorApi.deleteAccesoriosSuplidor(
          id: componente.id);
      if (resp is Success<AccesoriosSuplidorPOSTResponse>) {
        ProgressDialog.dissmiss(context);
        Dialogs.success(msg: "Eliminado con éxito");
        onInit();
      } else if (resp is Failure) {
        ProgressDialog.dissmiss(context);
        Dialogs.error(msg: resp.messages.first);
      }
    });
  } */

  @override
  void dispose() {
    listController.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
