library usuarios_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';
import 'usuarios_view_model.dart';

part 'usuarios_mobile.dart';

class UsuariosView extends StatelessWidget {
  static const routeName = 'Usuarios';
  const UsuariosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UsuariosViewModel viewModel = UsuariosViewModel();
    return ViewModelBuilder<UsuariosViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _UsuariosMobile(viewModel);
        });
  }
}
