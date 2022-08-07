library componentes_vehiculo_suplidor_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';
import 'componentes_vehiculo_suplidor_view_model.dart';

part 'componentes_vehiculo_suplidor_mobile.dart';

class ComponentesVehiculoSuplidorView extends StatelessWidget {
  static const routeName = 'Vehículo Componentes Suplidor';
  const ComponentesVehiculoSuplidorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ComponentesVehiculoSuplidorViewModel viewModel =
        ComponentesVehiculoSuplidorViewModel();
    return ViewModelBuilder<ComponentesVehiculoSuplidorViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _ComponentesVehiculoSuplidorMobile(viewModel);
        });
  }
}
