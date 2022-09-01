library cantidad_fotos_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/cantidad_fotos/cantidad_fotos_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';

part 'cantidad_fotos_mobile.dart';

class CantidadFotosView extends StatelessWidget {
  static const routeName = 'Cantidad Fotos';
  const CantidadFotosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CantidadFotosViewModel viewModel = CantidadFotosViewModel();
    return ViewModelBuilder<CantidadFotosViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _CantidadFotosMobile(viewModel);
        });
  }
}
