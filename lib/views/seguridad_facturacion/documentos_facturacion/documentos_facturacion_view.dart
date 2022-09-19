library documentos_facturacion_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/seguridad_facturacion/documentos_facturacion/documentos_facturacion_view_model.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';

part 'documentos_facturacion_mobile.dart';

class DocumentosFacturacionView extends StatelessWidget {
  static const routeName = 'Documentos Facturación';
  const DocumentosFacturacionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocumentosFacturacionViewModel viewModel = DocumentosFacturacionViewModel();
    return ViewModelBuilder<DocumentosFacturacionViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _DocumentosFacturacionMobile(viewModel);
        });
  }
}
