import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../theme/theme.dart';
import '../../../base_widgets/base_form_widget.dart';
import '../../../base_widgets/base_text_field_widget.dart';
import '../../solicitud_tasacion_view_model.dart';

class GeneralesA extends StatelessWidget {
  const GeneralesA(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final SolicitudTasacionViewModel vm;

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
            BaseTextField(
              label: 'Tipo de tasación',
              initialValue: vm.incautado ? 'Tasación de Incautado' : 'Tasación',
              enabled: false,
            ),
            BaseTextField(
              label: 'Fecha de solicitud',
              initialValue:
                  DateFormat.yMMMMd('es').format(vm.fechaActual).toUpperCase(),
              enabled: false,
            ),
            Form(
              key: vm.formKey,
              child: BaseTextField(
                label: 'No. de solicitud de crédito',
                hint: 'Ingrese el número de solicitud',
                keyboardType: TextInputType.number,
                onChanged: (value) => vm.numeroSolicitud = value,
                validator: vm.noSolicitudValidator,
                // initialValue: '90108',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
