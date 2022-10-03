part of consultar_modificar_view;

class _ConsultarModificarMobile extends StatelessWidget {
  final ConsultarModificarViewModel vm;

  const _ConsultarModificarMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    vm.getAlarmas(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: Appbar(
            titulo: vm.solicitud.descripcionTipoTasacion ?? '',
            textSize: 18,
            // getAlarmas: vm.getAlarmas(),
            esColaSolicitud: (vm.solicitud.id != null) ? false : true,
            idSolicitud: vm.solicitud.id ??
                0) /* AppBar(title: Text(vm.solicitudCola.descripcionTipoTasacion ?? '')) */,
        body: Column(
          children: [
            const SizedBox(height: 10),
            if (showLineProgress())
              LineProgressWidget(
                  totalItem: vm.isTasador && vm.mostrarAccComp
                      ? 6
                      : lineProgressItemsEstimacion(),
                  currentItem: vm.currentForm),
            Expanded(
                child: vm.isTasador && vm.mostrarAccComp
                    ? _formTasador(context)
                    : _form(context)),
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
        // return vm.isAprobador ? 4 : 3;
        return 4;
      default:
        return 4;
    }
  }

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

  Widget _formTasador(BuildContext context) {
    switch (vm.currentForm) {
      case 1:
        return GeneralesA(vm);
      case 2:
        return VehiculoForm(vm);
      case 3:
        return CondicionesForm(vm);
      case 4:
        return AccesoriosForm(vm);
      case 5:
        return FotosForm(vm);
      case 6:
        return ValoracionForm(vm);

      default:
        return Container();
    }
  }
}
