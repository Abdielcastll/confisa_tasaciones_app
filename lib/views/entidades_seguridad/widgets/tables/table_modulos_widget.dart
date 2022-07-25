import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/modulos_response.dart';
import 'package:tasaciones_app/widgets/app_buttons.dart';

import '../../../../core/api/api_status.dart';
import '../../../../core/api/modulos_api.dart';
import '../../../../core/authentication_client.dart';
import '../../../../core/locator.dart';
import '../../../../theme/theme.dart';
import '../../../../widgets/app_dialogs.dart';

class PaginatedTableModulos {
  late BuildContext context;
  PaginatedTableModulos({required this.context});

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
        source: TableModulos(pageSize: 12, context: context),
        columns: const [
          DataColumn(label: Text('Nombre')),
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

class TableModulos extends AdvancedDataTableSource<ModulosData> {
  TableModulos({required this.pageSize, required this.context});
  late BuildContext context;
  final user = locator<AuthenticationClient>().loadSession;
  final _modulosApi = locator<ModulosApi>();

  @override
  bool get forceRemoteReload => super.forceRemoteReload = true;

  int pageSize;
  TextEditingController tcNewName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(cells: [
      DataCell(
        Text(currentRowData.nombre),
      ),

      // ACTUALIZAR ACCION:::

      DataCell(
        const Icon(Icons.cached),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 2,
                      color: AppColors.orange,
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 80,
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: AppColors.orange,
                          child: Text(
                            'Actualizar Módulo: ${currentRowData.nombre}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: tcNewName,
                              validator: (value) {
                                if (value!.trim() == '') {
                                  return 'Escriba un nombre';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AppButton(
                                text: 'Atrás',
                                onPressed: () {
                                  tcNewName.clear();
                                  Navigator.of(context).pop();
                                },
                                color: AppColors.orange),
                            AppButton(
                                text: 'Guardar',
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    ProgressDialog.show(context);
                                    var resp = await _modulosApi.updateModulos(
                                        name: tcNewName.text,
                                        id: currentRowData.id);
                                    ProgressDialog.dissmiss(context);
                                    if (resp is Success) {
                                      Navigator.of(context).pop();

                                      Dialogs.success(
                                          msg: 'Módulo Actualizado');
                                    }

                                    if (resp is Failure) {
                                      ProgressDialog.dissmiss(context);
                                      Dialogs.error(msg: resp.messages[0]);
                                    }
                                    tcNewName.clear();
                                  }
                                },
                                color: Colors.green),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      DataCell(
        const Icon(Icons.cancel_outlined),
        onTap: () {
          Dialogs.confirm(context,
              tittle: 'Eliminar Módulo',
              description:
                  '¿Esta seguro de eliminar el módulo ${currentRowData.nombre}?',
              confirm: () async {
            ProgressDialog.show(context);
            var resp = await _modulosApi.deleteModulos(id: currentRowData.id);
            ProgressDialog.dissmiss(context);
            if (resp is Failure) {
              Dialogs.error(msg: resp.messages[0]);
            }
            if (resp is Success) {
              Dialogs.success(msg: 'Módulo eliminado');
            }
          });
        },
      ),
    ]);
  }

  @override
  int get selectedRowCount => 0;
  int currentPage = 0;
  int offset = 0;
  int totalCount = 0;
  List<ModulosData> data = [];
  @override
  Future<RemoteDataSourceDetails<ModulosData>> getNextPage(
      NextPageRequest pageRequest) async {
    var resp;
    if (offset > pageRequest.offset) {
      currentPage = currentPage - 1;
      resp = await _modulosApi.getModulos(
          pageNumber: currentPage, pageSize: pageRequest.pageSize);
    } else if (currentPage != 0) {
      resp = await _modulosApi.getModulos(
          pageNumber: currentPage + 1, pageSize: pageRequest.pageSize);
      currentPage = currentPage + 1;
    } else {
      resp = await _modulosApi.getModulos(
          pageNumber: currentPage + 1, pageSize: pageRequest.pageSize);
      currentPage = currentPage + 1;
    }

    if (resp is Success<ModulosResponse>) {
      for (var element in resp.response.data) {
        data.add(element);
      }
      offset = pageRequest.offset;
      totalCount = resp.response.totalCount;
      return RemoteDataSourceDetails(
          resp.response.totalCount, resp.response.data);
    } else if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    throw Exception('Unable to query remote server');
  }
}
