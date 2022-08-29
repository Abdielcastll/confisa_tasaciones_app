part of cola_solicitudes_view;

class _ColaSolicitudesMobile extends StatelessWidget {
  final ColaSolicitudesViewModel vm;

  const _ColaSolicitudesMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.loading,
      opacity: false,
      child: Scaffold(
        appBar: Appbar(
          textSize: 20,
          titulo: 'Cola de solicitudes',
        ),
        body: _home(context),
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
                      hintText: 'Buscar solicitud',
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
            onRefresh: () => vm.onInit(context),
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
                          onPressed: () => vm.goToSolicitud(s),
                          // vm.modificarAccion(context, accion),
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            // height: 90,
                            padding: const EdgeInsets.all(10),
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
                                  'Cliente: ${s.nombreCliente}',
                                  style: const TextStyle(
                                    color: AppColors.brownDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Fecha de Solicitud:  ${DateFormat.yMEd('es').format(s.fechaCreada!).toUpperCase()}',
                                  style: const TextStyle(
                                    color: AppColors.brownDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
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
    );
  }
}
