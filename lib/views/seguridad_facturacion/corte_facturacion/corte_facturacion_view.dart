library corte_facturacion_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/seguridad_facturacion/corte_facturacion/corte_facturacion_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';

part 'corte_facturacion_mobile.dart';

class CorteFacturacionView extends StatelessWidget {
  static const routeName = 'Días Corte de Facturación';
  const CorteFacturacionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CorteFacturacionViewModel viewModel = CorteFacturacionViewModel();
    return ViewModelBuilder<CorteFacturacionViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _CorteFacturacionMobile(viewModel);
        });
  }
}
