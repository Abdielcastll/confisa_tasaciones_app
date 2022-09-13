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
      onPressedNext: () => vm.fotosAdjuntos.isNotEmpty
          ? vm.subirFotos(context)
          : vm.subirFotosNueva(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Form(
          key: vm.formKeyFotos,
          child: vm.fotosAdjuntos.isNotEmpty
              ? FotosActuales(vm: vm)
              : FotosNuevasTrabajar(vm: vm),
        ),
      ),
    );
  }
}

class FotosNuevasTrabajar extends StatelessWidget {
  const FotosNuevasTrabajar({
    Key? key,
    required this.vm,
  }) : super(key: key);

  final TrabajarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...List.generate(vm.fotosPermitidas, (i) {
        // var foto = vm.fotos[i];
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => vm.cargarFotoNuevas(i),
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
                        // items: vm.descripcionFotos,
                        dropdownBuilder: (context, tipo) {
                          return Text(
                            tipo?.descripcion ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          );
                        },
                        onChanged: (v) {
                          vm.fotos[i] = vm.fotos[i].copyWith(
                            descripcion: v!.descripcion,
                            tipoAdjunto: v.id,
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
                              title: Text(opt.descripcion ?? ''),
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
                                      confirm: () => vm.borrarFotoNueva(i));
                                },
                                icon: const Icon(
                                  AppIcons.closeCircle,
                                  color: Colors.grey,
                                  size: 30,
                                )),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  vm.editarFotoNueva(i);
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

class FotosActuales extends StatelessWidget {
  const FotosActuales({
    Key? key,
    required this.vm,
  }) : super(key: key);

  final TrabajarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(
          vm.fotosAdjuntos.length,
          (i) {
            // var foto = vm.fotosAdjuntos[i];
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
                        child: vm.fotosAdjuntos[i].adjunto == null
                            ? Icon(
                                Icons.add_a_photo_rounded,
                                size: 50,
                                color: Colors.grey[300],
                              )
                            : Image.memory(
                                base64Decode(vm.fotosAdjuntos[i].adjunto!),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    vm.fotosAdjuntos[i].adjunto == null
                        ? const Spacer()
                        : Expanded(
                            child: DropdownSearch<DescripcionFotoVehiculos>(
                              asyncItems: (_) => vm.getDescripcionFotos(_),
                              dropdownBuilder: (context, tipo) {
                                return Text(
                                  tipo?.descripcion ??
                                      vm.fotosAdjuntos[i].descripcion ??
                                      'Seleccione',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                );
                              },
                              onChanged: (v) {
                                vm.fotosAdjuntos[i] =
                                    vm.fotosAdjuntos[i].copyWith(
                                  descripcion: v!.descripcion,
                                  tipoAdjunto: v.id,
                                );
                              },
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          label: Text('Tipo:'),
                                          labelStyle: TextStyle(fontSize: 16),
                                          border: UnderlineInputBorder())),
                              popupProps: PopupProps.menu(
                                itemBuilder: (context, opt, isSelected) {
                                  return ListTile(
                                    title: Text(opt.descripcion ?? ''),
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
                            ),
                          ),
                    if (vm.fotosAdjuntos[i].adjunto != '')
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
          },
        ),
      ],
    );
  }
}
