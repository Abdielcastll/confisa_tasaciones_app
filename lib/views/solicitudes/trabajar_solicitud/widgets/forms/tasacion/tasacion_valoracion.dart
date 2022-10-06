import 'package:flutter/material.dart';

import '../../../../../../core/utils/numeric_text_formater.dart';
import '../../../../../../theme/theme.dart';
import '../../../../../../widgets/app_buttons.dart';
import '../../../../base_widgets/base_form_widget.dart';
import '../../../../base_widgets/base_text_field_widget.dart';
import '../../../trabajar_view_model.dart';
import '../estimacion/estimacion_valoracion.dart';

class ValoracionTasacionForm extends StatelessWidget {
  const ValoracionTasacionForm(
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
      onPressedBack: () => vm.currentForm = 5,
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
              initialValue: vm.isSalvage.toString().toUpperCase(),
            ),
            BaseTextFieldNoEdit(
              label: 'Tasación promedio',
              initialValue: '${vm.tasacionPromedio}',
            ),
            const SizedBox(height: 30),
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
            BaseTextField(
              label: 'Observación',
              controller: vm.tcObservacion,
              maxLength: 500,
            ),
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
            const SizedBox(height: 10),
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
