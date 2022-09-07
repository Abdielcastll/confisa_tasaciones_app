part of consultar_modificar_view;

class _ConsultarModificarMobile extends StatelessWidget {
  final ConsultarModificarViewModel vm;

  const _ConsultarModificarMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(vm.solicitud.descripcionTipoTasacion ?? '')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          LineProgressWidget(
              totalItem: vm.solicitud.tipoTasacion == 22 ||
                      vm.solicitud.tipoTasacion == 23
                  ? 2
                  : vm.solicitud.estadoTasacion == 34
                      ? 4
                      : 3,
              currentItem: vm.currentForm),
          Expanded(child: _form(context)),
        ],
      ),
    );
  }

  Widget _form(BuildContext context) {
    switch (vm.currentForm) {
      case 1:
        return GeneralesA(vm);
      case 2:
        return vm.solicitud.tipoTasacion == 22 ||
                vm.solicitud.tipoTasacion == 23
            ? GeneralesB(vm)
            : VehiculoForm(vm);
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
