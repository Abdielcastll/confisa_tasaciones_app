library cola_solicitudes_view;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/core/providers/menu_provider.dart';
import 'package:tasaciones_app/core/providers/permisos_provider.dart';
import 'package:tasaciones_app/widgets/appbar_widget.dart';
import 'package:tasaciones_app/widgets/global_drawer_widget.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../core/providers/profile_permisos_provider.dart';
import '../../../theme/theme.dart';
import '../../../widgets/refresh_widget.dart';
import 'cola_solicitudes_view_model.dart';

part 'cola_solicitudes_mobile.dart';

class ColaSolicitudesView extends StatelessWidget {
  static const routeName = 'solicitudes/cola-solicitudes';
  const ColaSolicitudesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var permisos =
        Provider.of<PermisosUserProvider>(context, listen: false).permisosUser;
    var menu = Provider.of<MenuProvider>(context, listen: false).menu;
    ColaSolicitudesViewModel viewModel =
        ColaSolicitudesViewModel(permisos, menu);
    return ViewModelBuilder<ColaSolicitudesViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit(context);
        },
        builder: (context, viewModel, child) {
          return _ColaSolicitudesMobile(viewModel);
        });
  }
}
