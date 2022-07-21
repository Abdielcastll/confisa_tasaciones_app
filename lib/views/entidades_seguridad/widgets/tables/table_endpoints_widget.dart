import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/endpoints_api.dart';
import 'package:tasaciones_app/core/models/endpoints_response.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/forms/form_asignar_permiso.dart';

import '../../../../core/api/api_status.dart';
import '../../../../core/api/permisos_api.dart';
import '../../../../core/authentication_client.dart';
import '../../../../core/locator.dart';
import '../../../../core/models/permisos_response.dart';
import '../../../../theme/theme.dart';
import '../../../../widgets/app_dialogs.dart';
import '../forms/form_crear_endpoint.dart';

class PaginatedTableEndpoints {
  late BuildContext context;
  PaginatedTableEndpoints({required this.context});

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
        source: TableEndpoints(pageSize: 12, context: context),
        columns: const [
          DataColumn(
            label: Text('Endpoint'),
          ),
          DataColumn(
            label: Text('Permiso'),
          ),
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

class TableEndpoints extends AdvancedDataTableSource<EndpointsData> {
  TableEndpoints({required this.pageSize, required this.context});
  late BuildContext context;
  final user = locator<AuthenticationClient>().loadSession;
  final _endpointApi = locator<EndpointsApi>();
  final _permisosApi = locator<PermisosAPI>();

  @override
  bool get forceRemoteReload => super.forceRemoteReload = true;

  int pageSize;

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    final Size size = MediaQuery.of(context).size;
    return DataRow(cells: [
      DataCell(
        TextButton(
          child: Text(currentRowData.nombre),
          onPressed: () async {
            final GlobalKey<FormState> _formKey = GlobalKey();
            bool validator = true;
            String buttonTittle = "Asignar";
            Map<String, dynamic> permiso = {};
            var opcion;
            ProgressDialog.show(context);
            var resp = await _permisosApi.getPermisos(pageSize: 999);
            if (resp is Success<PermisosResponse>) {
              ProgressDialog.dissmiss(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.zero,
                      content: formAsignarPermiso(
                        "Asignar Permiso",
                        _formKey,
                        permiso,
                        () async {
                          ProgressDialog.show(context);
                          var resp = await _endpointApi.assignPermisoEndpoint(
                              endpointId: currentRowData.id,
                              permisoId: permiso["id"]);
                          if (resp is Success<EndpointsPOSTResponse>) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.success(
                                msg: "Asignacion de Permiso exitosa");
                            currentPage = 0;
                            offset = 0;
                            totalCount = 0;
                            setNextView();
                          } else if (resp is Failure) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.error(msg: resp.messages[0]);
                          }
                        },
                        opcion,
                        resp.response.data,
                        size,
                        validator,
                        "Asignar",
                      ),
                    );
                  });
            }
          },
        ),
      ),
      DataCell(Text(
        currentRowData.permiso.descripcion,
      )),
      DataCell(IconButton(
          onPressed: () async {
            /* final GlobalKey<FormState> _formKey = GlobalKey();
            bool validator = false;
            String buttonTittle = "Modificar";
            String controlador = "";
            String nombre = "";
            String httpVerbo = "";
            String metodo = "";
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.zero,
                    content: CrearEndpointForm(
                        formKey: _formKey,
                        size: size,
                        titulo: "Modificar Endpoint",
                        informacion: [
                          Text("Nombre: ${currentRowData.nombre}",
                              style: appDropdown),
                          const SizedBox(
                            height: 3,
                          ),
                          Text("Controlador: ${currentRowData.controlador}",
                              style: appDropdown),
                          const SizedBox(
                            height: 3,
                          ),
                          Text("Metodo: ${currentRowData.metodo}",
                              style: appDropdown),
                          const SizedBox(
                            height: 3,
                          ),
                          Text("Verbo HTTP: ${currentRowData.httpVerbo}",
                              style: appDropdown),
                          const SizedBox(
                            height: 3,
                          ),
                          currentRowData.estado
                              ? Text("Estado Activo", style: appDropdown)
                              : Text("Estado Inactivo", style: appDropdown)
                        ],
                        validator: validator,
                        modificar:
                            (nombref, controladorf, metodof, httpVerbof) async {
                          ProgressDialog.show(context);
                          var resp = await _endpointApi.updateEndpoint(
                              id: currentRowData.id,
                              controlador: controladorf,
                              nombre: nombref,
                              metodo: metodof,
                              httpVerbo: httpVerbof);
                          if (resp is Success<EndpointsPOSTResponse>) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.success(
                                msg: "Modificacion de endpoint exitosa");
                          } else if (resp is Failure) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.error(msg: resp.messages[0]);
                          }
                        },
                        controlador: controlador,
                        buttonTittle: buttonTittle,
                        nombre: nombre,
                        httpVerbo: httpVerbo,
                        metodo: metodo),
                  );
                }); */
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
                  await _endpointApi.deleteEndpoint(id: currentRowData.id);
              if (resp is Success<EndpointsPOSTResponse>) {
                ProgressDialog.dissmiss(context);
                Dialogs.success(msg: "Eliminado con exito");
                currentPage = 0;
                offset = 0;
                totalCount = 0;
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
  @override
  Future<RemoteDataSourceDetails<EndpointsData>> getNextPage(
      NextPageRequest pageRequest) async {
    var resp;
    if (offset > pageRequest.offset) {
      currentPage = currentPage - 1;
      resp = await _endpointApi.getEndpoints(
          pageNumber: currentPage, pageSize: pageRequest.pageSize);
    } else if (currentPage != 0) {
      resp = await _endpointApi.getEndpoints(
          pageNumber: currentPage + 1, pageSize: pageRequest.pageSize);
      currentPage = currentPage + 1;
    } else {
      resp = await _endpointApi.getEndpoints(
          pageNumber: currentPage + 1, pageSize: pageRequest.pageSize);
      currentPage = currentPage + 1;
    }

    if (resp is Success<EndpointsResponse>) {
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
