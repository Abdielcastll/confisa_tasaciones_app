library suplidores_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_generales/suplidores/suplidores_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';

part 'suplidores_mobile.dart';

class SuplidoresView extends StatelessWidget {
  static const routeName = 'mantenimientos/general/suplidores';
  const SuplidoresView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SuplidoresViewModel viewModel = SuplidoresViewModel();
    return ViewModelBuilder<SuplidoresViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _SuplidoresMobile(viewModel);
        });
  }
}
