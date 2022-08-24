import 'package:flutter/material.dart';

import '../../../../../theme/theme.dart';
import '../../../base_widgets/base_form_widget.dart';
import '../../../base_widgets/base_text_field_widget.dart';
import '../../consultar_modificar_view_model.dart';

class GeneralesB extends StatelessWidget {
  const GeneralesB(
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
      labelBack: 'Atrás',
      onPressedBack: () {
        vm.currentForm = 1;
      },
      iconNext: AppIcons.save,
      labelNext: 'Guardar',
      onPressedNext: () => Navigator.of(context).pop(),
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
                    initialValue: vm.solicitud.codigoEntidad ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Cédula cliente',
                    initialValue: vm.solicitud.identificacion ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Nombre del cliente',
                    initialValue: vm.solicitud.nombreCliente ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Oficial de negocio',
                    initialValue: vm.solicitud.idOficial.toString(),
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Sucursal',
                    initialValue: vm.solicitud.descripcionSucursal ?? '',
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
