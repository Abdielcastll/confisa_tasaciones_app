library acciones_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';
import 'acciones_view_model.dart';

part 'acciones_mobile.dart';

class AccionesView extends StatelessWidget {
  static const routeName = 'Acciones';
  const AccionesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AccionesViewModel viewModel = AccionesViewModel();
    return ViewModelBuilder<AccionesViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _AccionesMobile(viewModel);
        });
  }
}
