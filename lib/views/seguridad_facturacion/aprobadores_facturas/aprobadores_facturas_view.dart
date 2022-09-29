library aprobadores_facturas_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/seguridad_facturacion/aprobadores_facturas/aprobadores_facturas_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';

part 'aprobadores_facturas_mobile.dart';

class AprobadoresFacturasView extends StatelessWidget {
  static const routeName = 'mantenimientos/facturacion/aprobadores-facturas';
  const AprobadoresFacturasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AprobadoresFacturasViewModel viewModel = AprobadoresFacturasViewModel();
    return ViewModelBuilder<AprobadoresFacturasViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _AprobadoresFacturasMobile(viewModel);
        });
  }
}
