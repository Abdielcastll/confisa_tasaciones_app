import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/roles_claims_response.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/dialog_mostrar_informacion_roles.dart';

import '../../../../core/api/api_status.dart';
import '../../../../core/api/permisos_api.dart';
import '../../../../core/api/roles_api.dart';
import '../../../../core/authentication_client.dart';
import '../../../../core/locator.dart';
import '../../../../core/models/permisos_response.dart';
import '../../../../theme/theme.dart';
import '../../../../widgets/app_circle_icon_button.dart';
import '../../../../widgets/app_dialogs.dart';
import '../dialog_mostrar_informacion_permisos.dart';
import '../forms/form_actualizar_rol.dart';

class PaginatedTableRoles {
  late BuildContext context;
  PaginatedTableRoles({required this.context});

  Widget table() {
    GlobalKey key = GlobalKey();
    key.currentState?.dispose;
    return SingleChildScrollView(
      child: AdvancedPaginatedDataTable(
        key: key,
        loadingWidget: () => Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * .325),
          child: const CircularProgressIndicator(color: AppColors.brownDark),
        ),
        errorWidget: () => Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * .30),
          child: const CircularProgressIndicator(color: AppColors.brownDark),
        ),
        source: TableRoles(pageSize: 12, context: context),
        columns: const [
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Descripcion')),
          DataColumn(label: Text('Actualizar')),
          DataColumn(label: Text('Eliminar'))
        ],
        columnSpacing: 25,
        rowsPerPage: 12,
        showCheckboxColumn: false,
      ),
    );
  }
}

class TableRoles extends AdvancedDataTableSource<RolData> {
  TableRoles({required this.pageSize, required this.context});
  late BuildContext context;
  final user = locator<AuthenticationClient>().loadSession;
  final _rolesApi = locator<RolesAPI>();
  final _permisosApi = locator<PermisosAPI>();

  @override
  bool get forceRemoteReload => super.forceRemoteReload = true;

  int pageSize;

