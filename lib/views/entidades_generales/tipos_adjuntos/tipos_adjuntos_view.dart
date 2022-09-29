library tipos_adjuntos_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';
import 'tipos_adjuntos_view_model.dart';

part 'tipos_adjuntos_mobile.dart';

class TiposAdjuntosView extends StatelessWidget {
  static const routeName = 'mantenimientos/general/tipos-adjuntos';
  const TiposAdjuntosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TiposAdjuntosViewModel viewModel = TiposAdjuntosViewModel();
    return ViewModelBuilder<TiposAdjuntosViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _TiposAdjuntosMobile(viewModel);
        });
  }
}
