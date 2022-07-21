library modulos_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'modulos_view_model.dart';

part 'modulos_mobile.dart';

class ModulosView extends StatelessWidget {
  static const routeName = 'Modulos';
  const ModulosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModulosViewModel viewModel = ModulosViewModel();
    return ViewModelBuilder<ModulosViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _ModulosMobile(viewModel);
        });
  }
}
