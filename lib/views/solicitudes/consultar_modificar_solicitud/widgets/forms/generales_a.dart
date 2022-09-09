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
      isValoracion: vm.solicitud.tipoTasacion == 21 ? false : true,
      onPressedNext: () => vm.currentForm = 2,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            BaseTextField(
              label: 'Tipo de solicitud',
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
              label: 'No. de solicitud',
              initialValue: vm.solicitud.noSolicitudCredito.toString(),
            ),
            BaseTextFieldNoEdit(
              label: 'Entidad solicitante',
              initialValue: vm.solicitudCreditoData?.entidad ?? '',
            ),
            BaseTextFieldNoEdit(
              label: 'Cédula del cliente',
              initialValue: vm.solicitudCreditoData?.noIdentificacion ?? '',
            ),
            BaseTextFieldNoEdit(
              label: 'Nombre del cliente',
              initialValue: vm.solicitudCreditoData?.nombreCliente ?? '',
            ),
            BaseTextFieldNoEdit(
              label: 'Oficial de negocios',
              initialValue:
                  vm.solicitudCreditoData?.nombreOficialNegocios ?? '',
            ),
            BaseTextFieldNoEdit(
              label: 'Sucursal',
              initialValue: vm.solicitudCreditoData?.sucursal ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
