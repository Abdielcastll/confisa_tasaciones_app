library accesorios_suplidor_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/buscador.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';
import 'accesorios_suplidor_view_model.dart';

part 'accesorios_suplidor_mobile.dart';

class AccesoriosSuplidorView extends StatelessWidget {
  static const routeName = 'Vehículo Accesorios Suplidor';
  const AccesoriosSuplidorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AccesoriosSuplidorViewModel viewModel = AccesoriosSuplidorViewModel();
    return ViewModelBuilder<AccesoriosSuplidorViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _AccesoriosSuplidorMobile(viewModel);
        });
  }
}
