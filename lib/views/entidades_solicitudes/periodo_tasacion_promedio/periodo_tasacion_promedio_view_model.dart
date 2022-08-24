import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/periodo_tasacion_promedio_api.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/periodo_tasacion_promedio_response.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/buscador.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/dialog_mostrar_informacion_roles.dart';

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
      opcionPeriodoTasacionPromedioData = resp.data.first;
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
      opcionPeriodoTasacionPromedioData = resp.data.first;
      notifyListeners();
    }
    if (respopc is Failure) {
      Dialogs.error(msg: respopc.messages.first);
    }
    cargando = false;
  }

  Future<void> modificarPeriodoTasacionPromedio(BuildContext ctx,
      PeriodoTasacionPromedioData periodoTasacionPromedio) async {
    List<String> list = [];
    List<String> listaSelected = [];
    Size size = MediaQuery.of(ctx).size;

    list = opcionPeriodoTasacionPromedioData!.descripcion.split(",");
    listaSelected.add(periodoTasacionPromedio.value.toString());
    print(list.join());

    list.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
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
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text("Opciones de períodos tasación promedio",
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                                listaSelected =
                                    isSelectedAll! ? list.toList() : [],
                              });
                        },
                        columns: const [
                          DataColumn(
                            label: Text("Períodos"),
                          ),
                        ],
                        rows: list
                            .map((e) => DataRow(
                                    selected: listaSelected
                                        .any((element) => element == e),
                                    onSelectChanged: (isSelected) =>
                                        setState(() {
                                          isSelected!
                                              ? listaSelected.add(e)
                                              : listaSelected.removeWhere(
                                                  (element) => element == e);
                                        }),
                                    cells: [
                                      DataCell(
                                        Text(
                                          e,
                                        ),
                                        onTap: null,
                                      ),
                                    ]))
                            .toList())
                  ],
                  size,
                  () async {
                    /* ProgressDialog.show(context);
                    String descripcion = "";
                    descripcion = listaSelected.join(",");
                    var resp = await _periodoTasacionPromedioApi.updateTipos(
                        descripcion: descripcion, id: foto.id!);
                    if (resp is Success<EntidadPOSTResponse>) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.success(msg: "Actualización exitosa");
                      Navigator.of(context).pop();
                      onInit();
                    } else if (resp is Failure) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.error(msg: resp.messages.first);
                    } */
                  },
                  buscador(
                    text: 'Buscar tipos...',
                    onChanged: (value) {
                      setState(() {
                        list = [];
                        for (var element in opcionPeriodoTasacionPromedioData!
                            .descripcion
                            .split(",")) {
                          if (element
                              .toLowerCase()
                              .contains(value.toLowerCase())) {
                            list.add(element);
                          }
                        }
                        list.sort((a, b) {
                          return a.toLowerCase().compareTo(b.toLowerCase());
                        });
                      });
                    },
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  void dispose() {
    listController.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
