import 'package:flutter/material.dart';

import '../../../../../theme/theme.dart';
import '../../../../../widgets/app_buttons.dart';
import '../../../base_widgets/base_form_widget.dart';
import '../../../base_widgets/base_text_field_widget.dart';
import '../../../trabajar_solicitud/widgets/forms/estimacion/estimacion_valoracion.dart';
import '../../consultar_modificar_view_model.dart';

class AprobarForm extends StatelessWidget {
  const AprobarForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final ConsultarModificarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Valorar',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Anterior',
      onPressedBack: () =>
          vm.mostrarAccComp ? vm.currentForm = 5 : vm.currentForm = 3,
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
            Form(
                // key: vm.formKeyValor,
                child: BaseTextFieldNoEdit(
              label: 'Valor Tasación',
              initialValue: vm.fmf
                  .copyWith(amount: vm.solicitud.valorTasacion)
                  .output
                  .symbolOnLeft,
            )),
            const SizedBox(height: 50),
            AppButton(
                text: 'Aprobar',
                onPressed: () => vm.aprobar(context),
                color: AppColors.green)
          ],
        ),
      ),
    );
  }
}
