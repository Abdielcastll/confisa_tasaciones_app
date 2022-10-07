import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/componente_condicion.dart';
import 'package:tasaciones_app/core/models/componente_tasacion_response.dart';
import 'package:tasaciones_app/theme/theme.dart';

import '../../../../base_widgets/base_form_widget.dart';
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
              ...vm.segmentoComponente.map((e) {
                return ExpansionTile(
                  title: Text(
                    e.nombreSegmento,
                    style: const TextStyle(
                      color: AppColors.brownDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  textColor: AppColors.brownDark,
                  children: e.componentes.map((e) {
                    return _itemComponente(e);
                  }).toList(),
                  initiallyExpanded: true,
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemComponente(ComponenteTasacion e) {
    return DropdownSearch<CondicionComponente>(
      asyncItems: (_) => vm.getCondiciones(idComponente: e.id!),
      dropdownBuilder: (context, tipo) {
        return Text(
          tipo == null
              ? e.descripcionCondicion ?? 'Seleccione'
              : tipo.condicionDescripcion!,
          style: const TextStyle(fontSize: 15),
        );
      },
      onChanged: (condicion) {
        e.descripcionCondicion = condicion!.condicionDescripcion!;
        e.idCondicion = condicion.id!;
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          label: Text(e.componenteDescripcion ?? ''),
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
        if (v == null && e.descripcionCondicion == null) {
          return 'Seleccione';
        } else {
          return null;
        }
      },
    );
  }
}
