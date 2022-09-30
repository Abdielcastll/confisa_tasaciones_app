part of cola_facturacion_view;

class _ColaFacturacionMobile extends StatelessWidget {
  final ColaFacturacionViewModel vm;

  const _ColaFacturacionMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.loading,
      opacity: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Facturación de Servicios'),
          ),
          body: _home(context),
        ),
      ),
    );
  }

  Widget _home(BuildContext context) {
    return Column(
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
                    onSubmitted: vm.buscar,
                    style: const TextStyle(
                      color: AppColors.brownDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Buscar Factura',
                      hintStyle: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w700),
                      suffixIcon: !vm.busqueda
                          ? IconButton(
                              icon: const Icon(AppIcons.search),
                              onPressed: () => vm.buscar(vm.tcBuscar.text),
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
            const SizedBox(width: 5),
          ],
        ),
        Expanded(
          child: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () => vm.onInit(),
            child: vm.facturas.isEmpty
                ? const RefreshWidget()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: vm.facturas.length,
                    itemBuilder: (_, i) {
                      var s = vm.facturas[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 5),
                        child: MaterialButton(
                          onPressed: () => vm.goToFactura(s),
                          color: Colors.white,
                          clipBehavior: Clip.antiAlias,
                          padding: EdgeInsets.zero,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Factura No.${s.noFactura}',
                                      style: const TextStyle(
                                        color: AppColors.brownDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Text(
                                          'Entidad: ',
                                          style: TextStyle(
                                            color: AppColors.brownDark,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${s.descripcionEntidad}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppColors.brownDark,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Text(
                                          'Suplidor: ',
                                          style: TextStyle(
                                            color: AppColors.brownDark,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${s.descripcionSuplidor}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppColors.brownDark,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Text(
                                          'Período de Facturación: ',
                                          style: TextStyle(
                                            color: AppColors.brownDark,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${DateFormat.yMd('es').format(s.periodoFacturacionInicial!)} - ${DateFormat.yMd('es').format(s.periodoFacturacionFinal!)}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppColors.brownDark,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Text(
                                          'Estado: ',
                                          style: TextStyle(
                                            color: AppColors.brownDark,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          '${s.descripcionEstado}',
                                          style: const TextStyle(
                                            color: AppColors.brownDark,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Text(
                                          'Monto: ',
                                          style: TextStyle(
                                            color: AppColors.brownDark,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          vm.fmf
                                              .copyWith(amount: s.totalApagar)
                                              .output
                                              .symbolOnLeft,
                                          style: const TextStyle(
                                            color: AppColors.brownDark,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  color: colorFacturaByStatus(s.idEstado!),
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
          ),
        )
      ],
    );
  }
}
