library alarmas_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';
import 'alarmas_view_model.dart';

part 'alarmas_mobile.dart';

class AlarmasView extends StatelessWidget {
  static const routeName = 'Alarmas';
  const AlarmasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AlarmasViewModel viewModel = AlarmasViewModel();
    return ViewModelBuilder<AlarmasViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _AlarmasMobile(viewModel);
        });
  }
}
