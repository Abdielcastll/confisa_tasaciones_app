import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/form_crear_permiso.dart';

import '../../../core/api/acciones_api.dart';
import '../../../core/api/api_status.dart';
import '../../../core/api/permisos_api.dart';
import '../../../core/api/recursos_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/locator.dart';
import '../../../core/models/acciones_response.dart';
import '../../../core/models/permisos_response.dart';
import '../../../core/models/recursos_response.dart';
import '../../../widgets/app_circle_icon_button.dart';
import '../../../widgets/app_dialogs.dart';

class PaginatedTablePermisos {
  late BuildContext context;
  PaginatedTablePermisos({required this.context});
  AdvancedPaginatedDataTable table() {
    return AdvancedPaginatedDataTable(
      loadingWidget: () => const Center(child: CircularProgressIndicator()),
      errorWidget: () => const Center(child: CircularProgressIndicator()),
      source: TablePermisos(pageSize: 12, context: context),
      columns: const [
        DataColumn(
          label: Text('Indice'),
        ),
        DataColumn(
          label: Text('Nombre'),
        ),
        DataColumn(label: Text('Actualizar')),
        DataColumn(label: Text('Eliminar'))
      ],
      columnSpacing: 30,
      rowsPerPage: 12,
      showCheckboxColumn: false,
    );
  }
}

class TablePermisos extends AdvancedDataTableSource<PermisosData> {
  TablePermisos({required this.pageSize, required this.context});
  late BuildContext context;
  final user = locator<AuthenticationClient>().loadSession;
  final _accionesApi = locator<AccionesAPI>();
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
        Text((data.indexWhere((element) => element == currentRowData) + 1)
            .toString()),
      ),
      DataCell(
        Text(currentRowData.descripcion),
      ),
      DataCell(IconButton(
          onPressed: () async {
            GlobalKey<FormState> _key = GlobalKey();
            String descripcion = currentRowData.descripcion;
            Map<String, dynamic> accion = {};
            Map<String, dynamic> recurso = {};
            dynamic opcion;
            ProgressDialog.show(context);
            var resp = await _accionesApi.getAcciones();
            if (resp is Success<AccionesResponse>) {
              var resp2 = await _recursosApi.getRecursos();
              if (resp2 is Success<RecursosResponse>) {
                ProgressDialog.dissmiss(context);
                final GlobalKey<FormState> _formKey = GlobalKey();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          clipBehavior: Clip.none,
                          content: formCrearPermiso(
                            _formKey,
                            descripcion,
                            recurso,
                            accion,
                            (String descripcionf) async {
                              ProgressDialog.show(context);
                              var creacion = await _permisosApi.createPermisos(
                                  descripcion: descripcionf,
                                  idAccion: accion["id"],
                                  idRecurso: recurso["id"],
                                  esBasico: 1);
                              if (creacion is Success<PermisosData>) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.alert(context,
                                    tittle: "Modificacion exitosa",
                                    description: [
                                      "Permiso modificado con exito"
                                    ]);
                                _formKey.currentState?.reset();
                              } else if (creacion is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.alert(context,
                                    tittle: creacion.supportMessage,
                                    description: creacion.messages);
                              }
                            },
                            opcion,
                            resp.response.data,
                            resp2.response.data,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ));
                    });
              } else if (resp2 is Failure) {
                ProgressDialog.dissmiss(context);
                Dialogs.alert(
                  context,
                  tittle: 'Error',
                  description: resp2.messages,
                );
              }
            } else if (resp is Failure) {
              ProgressDialog.dissmiss(context);
              Dialogs.alert(
                context,
                tittle: 'Error',
                description: resp.messages,
              );
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
                Dialogs.alert(context,
                    tittle: "Eliminado con exito",
                    description: ["description"]);
                currentPage = 0;
                offset = 0;
                totalCount = 0;
                data = [];
                setNextView();
              } else if (resp is Failure) {
                ProgressDialog.dissmiss(context);
                Dialogs.alert(context,
                    tittle: "Eliminacion fallida",
                    description: ["description"]);
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
    if (offset > pageRequest.offset) {
      currentPage = currentPage - 1;
      data.removeRange(offset, offset + pageSize);
      var dataPerRange = data.getRange(pageRequest.offset, offset);
      var dataList = dataPerRange.map((e) => e).toList();
      offset = pageRequest.offset;
      return RemoteDataSourceDetails(totalCount, dataList);
    } else {
      var resp = await _permisosApi.getPermisos(
          pageNumber: currentPage + 1, pageSize: pageRequest.pageSize);
      if (resp is Success<PermisosResponse>) {
        for (var element in resp.response.data) {
          data.add(element);
        }
        offset = pageRequest.offset;
        totalCount = resp.response.totalCount;
        currentPage = currentPage + 1;
        return RemoteDataSourceDetails(
            resp.response.totalCount, resp.response.data);
      } else if (resp is Failure) {
        Dialogs.alert(context,
            tittle: "Error de Conexion",
            description: ["Fallo al conectar a la red"]);
      }
      throw Exception('Unable to query remote server');
    }
  }
}
