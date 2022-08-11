library solicitud_estimacion_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'solicitud_estimacion_view_model.dart';
import 'widgets/forms/fotos.dart';
import 'widgets/forms/generales.dart';
import 'widgets/forms/vehiculo.dart';

part 'solicitud_estimacion_mobile.dart';

class SolicitudEstimacionView extends StatelessWidget {
  static const routeName = 'solicitudEstimacion';
  const SolicitudEstimacionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SolicitudEstimacionViewModel viewModel = SolicitudEstimacionViewModel();
    return ViewModelBuilder<SolicitudEstimacionViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit(context);
        },
        builder: (context, viewModel, child) {
          return _SolicitudEstimacionMobile(viewModel);
        });
  }
}
