import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/form_crear_permiso.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/mostrar_informacion_widget.dart';

import '../../../core/api/usuarios_api.dart';
import '../../../core/api/api_status.dart';
import '../../../core/authentication_client.dart';
import '../../../core/locator.dart';
import '../../../core/models/usuarios_response.dart';
import '../../../theme/theme.dart';
import '../../../widgets/app_dialogs.dart';

class PaginatedTableUsuarios {
  late BuildContext context;
  PaginatedTableUsuarios({required this.context});

  Widget table() {
    GlobalKey key = GlobalKey();
    key.currentState?.dispose;
    return SingleChildScrollView(
      child: AdvancedPaginatedDataTable(
        key: key,
        loadingWidget: () => Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * .30),
          child: const CircularProgressIndicator(color: AppColors.brownDark),
        ),
        errorWidget: () => Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * .30),
          child: const CircularProgressIndicator(color: AppColors.brownDark),
        ),
        source: TableUsuarios(pageSize: 12, context: context),
        columns: const [
          DataColumn(
            label: Text('Nombre'),
          ),
          DataColumn(
            label: Text('Correo'),
          ),
          DataColumn(label: Text('Actualizar'))
        ],
        columnSpacing: 30,
        rowsPerPage: 12,
        showCheckboxColumn: false,
      ),
    );
  }
}

class TableUsuarios extends AdvancedDataTableSource<UsuariosData> {
  TableUsuarios({required this.pageSize, required this.context});
  late BuildContext context;
  final user = locator<AuthenticationClient>().loadSession;
  final _usuariosAPI = locator<UsuariosAPI>();

  int pageSize;
  @override
  bool get forceRemoteReload => super.forceRemoteReload = true;

  @override
  DataRow? getRow(int index) {
    Size size = MediaQuery.of(context).size;
    final currentRowData = lastDetails!.rows[index];
    return DataRow(cells: [
      DataCell(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              child: Text(currentRowData.nombreCompleto),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: AppColors.darkOrange, width: 6)),
                        contentPadding: EdgeInsets.zero,
                        content: dialogMostrarInformacion(
                            Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.grey,
                              ),
                              height: 100,
                              width: 100,
                              child: const Icon(
                                Icons.person,
                                size: 70,
                              ),
                            ),
                            [
                              Text(currentRowData.nombreCompleto,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkOrange)),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(currentRowData.email,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkOrange)),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("Suplidor ${currentRowData.nombreSuplidor}",
                                  style: appDropdown),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("Roles ${currentRowData.nombreSuplidor}",
                                  style: appDropdown),
                              Column(
                                children: currentRowData.roles
                                    .map((e) => Text(e, style: appDropdown))
                                    .toList(),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Telefono ${currentRowData.phoneNumber}",
                                style: appDropdown,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              currentRowData.isActive
                                  ? Text("Estado Activo", style: appDropdown)
                                  : Text("Estado Inactivo", style: appDropdown)
                            ],
                            size),
                      );
                    });
              },
            ),
          ],
        ),
      ),
      DataCell(
        Text(currentRowData.email),
      ),
      DataCell(IconButton(
          onPressed: () {
            _usuariosAPI.getUsuario(id: currentRowData.id.toString());
          },
          icon: const Icon(Icons.person))),
    ]);
  }

  @override
  int get selectedRowCount => 0;
  int currentPage = 0;
  int offset = 0;
  int totalCount = 0;
  List<UsuariosData> data = [];
  @override
  Future<RemoteDataSourceDetails<UsuariosData>> getNextPage(
      NextPageRequest pageRequest) async {
    var resp;
    if (offset > pageRequest.offset) {
      currentPage = currentPage - 1;
      resp = await _usuariosAPI.getUsuarios(
          pageNumber: currentPage, pageSize: pageRequest.pageSize);
    } else if (currentPage != 0) {
      resp = await _usuariosAPI.getUsuarios(
          pageNumber: currentPage + 1, pageSize: pageRequest.pageSize);
      currentPage = currentPage + 1;
    } else {
      resp = await _usuariosAPI.getUsuarios(
          pageNumber: currentPage + 1, pageSize: pageRequest.pageSize);
      currentPage = currentPage + 1;
    }

    if (resp is Success<UsuariosResponse>) {
      for (var element in resp.response.data) {
        data.add(element);
      }
      for (var element in resp.response.data) {
        var resp2 = await _usuariosAPI.getRolUsuario(id: element.id);
        if (resp2 is Success<RolUsuarioResponse>) {
          for (var element2 in resp2.response.data) {
            element.roles.add(element2.description);
            element.idRoles.add(element2.roleId);
          }
          offset = pageRequest.offset;
          totalCount = resp.response.totalCount;
          return RemoteDataSourceDetails(
              resp.response.totalCount, resp.response.data);
        } else if (resp2 is Failure) {
          Dialogs.alert(context,
              tittle: "Error de Conexion",
              description: ["Fallo al conectar a la red"]);
          throw Exception('Unable to query remote server');
        }
      }
      return RemoteDataSourceDetails(
          resp.response.totalCount, resp.response.data);
    } else if (resp is Failure) {
      Dialogs.alert(context,
          tittle: "Error de Conexion",
          description: ["Fallo al conectar a la red"]);
      throw Exception('Unable to query remote server');
    }

    throw Exception('Unable to query remote server');
  }
}
