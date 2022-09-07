import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/descripcion_foto_vehiculo.dart';
import 'package:tasaciones_app/views/solicitudes/base_widgets/base_text_field_widget.dart';

import '../../../../../../theme/theme.dart';
import '../../../../../../widgets/app_dialogs.dart';
import '../../../../base_widgets/base_form_widget.dart';
import '../../../trabajar_view_model.dart';

class FotosEstimacionForm extends StatelessWidget {
  const FotosEstimacionForm(
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
      onPressedBack: () => vm.currentForm = 3,
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Siguiente',
      onPressedNext: () =>
          vm.goToValorar(context).then((_) => vm.currentForm = 4),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Form(
          key: vm.formKeyFotos,
          child: FotosActuales(vm: vm),
        ),
      ),
    );
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
    return Column(children: [
      ...List.generate(vm.fotosAdjuntos.length, (i) {
        final foto = vm.fotosAdjuntos[i];
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
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
                Expanded(
                    child: BaseTextFieldNoEdit(
                        label: 'Tipo:', initialValue: foto.descripcion)),
              ],
            ),
            const Divider(),
          ],
        );
      }),
    ]);
  }
}
