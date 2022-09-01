import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../base_widgets/base_form_widget.dart';
import '../../../../base_widgets/base_text_field_widget.dart';
import '../../../trabajar_view_model.dart';

class GeneralesTasacionForm extends StatelessWidget {
  const GeneralesTasacionForm(
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
            BaseTextField(
              label: 'Tipo de tasación',
              initialValue: vm.solicitud.descripcionTipoTasacion ?? '',
              enabled: false,
            ),
            BaseTextField(
              label: 'Fecha de solicitud',
              initialValue: DateFormat.yMMMMd('es')
                  .format(vm.solicitud.fechaCreada!)
                  .toUpperCase(),
              enabled: false,
            ),
            BaseTextFieldNoEdit(
              label: 'No. de solicitud de crédito',
              initialValue: vm.solicitud.noSolicitudCredito.toString(),
            ),
            BaseTextFieldNoEdit(
              label: 'Entidad solicitante',
              initialValue: vm.solicitudData?.entidad ?? '',
            ),
            BaseTextFieldNoEdit(
              label: 'Cédula del cliente',
              initialValue: vm.solicitudData?.noIdentificacion ?? '',
            ),
            BaseTextFieldNoEdit(
              label: 'Nombre del cliente',
              initialValue: vm.solicitudData?.nombreCliente ?? '',
            ),
            BaseTextFieldNoEdit(
              label: 'Oficial de negocios',
              initialValue: vm.solicitudData?.nombreOficialNegocios ?? '',
            ),
            BaseTextFieldNoEdit(
              label: 'Sucursal',
              initialValue: vm.solicitudData?.sucursal ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
