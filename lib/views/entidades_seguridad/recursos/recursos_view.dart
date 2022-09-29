library recursos_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';
import 'recursos_view_model.dart';

part 'recursos_mobile.dart';

class RecursosView extends StatelessWidget {
  static const routeName = 'mantenimientos/seguridad/recursos';
  const RecursosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecursosViewModel viewModel = RecursosViewModel();
    return ViewModelBuilder<RecursosViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _RecursosMobile(viewModel);
        });
  }
}
