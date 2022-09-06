part of consultar_modificar_view;

class _ConsultarModificarMobile extends StatelessWidget {
  final ConsultarModificarViewModel vm;

  const _ConsultarModificarMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// <<<<<<< HEAD
      appBar: Appbar(
          titulo: vm.solicitudCola.descripcionTipoTasacion ?? '',
          textSize: 18,
          alarmas: vm.alarmas,
          esColaSolicitud: (vm.solicitudCola.id != null) ? false : true,
          idSolicitud: vm.solicitudCola.id ??
              0) /* AppBar(title: Text(vm.solicitudCola.descripcionTipoTasacion ?? '')) */,
      body: Column(
        children: [
          const SizedBox(height: 10),
          LineProgressWidget(
              totalItem: vm.solicitudCola.tipoTasacion != 21
                  ? 2
                  : vm.solicitudCola.estadoTasacion == 9
                      ? 3
                      : 4,
              currentItem: vm.currentForm),
          Expanded(child: _form(context)),
        ],
      ),
// =======
//       appBar: Appbar(
//         titulo:
//             "Solicitud de ${vm.solicitudCola.descripcionTipoTasacion ?? ''}",
//         esColaSolicitud: false,
//         textSize: 18,
//         alarmas: vm.alarmas,
//         currentForm: vm.currentForm,
//         idSolicitud: vm.currentForm == 3 ? vm.solicitud.id! : 0,
//       ),
//       body: _form(),
// >>>>>>> 54fea58bf1ebd9fae1f7632f65f5438839711932
    );
  }

  Widget _form(BuildContext context) {
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
