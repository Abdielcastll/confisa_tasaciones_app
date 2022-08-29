import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/componente_condicion.dart';
import 'package:tasaciones_app/core/models/componente_tasacion_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';

import '../../../../../../core/models/tracciones_response.dart';
import '../../../../../../core/models/versiones_vehiculo_response.dart';
import '../../../../../../theme/theme.dart';
import '../../../../base_widgets/base_form_widget.dart';
import '../../../../base_widgets/base_text_field_widget.dart';
import '../../../trabajar_view_model.dart';

class CondicionesTasacionForm extends StatelessWidget {
  const CondicionesTasacionForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final TrabajarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Condiciones',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Anterior',
      onPressedBack: () {
        vm.componentes = [];
        vm.currentForm = 2;
      },
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Siguiente',
      onPressedNext: () => vm.goToAccesorios(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Form(
          key: vm.formKeyCondiciones,
          child: Column(
            children: [
              ...vm.componentes.map((e) {
                return _itemComponente(e);
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemComponente(ComponenteTasacion e) {
    return DropdownSearch<CondicionComponente>(
      asyncItems: (_) =>
          vm.getCondiciones(idComponente: e.idComponenteVehiculo!),
      dropdownBuilder: (context, tipo) {
        return Text(
          tipo == null ? 'Seleccione' : tipo.condicionDescripcion!,
          style: const TextStyle(
            fontSize: 15,
          ),
        );
      },
      onChanged: vm.addCondicion,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          label: Text(e.descripcionComponenteVehiculo ?? ''),
          border: const UnderlineInputBorder(),
        ),
      ),
      popupProps: PopupProps.menu(
        itemBuilder: (context, otp, isSelected) {
          return ListTile(
            title: Text(otp.condicionDescripcion ?? ''),
            selected: isSelected,
          );
        },
        emptyBuilder: (_, __) => const Center(
          child: Text('No hay resultados'),
        ),
      ),
      validator: (v) {
        if (v == null) {
          return 'Seleccione';
        } else {
          return null;
        }
      },
    );
  }
}
