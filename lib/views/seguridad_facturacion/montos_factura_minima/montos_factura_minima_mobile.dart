part of montos_factura_minima_view;

class _MontosFacturaMinimaMobile extends StatelessWidget {
  final MontosFacturaMinimaViewModel vm;

  const _MontosFacturaMinimaMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.cargando,
      opacity: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: const Text(
            'Montos Factura Mínima',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.brownLight,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: vm.tcBuscar,
                        onSubmitted: vm.buscarSucursal,
                        style: const TextStyle(
                          color: AppColors.brownDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Buscar Sucursal...',
                          hintStyle: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700),
                          suffixIcon: !vm.busqueda
                              ? IconButton(
                                  icon: const Icon(AppIcons.search),
                                  onPressed: () =>
                                      vm.buscarSucursal(vm.tcBuscar.text),
                                  color: AppColors.brownDark,
                                )
                              : IconButton(
                                  onPressed: vm.limpiarBusqueda,
                                  icon: const Icon(
                                    AppIcons.closeCircle,
                                    color: AppColors.brownDark,
                                  )),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () => vm.onRefresh(),
                child: vm.sucursales.isEmpty
                    ? const RefreshWidget()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: vm.sucursales.length,
                        controller: vm.listController,
                        itemBuilder: (context, i) {
                          var sucursal = vm.sucursales[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: MaterialButton(
                              onPressed: () => vm.modificarMontosFacturaMinima(
                                  context, sucursal),
                              color: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 75,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sucursal.nombre,
                                      style: const TextStyle(
                                        color: AppColors.brownDark,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    vm.montosFacturaMinima.any((element) =>
                                            element.codigoSucursal ==
                                            sucursal.codigoSucursal)
                                        ? Text(
                                            "Monto: ${vm.montosFacturaMinima.firstWhere((element) => element.codigoSucursal == sucursal.codigoSucursal).valor}",
                                            style: const TextStyle(
                                                color: AppColors.brownDark,
                                                fontSize: 12),
                                          )
                                        : const Text(
                                            "Monto a definir",
                                            style: TextStyle(
                                                color: AppColors.brownDark,
                                                fontSize: 12),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
