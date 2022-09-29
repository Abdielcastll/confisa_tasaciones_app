library condiciones_componentes_vehiculo_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/condiciones_componentes_vehiculo.dart/condiciones_componentes_vehiculo_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';

part 'condiciones_componentes_vehiculo_mobile.dart';

class CondicionesComponentesVehiculoView extends StatelessWidget {
  static const routeName = 'mantenimientos/solicitudes/condiciones-vehiculos';
  const CondicionesComponentesVehiculoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CondicionesComponentesVehiculoViewModel viewModel =
        CondicionesComponentesVehiculoViewModel();
    return ViewModelBuilder<CondicionesComponentesVehiculoViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _CondicionesComponentesVehiculoMobile(viewModel);
        });
  }
}
