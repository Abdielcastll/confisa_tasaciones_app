part of trabajar_view;

class _TrabajarMobile extends StatelessWidget {
  final TrabajarViewModel vm;

  const _TrabajarMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(vm.solicitud.descripcionTipoTasacion ?? '')),
        body: vm.solicitud.tipoTasacion == 22 || vm.solicitud.tipoTasacion == 23
            ? _tasacionForm()
            : Container() //_estimacionForm(),
        );
  }

  Widget _tasacionForm() {
    switch (vm.currentForm) {
      case 1:
        return GeneralesTasacionForm(vm);
      case 2:
        return VehiculoTasacionForm(vm);
      case 3:
        return CondicionesTasacionForm(vm);
      case 4:
        return AccesoriosTasacionForm(vm);
      case 5:
        return FotosTasacionForm(vm);
      case 6:
        return ValoracionTasacionForm(vm);
      default:
        return Container();
    }
  }

  // Widget _estimacionForm() {
  //   switch (vm.currentForm) {
  //     case 1:
  //       return VehiculoForm(vm);
  //     case 2:
  //       return FotosForm(vm);
  //     default:
  //       return Container();
  //   }
  // }
}
