library solicitud_tasacion_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'solicitud_tasacion_view_model.dart';
import 'widgets/forms/generales_a.dart';
import 'widgets/forms/generales_b.dart';

part 'solicitud_tasacion_mobile.dart';

class SolicitudTasacionView extends StatelessWidget {
  static const routeName = 'solicitudTasacion';
  const SolicitudTasacionView({Key? key, this.incautado = false})
      : super(key: key);
  final bool incautado;

  @override
  Widget build(BuildContext context) {
    SolicitudTasacionViewModel viewModel = SolicitudTasacionViewModel();
    return ViewModelBuilder<SolicitudTasacionViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit(t: incautado);
        },
        builder: (context, viewModel, child) {
          return _SolicitudTasacionMobile(viewModel);
        });
  }
}
