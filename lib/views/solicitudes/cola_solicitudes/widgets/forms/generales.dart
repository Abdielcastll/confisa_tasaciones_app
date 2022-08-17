// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:tasaciones_app/views/solicitudes/cola_solicitudes/cola_solicitudes_view_model.dart';

// import '../../../../../theme/theme.dart';
// import '../../../base_widgets/base_form_widget.dart';
// import '../../../base_widgets/base_text_field_widget.dart';

// class GeneralesFormModificar extends StatelessWidget {
//   const GeneralesFormModificar(
//     this.vm, {
//     Key? key,
//   }) : super(key: key);

//   final ColaSolicitudesViewModel vm;

//   @override
//   Widget build(BuildContext context) {
//     return BaseFormWidget(
//       iconHeader: Icons.add_chart_sharp,
//       titleHeader: 'Generales',
//       iconBack: AppIcons.closeCircle,
//       labelBack: 'Cancelar',
//       onPressedBack: () => vm.currentForm = 0,
//       iconNext: AppIcons.save,
//       labelNext: 'Siguiente',
//       onPressedNext: () => vm.currentForm = 2,
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         color: Colors.white,
//         child: Column(
//           children: [
//             BaseTextField(
//               label: 'Tipo de tasación',
//               initialValue: vm.solicitud.descripcionTipoTasacion,
//               enabled: false,
//             ),
//             BaseTextField(
//               label: 'Fecha de solicitud',
//               initialValue: DateFormat.yMMMMd('es')
//                   .format(vm.solicitud.fechaCreada!)
//                   .toUpperCase(),
//               enabled: false,
//             ),
//             BaseTextField(
//               label: 'No. de solicitud de crédito',
//               initialValue: vm.solicitud.noSolicitudCredito.toString(),
//               enabled: false,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
