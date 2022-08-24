import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../../../theme/theme.dart';
import '../../../../../widgets/app_dialogs.dart';
import '../../../base_widgets/base_form_widget.dart';
import '../../solicitud_estimacion_view_model.dart';

class FotosForm extends StatelessWidget {
  const FotosForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final SolicitudEstimacionViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Fotos',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Anterior',
      onPressedBack: () => vm.currentForm = 2,
      iconNext: AppIcons.save,
      labelNext: 'Guardar',
      onPressedNext: () => Dialogs.confirm(
        context,
        tittle: 'ATENCIÓN',
        description:
            'Después de ser enviada la solicitud para su valoración no podrá ser modificada',
        confirm: () => vm.crearSolicitud(context),
        textAceptar: 'Enviar',
        textCancelar: 'Cancelar',
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(children: [
          ...List.generate(vm.fotosPermitidas, (i) {
            final foto = vm.fotos[i];
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => vm.cargarFoto(i),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.all(10),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.brown)),
                        child: foto.file!.path != ''
                            ? Image.file(
                                foto.file!,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.add_a_photo_rounded,
                                size: 50,
                                color: Colors.grey[300],
                              ),
                      ),
                    ),
                    if (foto.descripcion != '')
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                // 'Descripción:\n${foto.uri}',
                                'Descripción: ',
                                style: TextStyle(fontSize: 16),
                              ),
                              // DropdownSearch<TipoVehiculoData>(
                              //   asyncItems: (text) => vm.getTipoVehiculo(text),
                              //   dropdownBuilder: (context, tipo) {
                              //     return Text(
                              //       tipo == null
                              //           ? vm.solicitudCola
                              //                   ?.descripcionTipoVehiculoLocal ??
                              //               'Seleccione'
                              //           : tipo.descripcion,
                              //       style: const TextStyle(
                              //         fontSize: 15,
                              //       ),
                              //     );
                              //   },
                              //   onChanged: (v) => vm.tipoVehiculo = v,
                              //   dropdownDecoratorProps:
                              //       const DropDownDecoratorProps(
                              //           dropdownSearchDecoration:
                              //               InputDecoration(
                              //                   label: Text('Tipo'),
                              //                   border:
                              //                       UnderlineInputBorder())),
                              //   popupProps: PopupProps.menu(
                              //     itemBuilder: (context, otp, isSelected) {
                              //       return ListTile(
                              //         title: Text(otp.descripcion),
                              //         selected: isSelected,
                              //       );
                              //     },
                              //     emptyBuilder: (_, __) => const Center(
                              //       child: Text('No hay resultados'),
                              //     ),
                              //   ),
                              //   validator: (v) {
                              //     if (v == null) {
                              //       return 'Seleccione un tipo';
                              //     } else {
                              //       return null;
                              //     }
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                    if (foto.file!.path != '')
                      SizedBox(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Dialogs.confirm(context,
                                      tittle: 'Borrar foto',
                                      description:
                                          '¿Está seguro de borrar esta foto?',
                                      confirm: () => vm.borrarFoto(i));
                                },
                                icon: const Icon(
                                  AppIcons.closeCircle,
                                  color: Colors.grey,
                                  size: 30,
                                )),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  vm.editarFoto(i);
                                },
                                icon: const Icon(
                                  AppIcons.pencilAlt,
                                  color: Colors.grey,
                                  size: 28,
                                ))
                          ],
                        ),
                      )
                  ],
                ),
                const Divider(),
              ],
            );
          }),
        ]),
      ),
    );
  }
}
