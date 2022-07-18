import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/endpoints_api.dart';
import 'package:tasaciones_app/core/models/endpoints_response.dart';

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

  @override
  bool get forceRemoteReload => super.forceRemoteReload = true;

  int pageSize;

  @override
  DataRow? getRow(int index) {
    final Size size = MediaQuery.of(context).size;
    final currentRowData = lastDetails!.rows[index];
    return DataRow(cells: [
      DataCell(
        Text(currentRowData.nombre),
      ),
      DataCell(Text(currentRowData.permiso.descripcion)),
      DataCell(IconButton(
          onPressed: () async {
            final GlobalKey<FormState> _formKey = GlobalKey();
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
                            Dialogs.alert(context,
                                tittle: "Modificacion de endpoint exitosa",
                                description: [
                                  "Se ha modificado el  endpoint con exito"
                                ]);
                          } else if (resp is Failure) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.alert(context,
                                tittle: "Modificacion fallida",
                                description: resp.messages);
                          }
                        },
                        controlador: controlador,
                        buttonTittle: buttonTittle,
                        nombre: nombre,
                        httpVerbo: httpVerbo,
                        metodo: metodo),
                  );
                });
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
                Dialogs.alert(context,
                    tittle: "Eliminado con exito",
                    description: ["Endpoint eliminado."]);
                currentPage = 0;
                offset = 0;
                totalCount = 0;
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
      Dialogs.alert(context,
          tittle: "Error de Conexion", description: resp.messages);
    }
    throw Exception('Unable to query remote server');
  }
}
