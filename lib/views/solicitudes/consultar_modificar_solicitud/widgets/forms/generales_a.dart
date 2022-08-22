import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../base_widgets/base_form_widget.dart';
import '../../../base_widgets/base_text_field_widget.dart';
import '../../consultar_modificar_view_model.dart';

class GeneralesA extends StatelessWidget {
  const GeneralesA(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final ConsultarModificarViewModel vm;

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
      onPressedNext: () => vm.solicitudCredito(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            const BaseTextField(
              label: 'Tipo de tasación',
              initialValue: 'Tasación',
              enabled: false,
            ),
            BaseTextField(
              label: 'Fecha de solicitud',
              initialValue: DateFormat.yMMMMd('es')
                  .format(vm.solicitudCola.fechaCreada!)
                  .toUpperCase(),
              enabled: false,
            ),
            Form(
              key: vm.formKey,
              child: BaseTextFieldNoEdit(
                label: 'No. de solicitud de crédito',
                initialValue: vm.solicitudCola.noSolicitudCredito.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
