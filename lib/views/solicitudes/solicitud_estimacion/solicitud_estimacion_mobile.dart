part of solicitud_estimacion_view;

class _SolicitudEstimacionMobile extends StatelessWidget {
  final SolicitudEstimacionViewModel vm;

  const _SolicitudEstimacionMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitud de Estimación')),
      body: _form(),
    );
  }

  Widget _form() {
    switch (vm.currentForm) {
      case 1:
        return GeneralesForm(vm);
      case 2:
        return VehiculoForm(vm);
      case 3:
        return FotosForm(vm);
      default:
        return Container();
    }
  }
}
