library trabajar_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/views/solicitudes/trabajar_solicitud/trabajar_view_model.dart';
import '../../../core/models/solicitudes/solicitudes_get_response.dart';
import '../../../widgets/app_progress_widget.dart';
import 'widgets/forms/tasacion/tasacion_accesorios.dart';
import 'widgets/forms/tasacion/tasacion_condiciones.dart';
import 'widgets/forms/tasacion/tasacion_fotos.dart';
import 'widgets/forms/tasacion/tasacion_generales.dart';
import 'widgets/forms/tasacion/tasacion_valoracion.dart';
import 'widgets/forms/tasacion/tasacion_vehiculo.dart';

part 'trabajar_mobile.dart';

class TrabajarView extends StatelessWidget {
  static const routeName = 'trabajar';
  const TrabajarView({this.solicitudData, Key? key}) : super(key: key);
  final SolicitudesData? solicitudData;

  @override
  Widget build(BuildContext context) {
    final viewModel = TrabajarViewModel();

    return ViewModelBuilder<TrabajarViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit(context, solicitudData);
        },
        builder: (context, viewModel, child) {
          return _TrabajarMobile(viewModel);
        });
  }
}
