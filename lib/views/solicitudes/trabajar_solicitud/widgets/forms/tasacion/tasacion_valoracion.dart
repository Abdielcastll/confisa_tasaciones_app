import 'package:flutter/material.dart';

import '../../../../../../theme/theme.dart';
import '../../../../base_widgets/base_form_widget.dart';
import '../../../../base_widgets/base_text_field_widget.dart';
import '../../../trabajar_view_model.dart';

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
      labelNext: 'Guardar',
      onPressedNext: () => print('valorado'),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            const BaseTextFieldNoEdit(
                label: 'Consulta de salvamento', initialValue: 'XXXXXXXXXXXX'),
            const BaseTextFieldNoEdit(
                label: 'Tasación promedio', initialValue: 'XXXXXXXXXXXX'),
            const SizedBox(height: 20),
            const Text(
              'Referencias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.brownDark,
              ),
            ),
            const SizedBox(height: 20),
            BaseTextField(
              label: 'Valor Tasación',
              controller: vm.tcValor,
              keyboardType: TextInputType.number,
            )
          ],
        ),
      ),
    );
  }
}
