import 'package:flutter/material.dart';

import '../../../../../theme/theme.dart';
import '../../../base_widgets/base_form_widget.dart';
import '../../../base_widgets/base_text_field_widget.dart';
import '../../solicitud_tasacion_view_model.dart';

class GeneralesB extends StatelessWidget {
  const GeneralesB(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final SolicitudTasacionViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Generales',
      iconBack: AppIcons.closeCircle,
      labelBack: 'Atrás',
      onPressedBack: () {
        vm.currentForm = 1;
      },
      iconNext: AppIcons.save,
      labelNext: 'Guardar',
      onPressedNext: () => vm.guardarTasacion(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            Form(
              key: vm.formKey3,
              child: Column(
                children: [
                  BaseTextFieldNoEdit(
                    label: 'Entidad solicitante',
                    initialValue: vm.solicitud.entidad ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Cédula cliente',
                    initialValue: vm.solicitud.noIdentificacion ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Nombre del cliente',
                    initialValue: vm.solicitud.nombreCliente ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Oficial de negocio',
                    initialValue: vm.solicitud.nombreOficialNegocios ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Sucursal',
                    initialValue: vm.solicitud.sucursal ?? '',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
