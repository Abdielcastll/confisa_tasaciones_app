import 'package:flutter/material.dart';
import 'package:tasaciones_app/views/solicitudes/consultar_modificar_solicitud/consultar_modificar_view_model.dart';

import '../../../../../theme/theme.dart';
import '../../../base_widgets/base_form_widget.dart';

class CondicionesForm extends StatelessWidget {
  const CondicionesForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final ConsultarModificarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Condiciones',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Anterior',
      onPressedBack: () => vm.currentForm = 2,
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Siguiente',
      onPressedNext: () => vm.currentForm = 4,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            ...vm.segmentoComponente.map((e) {
              return ExpansionTile(
                title: Text(
                  e.nombreSegmento,
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
                  );
                }).toList(),
                initiallyExpanded: true,
              );
            })

            // ...vm.solicitud.condicionComponenteTasacion!.map((e) {
            //   return ListTile(
            //     title: Text(e.descripcionComponenteVehiculo ??
            //         e.idComponenteVehiculo.toString()),
            //     subtitle: Text(e.descripcionCondicionComponenteVehiculo ??
            //         e.idCondicionComponenteVehiculo.toString()),
            //   );
            // })

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
