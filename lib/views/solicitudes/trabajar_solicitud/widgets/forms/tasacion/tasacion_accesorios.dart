import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';

import '../../../../../../core/models/tracciones_response.dart';
import '../../../../../../core/models/versiones_vehiculo_response.dart';
import '../../../../base_widgets/base_form_widget.dart';
import '../../../../base_widgets/base_text_field_widget.dart';
import '../../../trabajar_view_model.dart';

class AccesoriosTasacionForm extends StatelessWidget {
  const AccesoriosTasacionForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final TrabajarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Accesorios',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Anterior',
      onPressedBack: () {
        vm.currentForm = 3;
      },
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Siguiente',
      // onPressedNext: () => vm.solicitudCredito(context),
      onPressedNext: () =>
          vm.goToFotos(context).then((_) => vm.currentForm = 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(children: [
          ...vm.accesorios.map((e) {
            return CheckboxListTile(
              value: e.isSelected,
              onChanged: (s) {
                e.isSelected = s ?? false;
                vm.notifyListeners();
              },
              title: Text(e.accesorioDescripcion ?? ''),
            );
          })
        ]),
      ),
    );
  }
}
