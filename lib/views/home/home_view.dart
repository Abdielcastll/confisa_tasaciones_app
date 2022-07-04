library home_view;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/core/provider/user_data_provider.dart';
import '../../widgets/global_drawer_widget.dart';
import 'home_view_model.dart';

part 'home_mobile.dart';

class HomeView extends StatelessWidget {
  static const routeName = 'home';
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeViewModel viewModel = HomeViewModel();
    var user = context.read<UserProvider>().user;
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.user = user.data;
        },
        builder: (context, viewModel, child) {
          return _HomeMobile(viewModel);
        });
  }
}
