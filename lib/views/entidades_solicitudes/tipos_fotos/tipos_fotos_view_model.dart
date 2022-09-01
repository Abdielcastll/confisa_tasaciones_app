import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/fotos_api.dart';
import 'package:tasaciones_app/core/models/cantidad_fotos_response.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/buscador.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/dialog_mostrar_informacion_roles.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class TiposFotosViewModel extends BaseViewModel {
  final _tiposfotosApi = locator<FotosApi>();
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();
  TextEditingController tcNewDescripcion = TextEditingController();

  EntidadData foto = EntidadData();
  EntidadData opcionesTipos = EntidadData();
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;

  late EntidadResponse tiposfotosResponse;
  EntidadResponse? opcionesResponse;

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

  Future<void> onInit() async {
    cargando = true;
    var resp = await _tiposfotosApi.getTipoFotos();

    if (resp is Success) {
      tiposfotosResponse = resp.response as EntidadResponse;
      foto = tiposfotosResponse.data;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var respop = await _tiposfotosApi.getOpcionesTipos();
    if (respop is Success) {
      var data = respop.response as EntidadResponse;
      opcionesTipos = data.data;
    }
    if (respop is Failure) {
      Dialogs.error(msg: respop.messages.first);
    }
    cargando = false;
  }

  Future<void> onRefresh() async {
    foto = EntidadData();
    cargando = true;
    var resp = await _tiposfotosApi.getTipoFotos();

    if (resp is Success) {
      var temp = resp.response as EntidadResponse;
      tiposfotosResponse = temp;
      foto = temp.data;
      notifyListeners();
    }
    cargando = false;
  }

  Future<void> modificarFotosTipo(BuildContext ctx, EntidadData foto) async {
    List<String> list = [];
    List<String> listaSelected = [];
    Size size = MediaQuery.of(ctx).size;

    list = opcionesTipos.descripcion!.split(",");
    listaSelected = foto.descripcion!.split(",");

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
                      child: Text("Opciones de tipos fotos",
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
                            label: Text("Tipos"),
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
                    ProgressDialog.show(context);
                    String descripcion = "";
                    descripcion = listaSelected.join(",");
                    var resp = await _tiposfotosApi.updateTipos(
                        descripcion: descripcion, id: foto.id!);
                    if (resp is Success<EntidadPOSTResponse>) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.success(msg: "Actualización exitosa");
                      Navigator.of(context).pop();
                      onInit();
                    } else if (resp is Failure) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.error(msg: resp.messages.first);
                    }
                  },
                  buscador(
                    text: 'Buscar tipos...',
                    onChanged: (value) {
                      setState(() {
                        list = [];
                        for (var element
                            in opcionesTipos.descripcion!.split(",")) {
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
