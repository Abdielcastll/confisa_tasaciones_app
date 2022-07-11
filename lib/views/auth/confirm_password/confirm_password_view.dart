library confirm_password_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../theme/theme.dart';
import '../../../widgets/app_buttons.dart';
import '../../../widgets/app_obscure_text_icon.dart';
import '../../../widgets/app_textfield.dart';
import '../widgets/auth_page_widget.dart';
import 'confirm_password_view_model.dart';

part 'confirm_password_mobile.dart';

class ConfirmPasswordView extends StatelessWidget {
  static const routeName = 'recoveryPassword';
  const ConfirmPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = ConfirmPasswordViewModel();
    return ViewModelBuilder<ConfirmPasswordViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _ConfirmPasswordMobile(viewModel);
        });
  }
}
