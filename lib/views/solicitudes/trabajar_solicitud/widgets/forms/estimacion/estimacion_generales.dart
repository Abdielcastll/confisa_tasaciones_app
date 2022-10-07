import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../base_widgets/base_form_widget.dart';
import '../../../../base_widgets/base_text_field_widget.dart';
import '../../../trabajar_view_model.dart';

class GeneralesEstimacionForm extends StatelessWidget {
  const GeneralesEstimacionForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final TrabajarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Generales',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Cancelar',
      onPressedBack: () => Navigator.of(context).pop(),
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Siguiente',
      onPressedNext: () => vm.currentForm = 2,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            BaseTextFieldNoEdit(
              label: 'Tipo de Tasación',
              initialValue:
                  vm.solicitud.descripcionTipoTasacion ?? 'No disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Fecha de Solicitud',
              initialValue: DateFormat.yMMMMd('es')
                  .format(vm.solicitud.fechaCreada!)
                  .toUpperCase(),
            ),
            BaseTextFieldNoEdit(
              label: 'No. de Solicitud de Crédito',
              initialValue: vm.solicitud.noSolicitudCredito.toString(),
            ),
            BaseTextFieldNoEdit(
              label: 'No. de Tasación',
              initialValue: vm.solicitud.noTasacion.toString(),
            ),
            BaseTextFieldNoEdit(
              label: 'Entidad Solicitante',
              initialValue: vm.solicitud.descripcionEntidad ?? 'No disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Cédula del Cliente',
              initialValue: vm.solicitud.identificacion ?? 'No disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Nombre del Cliente',
              initialValue: vm.solicitud.nombreCliente ?? 'No disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Oficial de Negocios',
              initialValue: vm.solicitud.nombreOficial ?? 'No disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Sucursal',
              initialValue: vm.solicitud.descripcionSucursal ?? 'No disponible',
            ),
          ],
        ),
      ),
    );
  }
}
