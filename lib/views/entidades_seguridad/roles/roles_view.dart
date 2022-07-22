library roles_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/change_buttons.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/forms/form_crear_permiso.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/app_dialogs.dart';
import 'roles_view_model.dart';

part 'roles_mobile.dart';

class RolesView extends StatelessWidget {
  static const routeName = 'Roles';
  const RolesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RolesViewModel viewModel = RolesViewModel();
    return ViewModelBuilder<RolesViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _RolesMobile(viewModel);
        });
  }
}