  @override
  DataRow? getRow(int index) {
    final Size size = MediaQuery.of(context).size;
    final currentRowData = lastDetails!.rows[index];
    return DataRow(cells: [
      DataCell(
        TextButton(
          child: Text(currentRowData.name),
          onPressed: () async {
            ProgressDialog.show(context);
            var resp = await _rolesApi.getRolesClaims(idRol: currentRowData.id);
            if (resp is Success<RolClaimsResponse>) {
              bool isSelect = false;
              ProgressDialog.dissmiss(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    List<RolClaimsData> selectedPermisos = [];
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.zero,
                        content: dialogMostrarInformacionRoles(
                            Container(
                              height: size.height * .08,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                color: AppColors.orange,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                    "Permisos de ${currentRowData.name}",
                                    style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            [
                              DataTable(
                                  onSelectAll: (isSelectedAll) {
                                    setState(() => {
                                          selectedPermisos = isSelectedAll!
                                              ? resp.response.data
                                              : [],
                                          isSelect = isSelectedAll
                                        });
                                  },
                                  columns: [
                                    DataColumn(
                                        label: Row(
                                      children: [
                                        const Text("Permiso"),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        CircleIconButton(
                                            color: AppColors.green,
                                            icon: Icons.add,
                                            onPressed: () async {
                                              ProgressDialog.show(context);
                                              var respPermisos =
                                                  await _permisosApi
                                                      .getPermisos(
                                                          pageSize: 1000);
                                              if (respPermisos is Success<
                                                  PermisosResponse>) {
                                                ProgressDialog.dissmiss(
                                                    context);
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      List<PermisosData>
                                                          selectedPermisos2 =
                                                          [];
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          content:
                                                              dialogMostrarInformacionPermisos(
                                                                  Container(
                                                                    height:
                                                                        size.height *
                                                                            .08,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              10),
                                                                          topRight:
                                                                              Radius.circular(10)),
                                                                      color: AppColors
                                                                          .orange,
                                                                    ),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const SizedBox(
                                                                            width:
                                                                                20,
                                                                          ),
                                                                          const Text(
                                                                              "Permisos",
                                                                              style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                                                          const SizedBox(
                                                                            width:
                                                                                20,
                                                                          ),
                                                                          CircleIconButton(
                                                                              color: AppColors.green,
                                                                              icon: Icons.add,
                                                                              onPressed: () async {
                                                                                if (selectedPermisos2.isNotEmpty) {
                                                                                  ProgressDialog.show(context);
                                                                                  var respAsignacion = await _rolesApi.assingPermisosRol(currentRowData.id, selectedPermisos2);
                                                                                  if (respAsignacion is Success<RolPOSTResponse>) {
                                                                                    ProgressDialog.dissmiss(context);
                                                                                    Dialogs.alert(context, tittle: "Asignacion exitosa", description: [""]);
                                                                                    ProgressDialog.dissmiss(context);
                                                                                    ProgressDialog.dissmiss(context);
                                                                                    setState(
                                                                                      () {},
                                                                                    );
                                                                                    notifyListeners();
                                                                                  } else {
                                                                                    if (respAsignacion is Failure) {
                                                                                      ProgressDialog.dissmiss(context);
                                                                                      Dialogs.alert(context, tittle: "Asignacion fallida", description: respAsignacion.messages);
                                                                                    }
                                                                                  }
                                                                                }
                                                                              })
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  [
                                                                    DataTable(
                                                                        onSelectAll:
                                                                            (isSelectedAll) {
                                                                          setState(() =>
                                                                              {
                                                                                selectedPermisos2 = isSelectedAll! ? respPermisos.response.data : [],
                                                                                isSelect = isSelectedAll
                                                                              });
                                                                        },
                                                                        columns: const [
                                                                          DataColumn(
                                                                            label:
                                                                                Text("Permiso"),
                                                                          ),
                                                                        ],
                                                                        rows: respPermisos
                                                                            .response
                                                                            .data
                                                                            .map((e) =>
                                                                                DataRow(
                                                                                    selected: selectedPermisos2.contains(e),
                                                                                    onSelectChanged: (isSelected) => setState(() {
                                                                                          final isAdding = isSelected != null && isSelected;
                                                                                          if (!isSelect) {
                                                                                            isAdding ? selectedPermisos2.add(e) : selectedPermisos2.remove(e);
                                                                                          }
                                                                                        }),
                                                                                    cells: [
                                                                                      DataCell(
                                                                                        Text(
                                                                                          e.descripcion,
                                                                                        ),
                                                                                      ),
                                                                                    ]))
                                                                            .toList())
                                                                  ],
                                                                  /* resp.response.data
                              .map((e) => Text(
                                    e.descripcion,
                                    style: appDropdown,
                                  ))
                              .toList(), */
                                                                  size),
                                                        );
                                                      });
                                                    });
                                              } else if (respPermisos
                                                  is Failure) {
                                                ProgressDialog.dissmiss(
                                                    context);
                                                Dialogs.alert(context,
                                                    tittle: respPermisos
                                                        .supportMessage,
                                                    description:
                                                        respPermisos.messages);
                                              }
                                            })
                                      ],
                                    )),
                                    const DataColumn(label: Text("Actualizar")),
                                    const DataColumn(label: Text("Eliminar")),
                                  ],
                                  rows: resp.response.data
                                      .map((e) => DataRow(
                                              selected:
                                                  selectedPermisos.contains(e),
                                              onSelectChanged: (isSelected) =>
                                                  setState(() {
                                                    final isAdding =
                                                        isSelected != null &&
                                                            isSelected;
                                                    if (!isSelect) {
                                                      isAdding
                                                          ? selectedPermisos
                                                              .add(e)
                                                          : selectedPermisos
                                                              .remove(e);
                                                    }
                                                  }),
                                              cells: [
                                                DataCell(
                                                  Text(
                                                    e.descripcion,
                                                  ),
                                                  onTap: () {},
                                                ),
                                                DataCell(IconButton(
                                                    onPressed: () async {
                                                      ProgressDialog.show(
                                                          context);
                                                      var resp = await _rolesApi
                                                          .updatePermisoRol(
                                                              currentRowData.id,
                                                              selectedPermisos);
                                                      if (resp is Success<
                                                          RolPOSTResponse>) {
                                                        ProgressDialog.dissmiss(
                                                            context);
                                                        Dialogs.alert(context,
                                                            tittle:
                                                                "Actualizado con exito",
                                                            description: [""]);
                                                        notifyListeners();
                                                      } else if (resp
                                                          is Failure) {
                                                        ProgressDialog.dissmiss(
                                                            context);
                                                        Dialogs.alert(context,
                                                            tittle:
                                                                "Actualizacion fallida",
                                                            description:
                                                                resp.messages);
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        Icons.cached))),
                                                DataCell(IconButton(
                                                    onPressed: () {
                                                      Dialogs.confirm(context,
                                                          tittle:
                                                              "Eliminar Permiso",
                                                          description:
                                                              "Esta seguro que desea eliminar el permiso?",
                                                          confirm: () async {
                                                        ProgressDialog.show(
                                                            context);
                                                        var resp = await _rolesApi
                                                            .deletePermisosRol(
                                                                currentRowData
                                                                    .id,
                                                                selectedPermisos);
                                                        if (resp is Success<
                                                            RolPOSTResponse>) {
                                                          ProgressDialog
                                                              .dissmiss(
                                                                  context);
                                                          Dialogs.alert(context,
                                                              tittle:
                                                                  "Eliminado con exito",
                                                              description: [
                                                                ""
                                                              ]);
                                                          setState(
                                                            () {},
                                                          );
                                                          notifyListeners();
                                                        } else if (resp
                                                            is Failure) {
                                                          ProgressDialog
                                                              .dissmiss(
                                                                  context);
                                                          Dialogs.alert(context,
                                                              tittle:
                                                                  "Eliminacion fallida",
                                                              description: resp
                                                                  .messages);
                                                        }
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.cancel_outlined)))
                                              ]))
                                      .toList())
                            ],
                            size),
                      );
                    });
                  });
            } else if (resp is Failure) {
              ProgressDialog.dissmiss(context);
              Dialogs.alert(context,
                  tittle: "Error de conexion", description: resp.messages);
            }
          },
        ),
      ),
      DataCell(Text(currentRowData.description)),
      DataCell(IconButton(
          onPressed: () async {
            // GlobalKey<FormState> _key = GlobalKey();
            String titulo = "Actualizar Rol";
            final GlobalKey<FormState> _formKey = GlobalKey();
            const String buttonTittle = "Modificar";
            String nombre = "";
            String descripcion = "";
            bool validator = true;
            List<Widget> informacion = [];
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: ActualizarRolForm(
                          formKey: _formKey,
                          size: size,
                          titulo: titulo,
                          informacion: informacion,
                          validator: validator,
                          modificar: (nombref, descripcionf) async {
                            ProgressDialog.show(context);
                            var resp = await _rolesApi.updateRol(
                                currentRowData.id, nombref, descripcionf);
                            if (resp is Success<RolPOSTResponse>) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.alert(context,
                                  tittle: "Modificacion Exitosa",
                                  description: [
                                    "Se ha modificado el rol con exito"
                                  ]);
                              currentPage = 0;
                              offset = 0;
                              totalCount = 0;
                              data = [];
                              setNextView();
                            } else if (resp is Failure) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.alert(context,
                                  tittle: "Modificacion fallida",
                                  description: resp.messages);
                            }
                          },
                          descripcion: descripcion,
                          buttonTittle: buttonTittle,
                          nombre: nombre),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ));
                });
          },
          icon: const Icon(Icons.cached))),
      DataCell(IconButton(
          onPressed: () async {
            Dialogs.confirm(context,
                tittle: "Eliminar Rol",
                description: "Esta seguro que desea eliminar el rol?",
                confirm: () async {
              ProgressDialog.show(context);
              var resp = await _rolesApi.deleteRol(currentRowData.id);
              if (resp is Success<RolPOSTResponse>) {
                ProgressDialog.dissmiss(context);
                Dialogs.alert(context,
                    tittle: "Eliminado con exito",
                    description: ["Eliminacion realizada"]);
                currentPage = 0;
                offset = 0;
                totalCount = 0;
                data = [];
                setNextView();
              } else if (resp is Failure) {
                ProgressDialog.dissmiss(context);
                Dialogs.alert(context,
                    tittle: "Eliminacion fallida", description: resp.messages);
              }
            });
          },
          icon: const Icon(Icons.cancel_outlined))),
    ]);
  }

  @override
  int get selectedRowCount => 0;
  int currentPage = 0;
  int offset = 0;
  int totalCount = 0;
  List<RolData> data = [];
  @override
  Future<RemoteDataSourceDetails<RolData>> getNextPage(
      NextPageRequest pageRequest) async {
    var resp = await _rolesApi.getRoles();
    if (resp is Success<RolResponse>) {
      for (var element in resp.response.data) {
        data.add(element);
      }
      return RemoteDataSourceDetails(
          resp.response.data.length, resp.response.data);
    } else if (resp is Failure) {
      Dialogs.alert(context,
          tittle: "Error de Conexion",
          description: ["Fallo al conectar a la red"]);
    }
    throw Exception('Unable to query remote server');
  }
}
