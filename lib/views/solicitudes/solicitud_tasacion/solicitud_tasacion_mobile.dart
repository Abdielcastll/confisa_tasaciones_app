part of solicitud_tasacion_view;

class _SolicitudTasacionMobile extends StatelessWidget {
  final SolicitudTasacionViewModel vm;

  const _SolicitudTasacionMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(vm.incautado
              ? 'Tasación de Incautado'
              : 'Solicitud de Tasación')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          LineProgressWidget(totalItem: 2, currentItem: vm.currentForm),
          Expanded(child: _form()),
        ],
      ),
    );
  }

  Widget _form() {
    switch (vm.currentForm) {
      case 1:
        return GeneralesA(vm);
      case 2:
        return GeneralesB(vm);
      default:
        return Container();
    }
  }
}
