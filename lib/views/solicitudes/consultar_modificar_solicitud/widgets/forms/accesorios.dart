import 'package:flutter/material.dart';

import '../../../../../theme/theme.dart';
import '../../../base_widgets/base_form_widget.dart';
import '../../consultar_modificar_view_model.dart';

class AccesoriosForm extends StatelessWidget {
  const AccesoriosForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final ConsultarModificarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Accesorios',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Anterior',
      onPressedBack: () => vm.currentForm = 3,
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Siguiente',
      onPressedNext: () => vm.goToFotos(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            ...vm.segmentoAccesorio.map((e) {
              return ExpansionTile(
                title: Text(
                  e.nombreSegmento == '' ? 'Accesorios' : e.nombreSegmento,
                  style: const TextStyle(
                    color: AppColors.brownDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                textColor: AppColors.brownDark,
                children: e.componentes.map((e) {
                  return ListTile(
                    title: Text(e.componente ?? ''),
                    subtitle: Text(e.condicion ?? ''),
                    trailing: const Icon(
                      Icons.check_box,
                      color: AppColors.brown,
                    ),
                  );
                }).toList(),
                initiallyExpanded: true,
              );
            })

            // ...vm.segmentoComponente.map((e) {
            //   return ExpansionTile(
            //     title: Text(
            //       e.nombreSegmento,
            //       style: const TextStyle(
            //         color: AppColors.brownDark,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //     textColor: AppColors.brownDark,
            //     children: e.componentes.map((e) {
            //       return _itemComponente(e);
            //     }).toList(),
            //     initiallyExpanded: true,
            //   );
            // })
          ],
        ),
      ),
    );
  }
}
