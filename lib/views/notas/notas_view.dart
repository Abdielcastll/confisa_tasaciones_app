library notas_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';
import 'notas_view_model.dart';

part 'notas_mobile.dart';

class NotasView extends StatelessWidget {
  static const routeName = 'Notas';
  final int idSolicitud;
  final bool showCreate;
  const NotasView(
      {Key? key, required this.idSolicitud, required this.showCreate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotasViewModel viewModel =
        NotasViewModel(idSolicitud: idSolicitud, showCreate: showCreate);
    return ViewModelBuilder<NotasViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit(context);
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _NotasMobile(viewModel, idSolicitud, showCreate);
        });
  }
}
