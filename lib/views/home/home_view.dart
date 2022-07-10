library home_view;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/core/api/permisos_api.dart';
import 'package:tasaciones_app/core/models/permisos_response.dart';
import '../../core/api/api_status.dart';
import '../../core/locator.dart';
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
        Provider.of<PermisosUserProvider>(context, listen: false).permisosUser;
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
