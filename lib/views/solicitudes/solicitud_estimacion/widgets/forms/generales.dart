import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_disponibles_response.dart';
import 'package:tasaciones_app/theme/theme.dart';

import '../../../../../core/models/ediciones_vehiculo_response.dart';
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
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Cancelar',
      onPressedBack: () => Navigator.of(context).pop(),
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Siguiente',
      onPressedNext: () => vm.goToVehiculo(context),
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
            vm.solicitudCola != null
                ? BaseTextField(
                    label: 'No. de solicitud de crédito',
                    initialValue:
                        vm.solicitudCola!.noSolicitudCredito.toString(),
                    enabled: false,
                  )
                : Row(
                    children: [
                      Form(
                        key: vm.formKey,
                        child: Expanded(
                          child: DropdownSearch<SolicitudesDisponibles>(
                            asyncItems: (text) => vm.getSolicitudes(),
                            dropdownBuilder: (context, tipo) {
                              return Text(
                                tipo == null
                                    ? 'Seleccione'
                                    : tipo.noSolicitud.toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              );
                            },
                            onChanged: (v) => vm.solicitudDisponible = v!,
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        label: Text('No. Solicitud de crédito'),
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
                              if (v == null) {
                                return 'Seleccione una solicitud';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 50,
                        onPressed: () => vm.solicitudCredito(context),
                        icon: const CircleAvatar(
                          child: Icon(
                            Icons.search,
                            color: AppColors.white,
                          ),
                          backgroundColor: AppColors.brownDark,
                        ),
                      ),
                    ],
                  ),
            if (vm.solicitud != null)
              Column(
                children: [
                  BaseTextFieldNoEdit(
                    label: 'Entidad solicitante',
                    initialValue: vm.solicitud?.entidad ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Cédula del cliente',
                    initialValue: vm.solicitud?.noIdentificacion ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Nombre del cliente',
                    initialValue: vm.solicitud?.nombreCliente ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Oficial de negocios',
                    initialValue: vm.solicitud?.nombreOficialNegocios ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Sucursal',
                    initialValue: vm.solicitud?.sucursal ?? '',
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
