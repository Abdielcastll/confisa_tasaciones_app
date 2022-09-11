part of solicitud_estimacion_view;

class _SolicitudEstimacionMobile extends StatelessWidget {
  final SolicitudEstimacionViewModel vm;

  const _SolicitudEstimacionMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// <<<<<<< HEAD
      appBar: vm.currentForm <= 2
          ? AppBar(
              title: Text("Solicitud de Estimación"),
            )
          : Appbar(
              titulo: "Solicitud de Estimación",
              esColaSolicitud: false,
              textSize: 20,
              alarmas: vm.alarmas,
              idSolicitud: vm.solicitudCreada!.id!,
            ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          LineProgressWidget(totalItem: 4, currentItem: vm.currentForm),
          Expanded(child: _form(context)),
        ],
      ),
// =======
//       appBar: ,
//       body: _form(),
// >>>>>>> 54fea58bf1ebd9fae1f7632f65f5438839711932
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
