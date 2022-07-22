library permisos_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'permisos_view_model.dart';

part 'permisos_mobile.dart';

class PermisosView extends StatelessWidget {
  static const routeName = 'Permisos';
  const PermisosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PermisosViewModel viewModel = PermisosViewModel();
    return ViewModelBuilder<PermisosViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _PermisosMobile(viewModel);
        });
  }
}
