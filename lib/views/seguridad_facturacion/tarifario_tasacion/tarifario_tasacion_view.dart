library tarifario_tasacion_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/seguridad_facturacion/tarifario_tasacion/tarifario_tasacion_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';

part 'tarifario_tasacion_mobile.dart';

class TarifarioTasacionView extends StatelessWidget {
  static const routeName = 'Tarifario Servicios Tasación';
  const TarifarioTasacionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TarifarioTasacionViewModel viewModel = TarifarioTasacionViewModel();
    return ViewModelBuilder<TarifarioTasacionViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _TarifarioTasacionMobile(viewModel);
        });
  }
}
