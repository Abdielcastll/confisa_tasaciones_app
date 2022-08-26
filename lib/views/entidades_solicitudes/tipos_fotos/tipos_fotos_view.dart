library tipos_fotos_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/tipos_fotos/tipos_fotos_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';

part 'tipos_fotos_mobile.dart';

class TiposFotosView extends StatelessWidget {
  static const routeName = 'Parámetro Tipo Fotos';
  const TiposFotosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TiposFotosViewModel viewModel = TiposFotosViewModel();
    return ViewModelBuilder<TiposFotosViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _TiposFotosMobile(viewModel);
        });
  }
}
