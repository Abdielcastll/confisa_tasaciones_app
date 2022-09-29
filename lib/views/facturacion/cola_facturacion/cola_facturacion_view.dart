library cola_facturacion_view;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../theme/theme.dart';
import '../../../widgets/refresh_widget.dart';
import 'cola_facturacion_view_model.dart';

part 'cola_facturacion_mobile.dart';

// ColaFacturacionViewModel? facturacionProvider;

class ColaFacturacionView extends StatelessWidget {
  static const routeName = 'facturaciones/cola-facturaciones';
  const ColaFacturacionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = ColaFacturacionViewModel();
    return ViewModelBuilder<ColaFacturacionViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
        },
        builder: (context, viewModel, child) {
          return _ColaFacturacionMobile(viewModel);
        });
  }
}
