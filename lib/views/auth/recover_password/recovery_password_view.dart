library recovery_password_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/core/utils/validators.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/auth/widgets/auth_page_widget.dart';
import 'package:tasaciones_app/widgets/app_buttons.dart';
import 'package:tasaciones_app/widgets/app_textfield.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';

import 'recovery_password_view_model.dart';

part 'recovery_password_mobile.dart';

class RecoveryPasswordView extends StatelessWidget {
  static const routeName = 'recoveryPassword';
  const RecoveryPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = RecoveryPasswordViewModel();
    return ViewModelBuilder<RecoveryPasswordViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _RecoveryPasswordMobile(viewModel);
        });
  }
}
