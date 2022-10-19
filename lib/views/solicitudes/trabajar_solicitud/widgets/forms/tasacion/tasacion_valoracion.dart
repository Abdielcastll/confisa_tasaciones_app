import 'package:flutter/material.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

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
      onPressedBack: () async {
        ProgressDialog.show(context);
        await vm.loadFotos(context);
        vm.currentForm = 5;
      },
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
            const SizedBox(height: 30),
            const Text(
              'Referencias',
              style: TextStyle(color: AppColors.brownDark, fontSize: 16),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 195,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1.6,
                    child: Table(
                      border: TableBorder.all(color: AppColors.brownDark),
                      columnWidths: const {
                        0: FractionColumnWidth(0.13),
                        1: FractionColumnWidth(0.13),
                        2: FractionColumnWidth(0.13),
                        3: FractionColumnWidth(0.305),
                        4: FractionColumnWidth(0.305),
                      },
                      children: [
                        builRow(
                          [
                            'No. Tasación',
                            'No. Solicitud',
                            'Fecha',
                            'Fuente',
                            'Valor'
                          ],
                          isHeader: true,
                        ),
                        ...vm.referencias.map((e) => builRow([
                              '${e.noTasacion ?? '-'}',
                              '${e.noSolicitud ?? '-'}',
                              '${e.fecha ?? '-'}',
                              '${e.fuente}',
                              e.resultado!
                                  ? vm.fmf
                                      .copyWith(amount: e.valor)
                                      .output
                                      .symbolOnLeft
                                  : '${e.mensaje}'
                            ])),
                      ],
                    ),
                  ),
                ],
              ),
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
