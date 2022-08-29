import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../../../core/models/descripcion_foto_vehiculo.dart';
import '../../../../../theme/theme.dart';
import '../../../../../widgets/app_dialogs.dart';
import '../../../base_widgets/base_form_widget.dart';
import '../../consultar_modificar_view_model.dart';

class FotosForm extends StatelessWidget {
  const FotosForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final ConsultarModificarViewModel vm;

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
      onPressedNext: () => vm.subirFotos(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Form(
          key: vm.formKeyFotos,
          child: Column(children: [
            ...List.generate(vm.fotosAdjuntos.length, (i) {
              final foto = vm.fotosAdjuntos[i];
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
                          child: foto.adjunto == ''
                              ? Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 50,
                                  color: Colors.grey[300],
                                )
                              : Image.memory(
                                  base64Decode(foto.adjunto),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      vm.solicitudCola.estadoTasacion != 34
                          ?
                          // if (foto.path != '')
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'Descripción:\n${vm.fotosAdjuntos[i].descripcion}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                          : foto.adjunto == ''
                              ? const Spacer()
                              : Expanded(
                                  child:
                                      DropdownSearch<DescripcionFotoVehiculos>(
                                    items: vm.descripcionFotos,
                                    dropdownBuilder: (context, tipo) {
                                      return Text(
                                        tipo?.descripcion ??
                                            vm.fotosAdjuntos[i].descripcion,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      );
                                    },
                                    onChanged: (v) =>
                                        foto.descripcion = v!.descripcion!,
                                    dropdownDecoratorProps:
                                        const DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                                    label: Text('Descripción:'),
                                                    labelStyle:
                                                        TextStyle(fontSize: 16),
                                                    border:
                                                        UnderlineInputBorder())),
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
                      if (vm.solicitudCola.estadoTasacion == 34)
                        foto.adjunto == ''
                            ? const SizedBox()
                            : SizedBox(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
      ),
    );
  }
}
