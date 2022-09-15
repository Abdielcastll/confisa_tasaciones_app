part of trabajar_view;

class _TrabajarMobile extends StatelessWidget {
  final TrabajarViewModel vm;

  const _TrabajarMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar:
              AppBar(title: Text(vm.solicitud.descripcionTipoTasacion ?? '')),
          body:
              vm.solicitud.tipoTasacion == 22 || vm.solicitud.tipoTasacion == 23
                  ? Column(
                      children: [
                        const SizedBox(height: 10),
                        LineProgressWidget(
                            totalItem: 6, currentItem: vm.currentForm),
                        Expanded(child: _tasacionForm()),
                      ],
                    )
                  : Column(
                      children: [
                        const SizedBox(height: 10),
                        LineProgressWidget(
                            totalItem: 4, currentItem: vm.currentForm),
                        Expanded(child: _estimacionForm()),
                      ],
                    ) //_estimacionForm(),
          ),
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

  Widget _estimacionForm() {
    switch (vm.currentForm) {
      case 1:
        return GeneralesEstimacionForm(vm);
      case 2:
        return VehiculoEstimacionForm(vm);
      case 3:
        return FotosEstimacionForm(vm);
      case 4:
        return ValoracionEstimacionForm(vm);
      default:
        return Container();
    }
  }
}
