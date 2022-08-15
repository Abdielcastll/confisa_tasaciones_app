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
  const NotasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotasViewModel viewModel = NotasViewModel();
    return ViewModelBuilder<NotasViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _NotasMobile(viewModel);
        });
  }
}
