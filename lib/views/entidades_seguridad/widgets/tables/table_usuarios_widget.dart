import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/actualizar_informacion.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/mostrar_informacion_widget.dart';

import '../../../../core/api/roles_api.dart';
import '../../../../core/api/usuarios_api.dart';
import '../../../../core/api/api_status.dart';
import '../../../../core/authentication_client.dart';
import '../../../../core/locator.dart';
import '../../../../core/models/usuarios_response.dart';
import '../../../../theme/theme.dart';
import '../../../../widgets/app_dialogs.dart';

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
  final _rolesAPI = locator<RolesAPI>();

  int pageSize;
  @override
  bool get forceRemoteReload => super.forceRemoteReload = true;

  @override
  DataRow? getRow(int index) {
    Size size = MediaQuery.of(context).size;
    final currentRowData = lastDetails!.rows[index];
    return DataRow(cells: [
      DataCell(
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
                          Text("Roles", style: appDropdown),
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
                              : Text("Estado Inactivo", style: appDropdown),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: AppColors.green,
                                minimumSize: const Size.fromHeight(60)),
                            onPressed: () async {
                              ProgressDialog.show(context);
                              var creacion =
                                  await _usuariosAPI.updateStatusUsuario(
                                      id: currentRowData.id,
                                      status: !currentRowData.isActive);
                              if (creacion is Success<UsuarioPOSTResponse>) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.alert(context,
                                    tittle: "Estado actualizado",
                                    description: [
                                      "Se ha actualizado el estado de forma exitosa"
                                    ]);
                              } else if (creacion is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.alert(context,
                                    tittle: creacion.supportMessage,
                                    description: creacion.messages);
                              }
                            },
                            child: const Text("Cambiar Estado"),
                          ),
                        ],
                        size),
                  );
                });
          },
        ),
      ),
      DataCell(
        Text(currentRowData.email),
      ),
      DataCell(IconButton(
          onPressed: () async {
            String email = "", telefono = "", nombre = "";
            GlobalKey<FormState> _key = GlobalKey();
            var dropdown;
            Map<String, dynamic> rol1 = {};
            Map<String, dynamic> rol2 = {};
            ProgressDialog.show(context);
            var resp = await _rolesAPI.getRoles();
            if (resp is Success<RolResponse>) {
              ProgressDialog.dissmiss(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: AppColors.darkOrange, width: 6)),
                      contentPadding: EdgeInsets.zero,
                      content: dialogActualizarInformacion(
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
                          size,
                          context,
                          _key,
                          resp.response.data,
                          nombre,
                          telefono,
                          email,
                          true, (nombref, emailf, telefonof) async {
                        if (rol1["id"] != "") {
                          ProgressDialog.show(context);
                          var creacion = await _usuariosAPI.updateRolUsuario(
                              id: currentRowData.id, rol: rol1);
                          if (creacion is Success<UsuarioPOSTResponse>) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.alert(context,
                                tittle: "Rol asignado",
                                description: ["Rol asignado de forma exitosa"]);
                            _key.currentState?.reset();
                          } else if (creacion is Failure) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.alert(context,
                                tittle: creacion.supportMessage,
                                description: creacion.messages);
                          }
                        }
                        if (rol2["id"] != "") {
                          ProgressDialog.show(context);
                          var creacion = await _usuariosAPI.updateRolUsuario(
                              id: currentRowData.id, rol: rol2);
                          if (creacion is Success<UsuarioPOSTResponse>) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.alert(context,
                                tittle: "Rol asignado",
                                description: ["Rol asignado de forma exitosa"]);
                            _key.currentState?.reset();
                          } else if (creacion is Failure) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.alert(context,
                                tittle: creacion.supportMessage,
                                description: creacion.messages);
                          }
                        }
                        if (nombref != "" || emailf != "" || telefonof != "") {
                          ProgressDialog.show(context);
                          var creacion = await _usuariosAPI.updateUsuarios(
                              id: currentRowData.id,
                              email: emailf,
                              phoneNumber: telefonof,
                              fullName: nombref);
                          if (creacion is Success<UsuarioPOSTResponse>) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.alert(context,
                                tittle: "Modificacion de datos exitosa",
                                description: ["Exito al modificar usuario"]);
                            _key.currentState?.reset();
                          } else if (creacion is Failure) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.alert(context,
                                tittle: creacion.supportMessage,
                                description: creacion.messages);
                          }
                        }
                      }, dropdown, "Modificar", rol1, rol2),
                    );
                  });
            } else if (resp is Failure) {
              ProgressDialog.dissmiss(context);
              Dialogs.alert(context,
                  tittle: resp.supportMessage, description: resp.messages);
            }
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
        } else if (resp2 is Failure) {
          Dialogs.alert(context,
              tittle: "Error de Conexion",
              description: ["Fallo al conectar a la red"]);
          throw Exception('Unable to query remote server');
        }
      }
      offset = pageRequest.offset;
      totalCount = resp.response.totalCount;
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
