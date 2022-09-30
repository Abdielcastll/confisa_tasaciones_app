library porcentajes_honorarios_entidad_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/seguridad_facturacion/porcentajes_honorarios_entidad/porcentajes_honorarios_entidad_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';

part 'porcentajes_honorarios_entidad_mobile.dart';

class PorcentajesHonorariosEntidadView extends StatelessWidget {
  static const routeName =
      'mantenimientos/facturacion/porcentajes-honorarios-entidad';
  const PorcentajesHonorariosEntidadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PorcentajesHonorariosEntidadViewModel viewModel =
        PorcentajesHonorariosEntidadViewModel();
    return ViewModelBuilder<PorcentajesHonorariosEntidadViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _PorcentajesHonorariosEntidadMobile(viewModel);
        });
  }
}
