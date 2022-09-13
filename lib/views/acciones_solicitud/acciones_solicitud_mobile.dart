part of acciones_solicitud_view;

class _AccionesSolicitudMobile extends StatelessWidget {
  final AccionesSolicitudViewModel vm;
  final bool showCreate;
  final int idSolicitud;

  const _AccionesSolicitudMobile(this.vm, this.showCreate, this.idSolicitud);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.cargando,
      opacity: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: const Text(
            'Acciones Solicitud',
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
                        onSubmitted: vm.buscarAccionesSolicitud,
                        style: const TextStyle(
                          color: AppColors.brownDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Buscar Acciones Solicitud...',
                          hintStyle: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w700),
                          suffixIcon: !vm.busqueda
                              ? IconButton(
                                  icon: const Icon(AppIcons.search),
                                  onPressed: () => vm.buscarAccionesSolicitud(
                                      vm.tcBuscar.text),
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
                showCreate
                    ? MaterialButton(
                        onPressed: () => vm.crearAccionesSolicitud(context),
                        color: Colors.white,
                        minWidth: 30,
                        height: 48,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        elevation: 4,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            AppIcons.iconPlus,
                            color: AppColors.green,
                          ),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(width: 5),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () => vm.onRefresh(),
                child: vm.accionesSolicitud.isEmpty
                    ? const RefreshWidget()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: vm.accionesSolicitud.length + 1,
                        controller: vm.listController,
                        itemBuilder: (context, i) {
                          if (i >= vm.accionesSolicitud.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: !vm.hasNextPage
                                  ? const SizedBox()
                                  : const Center(
                                      child: CircularProgressIndicator()),
                            );
                          }
                          var accionSolicitud = vm.accionesSolicitud[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: MaterialButton(
                              onPressed: () => vm.modificarAccionSolicitud(
                                  context, accionSolicitud),
                              color: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 85,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      accionSolicitud.notas,
                                      style: const TextStyle(
                                        color: AppColors.brownDark,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      "Solicitud: " +
                                          accionSolicitud.noSolicitudCredito
                                              .toString(),
                                      style: const TextStyle(
                                          color: AppColors.brownDark,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      "Tasación: " +
                                          accionSolicitud.noTasacion.toString(),
                                      style: const TextStyle(
                                          color: AppColors.brownDark,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      "Fecha: " +
                                          accionSolicitud.fechaHora
                                              .split("T")
                                              .join(" Hora: ")
                                              .toString(),
                                      style: const TextStyle(
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
