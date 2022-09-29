library componentes_vehiculo_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/componentes_vehiculo/componentes_vehiculo_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';

part 'componentes_vehiculo_mobile.dart';

class ComponentesVehiculoView extends StatelessWidget {
  static const routeName = 'mantenimientos/solicitudes/componentes-vehiculo';
  const ComponentesVehiculoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ComponentesVehiculoViewModel viewModel = ComponentesVehiculoViewModel();
    return ViewModelBuilder<ComponentesVehiculoViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _ComponentesVehiculoMobile(viewModel);
        });
  }
}
