library acciones_solicitud_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';
import 'acciones_solicitud_view_model.dart';

part 'acciones_solicitud_mobile.dart';

class AccionesSolicitudView extends StatelessWidget {
  static const routeName = 'Listado Acciones Solicitud';
  final bool showCreate;
  final int idSolicitud;
  const AccionesSolicitudView(
      {Key? key, required this.showCreate, required this.idSolicitud})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AccionesSolicitudViewModel viewModel =
        AccionesSolicitudViewModel(idSolicitud: idSolicitud);
    return ViewModelBuilder<AccionesSolicitudViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _AccionesSolicitudMobile(viewModel, showCreate, idSolicitud);
        });
  }
}
