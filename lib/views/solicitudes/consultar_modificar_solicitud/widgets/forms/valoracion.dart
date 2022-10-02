import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../theme/theme.dart';
import '../../../../../../widgets/app_buttons.dart';
import '../../../base_widgets/base_form_widget.dart';
import '../../../base_widgets/base_text_field_widget.dart';
import '../../../trabajar_solicitud/widgets/forms/estimacion/estimacion_valoracion.dart';
import '../../consultar_modificar_view_model.dart';

class ValoracionForm extends StatelessWidget {
  const ValoracionForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final ConsultarModificarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: vm.solicitud.estadoTasacion == 11
          ? 'Resumen de Estimación de Tasación'
          : 'Resumen de Tasación',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Anterior',
      onPressedBack: () => vm.isTasador && vm.mostrarAccComp
          ? vm.currentForm = 5
          : vm.currentForm = 3,
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Salir',
      // isValoracion: true,
      onPressedNext: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: vm.solicitud.estadoTasacion == 11 ||
                vm.solicitud.estadoTasacion == 10
            ? Column(
                children: [
                  BaseTextFieldNoEdit(
                    label: 'Consulta de salvamento',
                    initialValue: vm.isSalvage.toString().toUpperCase(),
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Valor Tasación',
                    initialValue:
                        vm.solicitud.valorFacturacion?.toString() ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Estado',
                    initialValue: vm.solicitud.descripcionEstadoTasacion ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Tasador',
                    initialValue: vm.solicitud.nombreTasador ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Fecha de estimación',
                    initialValue: DateFormat.yMMMMd('es')
                        .format(vm.solicitud.fechaCreada!)
                        .toUpperCase(),
                  ),
                ],
              )
            : Column(
                children: [
                  BaseTextFieldNoEdit(
                    label: 'Estado',
                    initialValue: vm.solicitud.descripcionEstadoTasacion ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Fecha de Anulación o Vencimiento',
                    initialValue: vm.solicitud.fechaVencimiento != null
                        ? DateFormat.yMMMMd('es')
                            .format(vm.solicitud.fechaVencimiento!)
                            .toUpperCase()
                        : 'No disponible',
                  ),
                ],
              ),
      ),
    );
  }
}
