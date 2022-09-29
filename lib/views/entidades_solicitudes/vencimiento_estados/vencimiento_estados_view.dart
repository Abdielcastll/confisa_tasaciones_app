library vencimiento_estados_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/vencimiento_estados/vencimiento_estados_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';

part 'vencimiento_estados_mobile.dart';

class VencimientoEstadosView extends StatelessWidget {
  static const routeName =
      'mantenimientos/solicitudes/vencimientos-estados-solicitudes';
  const VencimientoEstadosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VencimientoEstadosViewModel viewModel = VencimientoEstadosViewModel();
    return ViewModelBuilder<VencimientoEstadosViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _VencimientoEstadosMobile(viewModel);
        });
  }
}
