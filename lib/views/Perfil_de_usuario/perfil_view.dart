library perfil_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/Perfil_de_usuario/perfil_view_model.dart';
import 'package:tasaciones_app/widgets/app_buttons.dart';
import 'package:tasaciones_app/widgets/appbar_widget.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';

import 'widgets/card_profile_widget.dart';

part 'perfil_mobile.dart';

class PerfilView extends StatelessWidget {
  static const routeName = 'perfil';
  const PerfilView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PerfilViewModel viewModel = PerfilViewModel();
    return ViewModelBuilder<PerfilViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) async => await viewModel.onInit(context),
        builder: (context, viewModel, child) {
          return _PerfilMobile(viewModel);
        });
  }
}
