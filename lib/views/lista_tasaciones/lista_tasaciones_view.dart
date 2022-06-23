import 'dart:math';

import 'package:confisa_tasaciones_app/constants.dart';
import 'package:confisa_tasaciones_app/core/theme.dart';
import 'package:confisa_tasaciones_app/widgets/appbar_example.dart';
import 'package:flutter/material.dart';

class ListaTasacionesView extends StatelessWidget {
  static const routeName = 'lista_tasaciones';
  ListaTasacionesView({Key? key}) : super(key: key);
  final DataTableSource _data = MyData();
  @override
  String dropdownvalue = 'Todos';

  // List of items in our dropdown menu
  var items = [
    'Todos',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          const AppbarExample(titulo: "Listado de Tasaciones", textSize: 15),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.brownLight,
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                      width: 150,
                      height: 35,
                      child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          style: appDropdown,
                          borderRadius: BorderRadius.circular(15),
                          dropdownColor: AppColors.brownLight,
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {},
                          value: dropdownvalue,

                          // Down Arrow Icon
                          icon: const Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ))),
                ),
              ),
              PaginatedDataTable(
                source: _data,
                columns: const [
                  DataColumn(
                    label: Text('No.Tasación'),
                  ),
                  DataColumn(
                    label: Text('No.Solicitud'),
                  ),
                  DataColumn(label: Text('Cliente')),
                  DataColumn(label: Text('Fecha'))
                ],
                columnSpacing: 30,
                rowsPerPage: 12,
                showCheckboxColumn: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  // Generate some made-up data
  final List<Map<String, dynamic>> _data = List.generate(
      200,
      (index) => {
            "No.Tasación": index + 1,
            "No.Solicitud": index + 1,
            "Cliente": "Item $index",
            "Fecha": Random().nextInt(10000)
          });

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['No.Tasación'].toString())),
      DataCell(Text(_data[index]['No.Solicitud'].toString())),
      DataCell(Text(_data[index]["Cliente"])),
      DataCell(Text(_data[index]["Fecha"].toString())),
    ], color: MaterialStateColor.resolveWith((states) => Colors.white));
  }
}
