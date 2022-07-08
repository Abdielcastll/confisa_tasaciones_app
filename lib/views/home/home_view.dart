library home_view;

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/core/api/roles_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/logger.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';
import '../../core/api/api_status.dart';
import '../../core/models/sign_in_response.dart';
import '../../core/providers/permisos_provider.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/global_drawer_widget.dart';
import 'home_view_model.dart';

part 'home_mobile.dart';

class HomeView extends StatelessWidget {
  static const routeName = 'home';
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var permisos =
        Provider.of<PermisosProvider>(context, listen: false).permisos;
    HomeViewModel viewModel = HomeViewModel();

    viewModel.permisos = permisos;
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
        },
        builder: (context, viewModel, child) {
          return _HomeMobile(viewModel);
        });
  }
}
