library parametros_servidor_email_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_generales/parametros_servidor_email/parametros_servidor_email_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';

part 'parametros_servidor_email_mobile.dart';

class ParametrosServidorEmailView extends StatelessWidget {
  static const routeName = 'mantenimientos/general/servidores-email';
  const ParametrosServidorEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ParametrosServidorEmailViewModel viewModel =
        ParametrosServidorEmailViewModel();
    return ViewModelBuilder<ParametrosServidorEmailViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _ParametrosServidorEmailMobile(viewModel);
        });
  }
}
