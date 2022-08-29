part of consultar_modificar_view;

class _ConsultarModificarMobile extends StatelessWidget {
  final ConsultarModificarViewModel vm;

  const _ConsultarModificarMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        titulo:
            "Solicitud de ${vm.solicitudCola.descripcionTipoTasacion ?? ''}",
        esColaSolicitud: false,
        textSize: 18,
        alarmas: vm.alarmas,
        currentForm: vm.currentForm,
        idSolicitud: vm.currentForm == 3 ? vm.solicitud.id! : 0,
      ),
      body: _form(),
    );
  }

  Widget _form() {
    switch (vm.currentForm) {
      case 1:
        return GeneralesA(vm);
      case 2:
        return vm.solicitudCola.tipoTasacion == 22
            ? GeneralesB(vm)
            : VehiculoForm(vm);
      case 3:
        return FotosForm(vm);
      default:
        return Container();
    }
  }
}
