library segmentos_accesorios_vehiculos_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/segmentos_accesorios_vehiculos/segmentos_accesorios_vehiculos_view_model.dart';

import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';

part 'segmentos_accesorios_vehiculos_mobile.dart';

class SegmentosAccesoriosVehiculosView extends StatelessWidget {
  static const routeName = 'Vehículo Segmentos Accesorios';
  const SegmentosAccesoriosVehiculosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SegmentosAccesoriosVehiculosViewModel viewModel =
        SegmentosAccesoriosVehiculosViewModel();
    return ViewModelBuilder<SegmentosAccesoriosVehiculosViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _SegmentosAccesoriosVehiculosMobile(viewModel);
        });
  }
}
