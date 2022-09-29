library periodo_facturacion_automatica_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/seguridad_facturacion/periodo_facturacion_automatica/periodo_facturacion_automatica_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';

part 'periodo_facturacion_automatica_mobile.dart';

class PeriodoFacturacionAutomaticaView extends StatelessWidget {
  static const routeName =
      'mantenimientos/facturacion/periodo-facturacion-automatica';
  const PeriodoFacturacionAutomaticaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PeriodoFacturacionAutomaticaViewModel viewModel =
        PeriodoFacturacionAutomaticaViewModel();
    return ViewModelBuilder<PeriodoFacturacionAutomaticaViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _PeriodoFacturacionAutomaticaMobile(viewModel);
        });
  }
}
