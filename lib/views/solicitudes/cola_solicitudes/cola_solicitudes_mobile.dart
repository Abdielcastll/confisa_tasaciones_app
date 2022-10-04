part of cola_solicitudes_view;

class _ColaSolicitudesMobile extends StatelessWidget {
  final ColaSolicitudesViewModel vm;

  const _ColaSolicitudesMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    vm.getAlarma(context);

    return ProgressWidget(
      inAsyncCall: vm.loading,
      opacity: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          drawer: GlobalDrawerDartDesktop(menuApp: vm.menu),
          appBar: Appbar(
            textSize: 18,
            titulo: 'Cola de solicitudes',
            esColaSolicitud: true,
            vmColaSolicitudes: vm,
            idSolicitud: 0,
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
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Buscar',
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w700),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.filter_alt_rounded),
                              onPressed: () => vm.filtro(context),
                            ),
                            !vm.busqueda
                                ? IconButton(
                                    icon: const Icon(AppIcons.search),
                                    onPressed: () =>
                                        vm.buscar(vm.tcBuscar.text),
                                    color: AppColors.brownDark,
                                  )
                                : IconButton(
                                    onPressed: vm.limpiarBusqueda,
                                    icon: const Icon(
                                      AppIcons.closeCircle,
                                      color: AppColors.brownDark,
                                    )),
                          ],
                        )),
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
            onRefresh: () => vm.onRefresh(),
            child: vm.solicitudes.isEmpty
                ? const RefreshWidget()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: vm.solicitudes.length + 1,
                    controller: vm.listController,
                    itemBuilder: (_, i) {
                      if (i >= vm.solicitudes.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: !vm.hasNextPage
                              ? const SizedBox()
                              : const Center(
                                  child: CircularProgressIndicator()),
                        );
                      }
                      var s = vm.solicitudes[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 5),
                        child: MaterialButton(
                          onPressed: () => vm.goToSolicitud(s, context),
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
                                      'Tasación No.${s.noTasacion}',
                                      style: const TextStyle(
                                        color: AppColors.brownDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Solicitud No.${s.noSolicitudCredito}',
                                      style: const TextStyle(
                                        color: AppColors.brownDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${s.descripcionTipoTasacion} - ${s.descripcionEstadoTasacion}',
                                      style: const TextStyle(
                                        color: AppColors.brownDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Cliente: ${s.nombreCliente}',
                                      style: const TextStyle(
                                        color: AppColors.brownDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Fecha de Solicitud:  ${DateFormat.yMEd('es').format(s.fechaCreada!).toUpperCase()}',
                                      style: const TextStyle(
                                        color: AppColors.brownDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  color:
                                      colorSolicitudByStatus(s.estadoTasacion!),
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
