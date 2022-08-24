library periodo_eliminacion_data_grafica_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/periodo_eliminacion_data_grafica/periodo_eliminacion_data_grafica_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';

part 'periodo_eliminacion_data_grafica_mobile.dart';

class PeriodoEliminacionDataGraficaView extends StatelessWidget {
  static const routeName = 'Períodos Eliminación Data Gráfica';
  const PeriodoEliminacionDataGraficaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PeriodoEliminacionDataGraficaViewModel viewModel =
        PeriodoEliminacionDataGraficaViewModel();
    return ViewModelBuilder<PeriodoEliminacionDataGraficaViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _PeriodoEliminacionDataGraficaMobile(viewModel);
        });
  }
}
