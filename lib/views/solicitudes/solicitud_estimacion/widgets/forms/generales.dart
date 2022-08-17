import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../theme/theme.dart';
import '../../../base_widgets/base_form_widget.dart';
import '../../../base_widgets/base_text_field_widget.dart';
import '../../solicitud_estimacion_view_model.dart';

class GeneralesForm extends StatelessWidget {
  const GeneralesForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final SolicitudEstimacionViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Generales',
      iconBack: AppIcons.closeCircle,
      labelBack: 'Cancelar',
      onPressedBack: () => Navigator.of(context).pop(),
      iconNext: AppIcons.save,
      labelNext: 'Siguiente',
      onPressedNext: () => vm.solicitudCredito(context),
      // onPressedNext: () => vm.currentForm = 2,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            BaseTextField(
              label: 'Tipo de tasación',
              initialValue: vm.solicitudCola != null
                  ? vm.solicitudCola!.descripcionTipoTasacion!
                  : 'Estimación',
              enabled: false,
            ),
            // const BaseTextField(
            //   label: 'Cia tasación',
            //   initialValue: 'TASADORDEFAULD',
            //   enabled: false,
            // ),
            BaseTextField(
              label: 'Fecha de solicitud',
              initialValue: vm.solicitudCola != null
                  ? DateFormat.yMMMMd('es')
                      .format(vm.solicitudCola!.fechaCreada!)
                      .toUpperCase()
                  : DateFormat.yMMMMd('es')
                      .format(vm.fechaActual)
                      .toUpperCase(),
              enabled: false,
            ),
            vm.solicitudCola != null
                ? BaseTextField(
                    label: 'No. de solicitud de crédito',
                    initialValue:
                        vm.solicitudCola!.noSolicitudCredito.toString(),
                    enabled: false,
                  )
                : Form(
                    key: vm.formKey,
                    child: BaseTextField(
                      label: 'No. de solicitud de crédito',
                      hint: 'Ingrese el número de solicitud',
                      keyboardType: TextInputType.number,
                      validator: vm.noSolicitudValidator,
                      controller: vm.tcNoSolicitud,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
