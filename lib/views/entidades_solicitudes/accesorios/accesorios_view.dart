library accesorios_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/segmentos_accesorios_vehiculos_response.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/accesorios/accesorios_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';

part 'accesorios_mobile.dart';

class AccesoriosView extends StatelessWidget {
  static const routeName = 'mantenimientos/solicitudes/accesorios-vehiculo';
  const AccesoriosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AccesoriosViewModel viewModel = AccesoriosViewModel();
    return ViewModelBuilder<AccesoriosViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _AccesoriosMobile(viewModel);
        });
  }
}
