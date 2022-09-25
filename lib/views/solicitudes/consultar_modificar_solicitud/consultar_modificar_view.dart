library consultar_modificar_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/views/solicitudes/consultar_modificar_solicitud/widgets/forms/accesorios.dart';
import 'package:tasaciones_app/views/solicitudes/consultar_modificar_solicitud/widgets/forms/aprobar.dart';
import 'package:tasaciones_app/views/solicitudes/consultar_modificar_solicitud/widgets/forms/fotos.dart';
import 'package:tasaciones_app/views/solicitudes/consultar_modificar_solicitud/widgets/forms/vehiculo.dart';
import 'package:tasaciones_app/widgets/appbar_widget.dart';
import '../../../core/models/solicitudes/solicitudes_get_response.dart';
import '../../../widgets/app_progress_widget.dart';
import '../solicitud_estimacion/widgets/forms/enviar.dart';
import 'consultar_modificar_view_model.dart';
import 'widgets/forms/condiciones.dart';
import 'widgets/forms/generales_a.dart';
import 'widgets/forms/generales_b.dart';
import 'widgets/forms/valoracion.dart';

part 'consultar_modificar_mobile.dart';

class ConsultarModificarView extends StatelessWidget {
  static const routeName = 'ConsultarModificarView';
  const ConsultarModificarView({this.solicitudData, Key? key})
      : super(key: key);
  final SolicitudesData? solicitudData;

  @override
  Widget build(BuildContext context) {
    ConsultarModificarViewModel viewModel = ConsultarModificarViewModel();
    return ViewModelBuilder<ConsultarModificarViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit(context, solicitudData);
        },
        builder: (context, viewModel, child) {
          return _ConsultarModificarMobile(viewModel);
        });
  }
}
