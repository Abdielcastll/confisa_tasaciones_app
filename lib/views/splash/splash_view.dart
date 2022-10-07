library splash_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'splash_view_model.dart';

part 'splash_mobile.dart';

class SplashView extends StatelessWidget {
  static const routeName = 'Splash';
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SplashViewModel viewModel = SplashViewModel();
    return ViewModelBuilder<SplashViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (vm) => vm.init(context),
        builder: (context, viewModel, child) {
          return _SplashMobile(viewModel);
        });
  }
}
