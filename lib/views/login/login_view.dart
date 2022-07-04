library home_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/app_buttons.dart';
import 'package:tasaciones_app/widgets/app_textfield.dart';
import 'login_view_model.dart';

part 'login_mobile.dart';

class LoginView extends StatelessWidget {
  static const routeName = 'login';
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = LoginViewModel();
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _LoginMobile(viewModel);
        });
  }
}
