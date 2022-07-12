library entidades_seguridad_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/widgets/global_drawer_widget.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../theme/theme.dart';
import '../../widgets/appbar_widget.dart';
import 'entidades_seguridad_view_model.dart';

part 'entidades_seguridad_mobile.dart';

class EntidadesSeguridadView extends StatelessWidget {
  static const routeName = 'entidades_seguridad';
  const EntidadesSeguridadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EntidadesSeguridadViewModel viewModel = EntidadesSeguridadViewModel();
    /* var permisos =
        Provider.of<PermisosUserProvider>(context, listen: false).permisos;
    viewModel.permisos = permisos; */
    return ViewModelBuilder<EntidadesSeguridadViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
        },
        builder: (context, viewModel, child) {
          return _EntidadesSeguridadMobile(viewModel);
        });
  }
}
