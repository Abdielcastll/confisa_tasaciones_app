import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/acciones_api.dart';
import '../../../../core/api/api_status.dart';
import '../../../../core/api/permisos_api.dart';
import '../../../../core/api/recursos_api.dart';
import '../../../../core/authentication_client.dart';
import '../../../../core/locator.dart';
import '../../../../core/models/acciones_response.dart';
import '../../../../core/models/permisos_response.dart';
import '../../../../theme/theme.dart';
import '../../../../core/models/recursos_response.dart';
import '../../../../widgets/app_dialogs.dart';

class PaginatedTablePermisos {
  late BuildContext context;
  PaginatedTablePermisos({required this.context});

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
        source: TablePermisos(pageSize: 12, context: context),
        columns: const [
          DataColumn(
            label: Text('Nombre'),
          ),
          DataColumn(label: Text('Actualizar')),
          DataColumn(label: Text('Eliminar'))
        ],
        columnSpacing: 20,
        rowsPerPage: 12,
        showCheckboxColumn: false,
        dataRowHeight: (MediaQuery.of(context).size.height - 260) / 12,
      ),
    );
  }
}

class TablePermisos extends AdvancedDataTableSource<PermisosData> {
  TablePermisos({required this.pageSize, required this.context});
  late BuildContext context;
  final user = locator<AuthenticationClient>().loadSession;
  final _accionesApi = locator<AccionesApi>();
  final _recursosApi = locator<RecursosAPI>();
  final _permisosApi = locator<PermisosAPI>();

  @override
  bool get forceRemoteReload => super.forceRemoteReload = true;

  int pageSize;

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(cells: [
      DataCell(
        Text(currentRowData.descripcion),
      ),
      DataCell(IconButton(
          onPressed: () async {
            // GlobalKey<FormState> _key = GlobalKey();
            ProgressDialog.show(context);
            var resp = await _accionesApi.getAcciones();
            if (resp is Success<AccionesResponse>) {
              var resp2 = await _recursosApi.getRecursos();
              if (resp2 is Success<RecursosResponse>) {
                ProgressDialog.dissmiss(context);
                final GlobalKey<FormState> _formKey = GlobalKey();
                /* showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: formCrearPermiso(
                              "Modificacion de Permiso",
                              _formKey,
                              descripcion,
                              recurso,
                              accion, (String descripcionf) async {
                            ProgressDialog.show(context);
                            var creacion = await _permisosApi.updatePermisos(
                                id: currentRowData.id,
                                descripcion: descripcionf,
                                idAccion: accion["id"] ?? 0,
                                idRecurso: recurso["id"] ?? 0,
                                esBasico: 1);
                            if (creacion is Success<PermisosPOSTResponse>) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.success(msg: "Modificacion exitosa");
                              currentPage = 0;
                              offset = 0;
                              totalCount = 0;
                              data = [];
                              _formKey.currentState?.reset();
                              setNextView();
                            } else if (creacion is Failure) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.error(msg: creacion.messages.first);
                            }
                          },
                              () {},
                              opcion,
                              resp.response.data,
                              resp2.response.data,
                              [
                                Text("Permiso: ${currentRowData.descripcion}",
                                    style: appDropdown),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text("Accion: ${currentRowData.accionNombre}",
                                    style: appDropdown),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text("Recurso: ${currentRowData.recursoNombre}",
                                    style: appDropdown)
                              ],
                              size,
                              true,
                              "Modificar",
                              false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ));
                    }); */
              } else if (resp2 is Failure) {
                ProgressDialog.dissmiss(context);
                Dialogs.error(msg: resp2.messages.first);
              }
            } else if (resp is Failure) {
              ProgressDialog.dissmiss(context);
              Dialogs.error(msg: resp.messages.first);
            }
          },
          icon: const Icon(Icons.cached))),
      DataCell(IconButton(
          onPressed: () async {
            Dialogs.confirm(context,
                tittle: "Eliminar Permiso",
                description: "Esta seguro que desea eliminar el permiso?",
                confirm: () async {
              ProgressDialog.show(context);
              var resp =
                  await _permisosApi.deletePermisos(id: currentRowData.id);
              if (resp is Success<PermisosPOSTResponse>) {
                ProgressDialog.dissmiss(context);
                Dialogs.success(msg: "Eliminado con exito");
                currentPage = 0;
                offset = 0;
                totalCount = 0;
                data = [];
                setNextView();
              } else if (resp is Failure) {
                ProgressDialog.dissmiss(context);
                Dialogs.error(msg: resp.messages.first);
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
  List<PermisosData> data = [];
  @override
  Future<RemoteDataSourceDetails<PermisosData>> getNextPage(
      NextPageRequest pageRequest) async {
    var resp;
    if (offset > pageRequest.offset) {
      currentPage = currentPage - 1;
      resp = await _permisosApi.getPermisos(
          pageNumber: currentPage, pageSize: pageRequest.pageSize);
    } else if (currentPage != 0) {
      resp = await _permisosApi.getPermisos(
          pageNumber: currentPage + 1, pageSize: pageRequest.pageSize);
      currentPage = currentPage + 1;
    } else {
      resp = await _permisosApi.getPermisos(
          pageNumber: currentPage + 1, pageSize: pageRequest.pageSize);
      currentPage = currentPage + 1;
    }

    if (resp is Success<PermisosResponse>) {
      for (var element in resp.response.data) {
        data.add(element);
      }
      offset = pageRequest.offset;
      totalCount = resp.response.totalCount;
      return RemoteDataSourceDetails(
          resp.response.totalCount, resp.response.data);
    } else if (resp is Failure) {
      Dialogs.error(msg: resp.messages.first);
    }
    throw Exception('Unable to query remote server');
  }
}
