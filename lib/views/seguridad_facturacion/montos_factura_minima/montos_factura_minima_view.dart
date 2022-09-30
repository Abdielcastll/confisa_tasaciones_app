library montos_factura_minima_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/seguridad_facturacion/montos_factura_minima/montos_factura_minima_view_model.dart';
import 'package:tasaciones_app/views/seguridad_facturacion/tarifario_tasacion/tarifario_tasacion_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';

part 'montos_factura_minima_mobile.dart';

class MontosFacturaMinimaView extends StatelessWidget {
  static const routeName = 'mantenimientos/facturacion/montos-factura-minima';
  const MontosFacturaMinimaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MontosFacturaMinimaViewModel viewModel = MontosFacturaMinimaViewModel();
    return ViewModelBuilder<MontosFacturaMinimaViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _MontosFacturaMinimaMobile(viewModel);
        });
  }
}
