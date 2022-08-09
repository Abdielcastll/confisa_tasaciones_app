library suplidores_default_view;

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_generales/suplidores_default/suplidores_default_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';

part 'suplidores_default_mobile.dart';

class SuplidoresDefaultView extends StatelessWidget {
  static const routeName = 'Suplidores Default Entidad';
  const SuplidoresDefaultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SuplidoresDefaultViewModel viewModel = SuplidoresDefaultViewModel();
    return ViewModelBuilder<SuplidoresDefaultViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _SuplidoresDefaultMobile(viewModel);
        });
  }
}
