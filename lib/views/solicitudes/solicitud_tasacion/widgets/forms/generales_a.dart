import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../../../../core/models/solicitudes/solicitudes_disponibles_response.dart';
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
              label: 'Tipo de Tasación',
              initialValue: vm.incautado ? 'Tasación de Incautado' : 'Tasación',
              enabled: false,
            ),
            Form(
              key: vm.formKey,
              child: DropdownSearch<SolicitudesDisponibles>(
                asyncItems: (text) => vm.getSolicitudes(),
                dropdownBuilder: (context, tipo) {
                  return Text(
                    tipo == null
                        ? vm.solicitudDisponible?.noSolicitud?.toString() ??
                            'Seleccione'
                        : tipo.noSolicitud.toString(),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  );
                },
                onChanged: (v) => vm.solicitudDisponible = v!,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        label: Text('No. Solicitud de Crédito'),
                        border: UnderlineInputBorder())),
                popupProps: PopupProps.menu(
                  itemBuilder: (context, value, isSelected) {
                    return ListTile(
                      title: Text(value.noSolicitud.toString()),
                      subtitle: Text(value.nombreCliente ?? ''),
                      selected: isSelected,
                    );
                  },
                  emptyBuilder: (_, __) => const Center(
                    child: Text('No hay resultados'),
                  ),
                ),
                validator: (v) {
                  if (v == null && vm.solicitudDisponible == null) {
                    return 'Seleccione una solicitud';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
