library fotos_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/fotos/fotos_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import 'package:tasaciones_app/widgets/refresh_widget.dart';

part 'fotos_mobile.dart';

class FotosView extends StatelessWidget {
  static const routeName = 'Parametros Fotos';
  const FotosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FotosViewModel viewModel = FotosViewModel();
    return ViewModelBuilder<FotosViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _FotosMobile(viewModel);
        });
  }
}
