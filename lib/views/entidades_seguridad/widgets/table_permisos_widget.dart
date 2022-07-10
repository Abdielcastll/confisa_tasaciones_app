import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';

import '../../../core/api/api_status.dart';
import '../../../core/api/permisos_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/locator.dart';
import '../../../core/models/permisos_response.dart';

class PaginatedTablePermisos extends StatelessWidget {
  const PaginatedTablePermisos({Key? key, required this.source})
      : super(key: key);
  final AdvancedDataTableSource<dynamic> source;
  @override
  Widget build(BuildContext context) {
    return AdvancedPaginatedDataTable(
      source: TablePermisos(pageSize: 12),
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
  TablePermisos({required this.pageSize});
  final user = locator<AuthenticationClient>().loadSession;
  final _permisosAPI = locator<PermisosAPI>();
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
      DataCell(IconButton(onPressed: () {}, icon: const Icon(Icons.cached))),
      DataCell(IconButton(
          onPressed: () {}, icon: const Icon(Icons.cancel_outlined))),
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
      var resp = await _permisosAPI.getPermisos(
          token: user.token,
          pageNumber: currentPage + 1,
          pageSize: pageRequest.pageSize);
      if (resp is Success<PermisosResponse>) {
        for (var element in resp.response.data) {
          data.add(element);
        }
        offset = pageRequest.offset;
        totalCount = resp.response.totalCount;
        currentPage = currentPage + 1;
        return RemoteDataSourceDetails(
            resp.response.totalCount, resp.response.data);
      } else if (resp is Failure) {}
    }

    throw Exception('Unable to query remote server');
  }
}
