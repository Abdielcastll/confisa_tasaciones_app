library cola_solicitudes_view;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/widgets/appbar_widget.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../theme/theme.dart';
import '../../../widgets/refresh_widget.dart';
import 'cola_solicitudes_view_model.dart';

part 'cola_solicitudes_mobile.dart';

class ColaSolicitudesView extends StatelessWidget {
  static const routeName = 'solicitudes/cola-solicitudes';
  const ColaSolicitudesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColaSolicitudesViewModel viewModel = ColaSolicitudesViewModel();
    return ViewModelBuilder<ColaSolicitudesViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
        },
        builder: (context, viewModel, child) {
          return _ColaSolicitudesMobile(viewModel);
        });
  }
}
