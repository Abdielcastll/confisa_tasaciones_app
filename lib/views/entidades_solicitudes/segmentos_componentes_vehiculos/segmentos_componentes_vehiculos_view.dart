library segmentos_componentes_vehiculos_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/segmentos_componentes_vehiculos/segmentos_componentes_vehiculos_view_model.dart';

import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';

part 'segmentos_componentes_vehiculos_mobile.dart';

class SegmentosComponentesVehiculosView extends StatelessWidget {
  static const routeName =
      'mantenimientos/solicitudes/segmentos-componentes-vehiculo';
  const SegmentosComponentesVehiculosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SegmentosComponentesVehiculosViewModel viewModel =
        SegmentosComponentesVehiculosViewModel();
    return ViewModelBuilder<SegmentosComponentesVehiculosViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _SegmentosComponentesVehiculosMobile(viewModel);
        });
  }
}
