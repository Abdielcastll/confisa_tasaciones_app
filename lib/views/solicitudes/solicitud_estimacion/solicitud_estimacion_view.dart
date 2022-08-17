library solicitud_estimacion_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'solicitud_estimacion_view_model.dart';
import 'widgets/forms/fotos.dart';
import 'widgets/forms/generales.dart';
import 'widgets/forms/vehiculo.dart';

part 'solicitud_estimacion_mobile.dart';

class SolicitudEstimacionView extends StatelessWidget {
  static const routeName = 'solicitudEstimacion';
  const SolicitudEstimacionView({this.solicitudData, Key? key})
      : super(key: key);
  final SolicitudesData? solicitudData;

  @override
  Widget build(BuildContext context) {
    final viewModel = SolicitudEstimacionViewModel();

    return ViewModelBuilder<SolicitudEstimacionViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit(solicitudData);
        },
        builder: (context, viewModel, child) {
          return _SolicitudEstimacionMobile(viewModel);
        });
  }
}
