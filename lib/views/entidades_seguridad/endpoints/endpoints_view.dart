library endpoints_view;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/progress_widget.dart';
import '../../../widgets/refresh_widget.dart';
import 'endpoints_view_model.dart';

part 'endpoints_mobile.dart';

class EndpointsView extends StatelessWidget {
  static const routeName = 'Endpoints';
  const EndpointsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EndpointsViewModel viewModel = EndpointsViewModel();
    return ViewModelBuilder<EndpointsViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onModelReady: (viewModel) {
          viewModel.onInit();
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return _EndpointsMobile(viewModel);
        });
  }
}
