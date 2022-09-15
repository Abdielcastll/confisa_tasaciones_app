part of solicitud_estimacion_view;

class _SolicitudEstimacionMobile extends StatelessWidget {
  final SolicitudEstimacionViewModel vm;

  const _SolicitudEstimacionMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Solicitud de Estimación'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            LineProgressWidget(totalItem: 4, currentItem: vm.currentForm),
            Expanded(child: _form(context)),
          ],
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    switch (vm.currentForm) {
      case 1:
        return GeneralesForm(vm);
      case 2:
        return VehiculoForm(vm);
      case 3:
        return FotosForm(vm);
      case 4:
        return EnviarForm(
          atras: () => vm.currentForm = 3,
          enviar: () => vm.enviarSolicitud(context),
        );
      default:
        return Container();
    }
  }
}
