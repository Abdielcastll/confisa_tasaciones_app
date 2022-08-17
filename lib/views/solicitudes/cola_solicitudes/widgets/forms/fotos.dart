// import 'package:flutter/material.dart';
// import 'package:tasaciones_app/views/solicitudes/cola_solicitudes/cola_solicitudes_view_model.dart';

// import '../../../../../theme/theme.dart';
// import '../../../../../widgets/app_dialogs.dart';
// import '../../../base_widgets/base_form_widget.dart';

// class FotosFormModificar extends StatelessWidget {
//   const FotosFormModificar(
//     this.vm, {
//     Key? key,
//   }) : super(key: key);

//   final ColaSolicitudesViewModel vm;

//   @override
//   Widget build(BuildContext context) {
//     return BaseFormWidget(
//       iconHeader: Icons.add_chart_sharp,
//       titleHeader: 'Fotos',
//       iconBack: AppIcons.closeCircle,
//       labelBack: 'Cancelar',
//       onPressedBack: () => vm.currentForm = 2,
//       iconNext: AppIcons.save,
//       labelNext: 'Siguiente',
//       onPressedNext: () => print('GUARDAR'),
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         color: Colors.white,
//         child: Column(children: [
//           ...List.generate(vm.fotosPermitidas, (i) {
//             final foto = vm.fotos[i];
//             return Column(
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     InkWell(
//                       onTap: () => vm.cargarFoto(i),
//                       child: Container(
//                         clipBehavior: Clip.antiAlias,
//                         margin: const EdgeInsets.all(10),
//                         height: 100,
//                         width: 100,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: AppColors.brown)),
//                         child: foto.path != ''
//                             ? Image.file(
//                                 foto,
//                                 fit: BoxFit.cover,
//                               )
//                             : Icon(
//                                 Icons.add_a_photo_rounded,
//                                 size: 50,
//                                 color: Colors.grey[300],
//                               ),
//                       ),
//                     ),
//                     if (foto.path != '')
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: Text(
//                             // 'Descripción:\n${foto.uri}',
//                             'Descripción:\n${foto.path.split('/').last}',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ),
//                       ),
//                     if (foto.path != '')
//                       SizedBox(
//                         height: 100,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             IconButton(
//                                 onPressed: () {
//                                   Dialogs.confirm(context,
//                                       tittle: 'Borrar foto',
//                                       description:
//                                           '¿Está seguro de borrar esta foto?',
//                                       confirm: () => vm.borrarFoto(i));
//                                 },
//                                 icon: const Icon(
//                                   AppIcons.closeCircle,
//                                   color: Colors.grey,
//                                   size: 30,
//                                 )),
//                             const Spacer(),
//                             IconButton(
//                                 onPressed: () {
//                                   if (foto.path != '') {
//                                     vm.editarFoto(i);
//                                   }
//                                 },
//                                 icon: const Icon(
//                                   AppIcons.pencilAlt,
//                                   color: Colors.grey,
//                                   size: 28,
//                                 ))
//                           ],
//                         ),
//                       )
//                   ],
//                 ),
//                 const Divider(),
//               ],
//             );
//           }),
//         ]),
//       ),
//     );
//   }
// }
