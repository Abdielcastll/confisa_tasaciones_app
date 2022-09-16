part of consultar_modificar_view;

class _ConsultarModificarMobile extends StatelessWidget {
  final ConsultarModificarViewModel vm;

  const _ConsultarModificarMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: Appbar(
            titulo: vm.solicitud.descripcionTipoTasacion ?? '',
            textSize: 18,
            alarmas: vm.alarmas,
            esColaSolicitud: (vm.solicitud.id != null) ? false : true,
            idSolicitud: vm.solicitud.id ??
                0) /* AppBar(title: Text(vm.solicitudCola.descripcionTipoTasacion ?? '')) */,
        body: Column(
          children: [
            const SizedBox(height: 10),
            if (showLineProgress())
              LineProgressWidget(
                  totalItem: lineProgressItemsEstimacion(),
                  currentItem: vm.currentForm),
            Expanded(child: _form(context)),
          ],
        ),
      ),
    );
  }

  bool showLineProgress() {
    if (vm.solicitud.tipoTasacion == 22 && vm.solicitud.estadoTasacion == 9) {
      return false;
    }
    if (vm.solicitud.tipoTasacion == 23 && vm.solicitud.estadoTasacion == 9) {
      return false;
    }
    return true;
  }

  int lineProgressItemsEstimacion() {
    switch (vm.solicitud.estadoTasacion) {
      case 9:
        return 3;
      case 10:
        return vm.isAprobador ? 4 : 3;
      default:
        return 4;
    }
  }

  // int lineProgressItemsTasacion() {
  //   switch (vm.solicitud.estadoTasacion) {
  //     case 9:
  //       return 3;
  //     case 10:
  //       return 3;
  //     default:
  //       return 4;
  //   }
  // }

  Widget _form(BuildContext context) {
    switch (vm.currentForm) {
      case 1:
        return GeneralesA(vm);
      case 2:
        return VehiculoForm(vm);
      case 3:
        return FotosForm(vm);
      case 4:
        return vm.solicitud.estadoTasacion == 34
            ? EnviarForm(
                atras: () => vm.currentForm = 3,
                enviar: () => vm.enviarSolicitud(context),
              )
            : vm.isAprobador && vm.solicitud.estadoTasacion == 10
                ? AprobarForm(vm)
                : ValoracionForm(vm);

      default:
        return Container();
    }
  }
}
