import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/utils/numeric_text_formater.dart';
import 'package:tasaciones_app/widgets/app_buttons.dart';

import '../../../../../../theme/theme.dart';
import '../../../../base_widgets/base_form_widget.dart';
import '../../../../base_widgets/base_text_field_widget.dart';
import '../../../trabajar_view_model.dart';

class ValoracionEstimacionForm extends StatelessWidget {
  const ValoracionEstimacionForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final TrabajarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Valorar',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Anterior',
      onPressedBack: () => vm.currentForm = 3,
      iconNext: AppIcons.save,
      labelNext: '',
      isValoracion: true,
      onPressedNext: () => print('valorado'),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            BaseTextFieldNoEdit(
              label: 'Consulta de salvamento',
              initialValue: vm.isSalvageDesc?.toUpperCase() ?? 'NO',
            ),
            BaseTextFieldNoEdit(
              label: 'Tasación promedio',
              initialValue: '${vm.tasacionPromedio}',
            ),
            const SizedBox(height: 20),
            const Text(
              'Referencias',
              style: TextStyle(color: AppColors.brownDark, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: AppColors.brownDark),
              columnWidths: const {
                0: FractionColumnWidth(0.50),
                1: FractionColumnWidth(0.50),
              },
              children: [
                builRow(
                  ['Fuente', 'Valor'],
                  isHeader: true,
                ),
                ...vm.referencias.map((e) => builRow([
                      '${e.fuente}',
                      e.resultado! ? '${e.valor}' : '${e.mensaje}'
                    ])),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Text(
                  'Observaciones',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: AppColors.brownDark),
                ),
              ],
            ),
            const SizedBox(height: 3),
            SizedBox(
              height: 200,
              child: TextField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  filled: true,
                  isDense: true,
                  // hintText: 'Observaciones',

                  border: InputBorder.none,
                ),
                maxLength: 500,
                maxLines: null,
                expands: true,
                controller: vm.tcObservacion,
              ),
            ),
            // BaseTextField(
            //   label: 'Observaciónes',
            //   controller: vm.tcObservacion,
            //   maxLength: 500,
            // ),
            // const SizedBox(height: 10),
            Form(
              key: vm.formKeyValor,
              child: BaseTextField(
                label: 'Valor Tasación',
                controller: vm.tcValor,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == '') {
                    return 'Ingrese el Valor';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
                text: 'Valorar',
                onPressed: () => vm.guardarValoracion(context),
                color: AppColors.green)
          ],
        ),
      ),
    );
  }
}

TableRow builRow(List<String> cells, {bool isHeader = false}) => TableRow(
    children: cells
        .map((cell) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cell,
                textAlign: isHeader ? TextAlign.center : TextAlign.left,
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.w700 : FontWeight.normal,
                  color: isHeader ? AppColors.brownDark : Colors.black,
                ),
              ),
            ))
        .toList());
