part of consultar_modificar_view;

class _ConsultarModificarMobile extends StatelessWidget {
  final ConsultarModificarViewModel vm;

  const _ConsultarModificarMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(vm.solicitudCola.descripcionTipoTasacion ?? '')),
      body: _form(),
    );
  }

  Widget _form() {
    switch (vm.currentForm) {
      case 1:
        return GeneralesA(vm);
      case 2:
        return vm.solicitudCola.tipoTasacion == 22 ||
                vm.solicitudCola.tipoTasacion == 23
            ? GeneralesB(vm)
            : VehiculoForm(vm);
      case 3:
        return FotosForm(vm);
      default:
        return Container();
    }
  }
}
