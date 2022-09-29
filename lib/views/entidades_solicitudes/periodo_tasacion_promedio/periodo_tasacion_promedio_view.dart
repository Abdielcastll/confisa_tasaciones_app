library periodo_tasacion_promedio_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/periodo_tasacion_promedio/periodo_tasacion_promedio_view_model.dart';

import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';

part 'periodo_tasacion_promedio_mobile.dart';

class PeriodoTasacionPromedioView extends StatelessWidget {
  static const routeName =
      'mantenimientos/solicitudes/periodo-tasacion-promedio';
  const PeriodoTasacionPromedioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PeriodoTasacionPromedioViewModel viewModel =
        PeriodoTasacionPromedioViewModel();
    return ViewModelBuilder<PeriodoTasacionPromedioViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _PeriodoTasacionPromedioMobile(viewModel);
        });
  }
}
