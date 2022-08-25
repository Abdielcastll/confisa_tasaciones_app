import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/fotos_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/periodo_eliminacion_data_grafica_api.dart';
import 'package:tasaciones_app/core/models/cantidad_fotos_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/periodo_eliminacion_data_grafica_response.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/buscador.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/dialog_mostrar_informacion_roles.dart';

import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class FotosViewModel extends BaseViewModel {
  final _fotosApi = locator<FotosApi>();
  /* final _segmentosFotosVehiculosApi =
      locator<SegmentosFotosVehiculosApi>(); */
  final listController = ScrollController();
  TextEditingController tcBuscar = TextEditingController();
  TextEditingController tcNewDescripcion = TextEditingController();

  EntidadData foto = EntidadData();
  EntidadData opcionesTipos = EntidadData();
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  String _opcion = "Cantidad";
  /* bool hasNextPage = false; */

  late EntidadResponse fotosResponse;
  EntidadResponse? opcionesResponse;

  /* FotosViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasFotos();
        }
      }
    });
  } */

  bool get cargando => _cargando;
  set cargando(bool value) {
    _cargando = value;
    notifyListeners();
  }

  String get opcion => _opcion;
  set opcion(String value) {
    _opcion = value;
    notifyListeners();
    onInit();
  }

  bool get busqueda => _busqueda;
  set busqueda(bool value) {
    _busqueda = value;
    notifyListeners();
  }

  /* void ordenar() {
    fotos.sort((a, b) {
      return a.descripcion!
          .toLowerCase()
          .compareTo(b.descripcion!.toLowerCase());
    });
  } */

  List<DropdownMenuItem<String>> opciones() {
    List<String> opciones = ["Cantidad", "Tipo"];

    return opciones
        .map((e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ))
        .toList();
  }

  Future<void> onInit() async {
    cargando = true;
    Object resp = '';
    switch (_opcion) {
      case "Cantidad":
        resp = await _fotosApi.getCantidadFotos();
        break;
      case "Tipo":
        resp = await _fotosApi.getTipoFotos();
        break;
      default:
        resp = await _fotosApi.getCantidadFotos();
    }
    if (resp is Success) {
      fotosResponse = resp.response as EntidadResponse;
      foto = fotosResponse.data;
      // ordenar();
      /* hasNextPage = fotosResponse.hasNextPage; */
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    var respop = await _fotosApi.getOpcionesTipos();
    if (respop is Success) {
      var data = respop.response as EntidadResponse;
      opcionesTipos = data.data;
    }
    if (respop is Failure) {
      Dialogs.error(msg: respop.messages.first);
    }
    cargando = false;
  }

  /* Future<void> cargarMasFotos() async {
    pageNumber += 1;
    Object resp;
    switch (_opcion) {
      case "Cantidad":
        resp = await _fotosApi.getCantidadFotos();
        break;
      case "Tipo":
        resp = await _fotosApi.getTipoFotos();
        break;
      default:
        resp = await _fotosApi.getCantidadFotos();
    }
    if (resp is Success) {
      var temp = resp.response as EntidadResponse;
      fotosResponse.data = temp.data;
      foto = temp.data;
      /* ordenar();
      hasNextPage = temp.hasNextPage; */
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  } */

  /* Future<void> buscarFotos(String query) async {
    cargando = true;
    Object resp;
    switch (_opcion) {
      case "Vencida":
        resp = await _fotosApi.getFotosVencida(
          descripcion: query,
          pageSize: 0,
        );
        break;
      case "Valorada":
        resp = await _fotosApi.getFotosValorada(
          descripcion: query,
          pageSize: 0,
        );
        break;
      case "Rechazada":
        resp = await _fotosApi.getFotosRechazada(
          descripcion: query,
          pageSize: 0,
        );
        break;
      default:
        resp = await _fotosApi.getFotosVencida(
          descripcion: query,
          pageSize: 0,
        );
    }
    if (resp is Success) {
      var temp = resp.response as FotosResponse;
      Fotos = temp.data;
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
    Fotos = FotosResponse.data;
    if (Fotos.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  } */

  Future<void> onRefresh() async {
    foto = EntidadData();
    cargando = true;
    Object resp;
    switch (_opcion) {
      case "Cantidad":
        resp = await _fotosApi.getCantidadFotos();
        break;
      case "Tipo":
        resp = await _fotosApi.getTipoFotos();
        break;
      default:
        resp = await _fotosApi.getCantidadFotos();
    }
    if (resp is Success) {
      var temp = resp.response as EntidadResponse;
      fotosResponse = temp;
      foto = temp.data;
      /* ordenar();
      hasNextPage = temp.hasNextPage; */
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
                    var resp = await _fotosApi.updateTipos(
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

  Future<void> modificarFotosCantidad(
      BuildContext ctx, EntidadData foto) async {
    tcNewDescripcion.text = foto.descripcion!;
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
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Modificar $opcion Foto',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba una descripción';
                          } else {
                            if (int.parse(value.trim()) >= 20) {
                              return 'La cantidad de fotos no puede ser mayor a 20';
                            }
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            label: Text("Descripción")),
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
                                foto.descripcion.toString())) {
                              ProgressDialog.show(context);

                              var resp = await _fotosApi.updateCantidad(
                                  descripcion: tcNewDescripcion.text,
                                  id: foto.id);

                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg: '$opcion Foto Actualizada');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }
                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewDescripcion.clear();
                            } else {
                              Dialogs.success(msg: '$opcion Foto Actualizada');
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
