import 'package:flutter/material.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../../base_widgets/base_form_widget.dart';
import '../../../../base_widgets/base_text_field_widget.dart';
import '../../../trabajar_view_model.dart';

class VehiculoEstimacionForm extends StatelessWidget {
  const VehiculoEstimacionForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final TrabajarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Vehículo',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Anterior',
      onPressedBack: () {
        vm.currentForm = 1;
      },
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Siguiente',
      onPressedNext: () {
        ProgressDialog.show(context);
        vm.loadFotos(context).then((_) => vm.currentForm = 3);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            BaseTextFieldNoEdit(
              label: 'No. VIN',
              initialValue: vm.solicitud.chasis,
            ),
            BaseTextFieldNoEdit(
              label: 'Marca',
              initialValue: vm.solicitud.descripcionMarca ?? '',
            ),
            BaseTextFieldNoEdit(
              label: 'Modelo',
              initialValue: vm.solicitud.descripcionModelo ?? '',
            ),
            BaseTextFieldNoEdit(
              label: 'Año',
              initialValue: vm.solicitud.ano.toString(),
            ),
            BaseTextFieldNoEdit(
              label: 'Serie',
              initialValue: vm.solicitud.descripcionSerie ?? 'No Disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Trim',
              initialValue: vm.solicitud.descripcionTrim ?? 'No Disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Versión',
              initialValue: vm.solicitud.descripcionVersion ?? 'No Disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Edición',
              initialValue: vm.solicitud.descripcionEdicion ?? 'No Disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Tipo',
              initialValue:
                  vm.solicitud.descripcionTipoVehiculoLocal ?? 'No Disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Sistema de Transmisión',
              initialValue:
                  vm.solicitud.descripcionSistemaTransmision ?? 'No Disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Sistema de Tracción',
              initialValue: vm.solicitud.descripcionTraccion ?? 'No Disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Número de Puertas',
              initialValue:
                  vm.solicitud.noPuertas?.toString() ?? 'No Disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Número de Cilindros',
              initialValue:
                  vm.solicitud.noCilindros?.toString() ?? 'No Disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Fuerza Motríz',
              initialValue:
                  vm.solicitud.fuerzaMotriz?.toString() ?? 'No Disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Estado del vehículo',
              initialValue: vm.solicitud.descripcionNuevoUsado,
            ),
            BaseTextFieldNoEdit(
              label: 'Kilometraje',
              initialValue:
                  vm.solicitud.kilometraje?.toString() ?? 'No Disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Color',
              initialValue: vm.solicitud.descripcionColor ?? 'No Disponible',
            ),
            BaseTextFieldNoEdit(
              label: 'Placa',
              initialValue: vm.solicitud.placa ?? 'No Disponible',
            ),
          ],
        ),
      ),
    );
  }
}
