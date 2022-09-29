library acciones_pendientes_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';
import 'acciones_pendientes_view_model.dart';

part 'acciones_pendientes_mobile.dart';

class AccionesPendientesView extends StatelessWidget {
  static const routeName = 'mantenimientos/solicitudes/tipos-accion-pendiente';
  const AccionesPendientesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AccionesPendientesViewModel viewModel = AccionesPendientesViewModel();
    return ViewModelBuilder<AccionesPendientesViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _AccionesPendientesMobile(viewModel);
        });
  }
}
