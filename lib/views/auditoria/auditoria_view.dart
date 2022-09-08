library auditoria_view;

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/auditoria/auditoria_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';

part 'auditoria_mobile.dart';

class AuditoriaView extends StatelessWidget {
  static const routeName = 'Auditorías';
  const AuditoriaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuditoriaViewModel viewModel = AuditoriaViewModel();
    return ViewModelBuilder<AuditoriaViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _AuditoriaMobile(viewModel);
        });
  }
}
