part of solicitud_estimacion_view;

class _SolicitudEstimacionMobile extends StatelessWidget {
  final SolicitudEstimacionViewModel vm;

  const _SolicitudEstimacionMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        titulo: "Solicitud de Estimación",
        esColaSolicitud: false,
        textSize: 20,
        alarmas: vm.alarmas,
        currentForm: vm.currentForm,
        idSolicitud: vm.currentForm == 3 ? vm.solicitud!.noSolicitud! : 0,
      ),
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
