import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/descripcion_foto_vehiculo.dart';

import '../../../../../../theme/theme.dart';
import '../../../../../../widgets/app_dialogs.dart';
import '../../../../base_widgets/base_form_widget.dart';
import '../../../trabajar_view_model.dart';

class FotosTasacionForm extends StatelessWidget {
  const FotosTasacionForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final TrabajarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Fotos',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Anterior',
      onPressedBack: () => vm.currentForm = 4,
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Siguiente',
      onPressedNext: () => vm.subirFotos(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Form(
          key: vm.formKeyFotos,
          child: FotosTrabajar(vm: vm),
        ),
      ),
    );
  }
}

class FotosTrabajar extends StatelessWidget {
  const FotosTrabajar({
    Key? key,
    required this.vm,
  }) : super(key: key);

  final TrabajarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...List.generate(vm.fotosPermitidas, (i) {
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
                    child: vm.fotos[i].adjunto != null
                        ? Image.memory(
                            base64Decode(vm.fotos[i].adjunto!),
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.add_a_photo_rounded,
                            size: 50,
                            color: Colors.grey[300],
                          ),
                  ),
                ),
                if (vm.fotos[i].adjunto != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: DropdownSearch<DescripcionFotoVehiculos>(
                        asyncItems: (_) => vm.getDescripcionFotos(_),
                        enabled: vm.fotos[i].nueva,
                        dropdownBuilder: (context, tipo) {
                          return Text(
                            tipo?.descripcion ??
                                vm.fotos[i].descripcion ??
                                'Seleccione',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          );
                        },
                        onChanged: (v) {
                          vm.fotos[i] = vm.fotos[i].copyWith(
                            tipoAdjunto: v!.id,
                            descripcion: v.descripcion,
                          );
                        },
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                label: Text('Tipo:'),
                                labelStyle: TextStyle(fontSize: 16),
                                border: UnderlineInputBorder())),
                        popupProps: PopupProps.menu(
                          itemBuilder: (context, opt, isSelected) {
                            return ListTile(
                              title: Text(opt.descripcion ??
                                  vm.fotos[i].descripcion ??
                                  'Seleccione'),
                              selected: isSelected,
                            );
                          },
                          emptyBuilder: (_, __) => const Center(
                            child: Text('No hay resultados'),
                          ),
                        ),
                        validator: (v) {
                          if (v == null && vm.fotos[i].descripcion == null) {
                            return 'Seleccione';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                vm.fotos[i].adjunto != null
                    ? SizedBox(
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
                                      confirm: () => vm.borrarFoto(context, i));
                                },
                                icon: const Icon(
                                  AppIcons.closeCircle,
                                  color: Colors.grey,
                                  size: 30,
                                )),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  vm.editarFoto(context, i);
                                },
                                icon: const Icon(
                                  AppIcons.pencilAlt,
                                  color: Colors.grey,
                                  size: 28,
                                ))
                          ],
                        ),
                      )
                    : const SizedBox(width: 45)
              ],
            ),
            const Divider(),
          ],
        );
      }),
    ]);
  }
}
