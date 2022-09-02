part of auditoria_view;

class _AuditoriaMobile extends StatelessWidget {
  final AuditoriaViewModel vm;

  const _AuditoriaMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.cargando,
      opacity: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: const Text(
            'Auditoria',
            overflow: TextOverflow.ellipsis,
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
                        child: DropdownSearch<String>(
                            selectedItem: vm.opcion1,
                            popupProps:
                                const PopupProps.menu(fit: FlexFit.loose),
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        label: Text("Opciones"),
                                        border: UnderlineInputBorder())),
                            items: vm.opciones(numeroOpcion: 1),
                            onChanged: (String? value) => vm.opcion = value!)),
                  ),
                ),
                vm.primeraConsulta
                    ? Expanded(
                        child: Card(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownSearch<String>(
                                  popupProps:
                                      const PopupProps.menu(fit: FlexFit.loose),
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          label: Text(vm.opcion1),
                                          border:
                                              const UnderlineInputBorder())),
                                  selectedItem: vm.auditorias.isEmpty
                                      ? "Temp"
                                      : vm.opcion2,
                                  items: vm.auditorias.isEmpty
                                      ? ["Temp"]
                                      : vm.opciones(numeroOpcion: 2),
                                  onChanged: (String? value) =>
                                      vm.opcion2 = value!)),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () => vm.onRefresh(),
                child: vm.auditorias.isEmpty
                    ? const RefreshWidget()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: vm.primeraConsulta &&
                                vm.primeraConsulta &&
                                vm.opcion2 != ""
                            ? vm.auditoriasTemp.length + 1
                            : vm.auditorias.length + 1,
                        controller: vm.listController,
                        itemBuilder: (context, i) {
                          int index = vm.primeraConsulta &&
                                  vm.primeraConsulta &&
                                  vm.opcion2 != ""
                              ? vm.auditoriasTemp.length
                              : vm.auditorias.length;
                          if (i >= index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: !vm.hasNextPage
                                  ? const SizedBox()
                                  : const Center(
                                      child: CircularProgressIndicator()),
                            );
                          }
                          var auditoria = vm.primeraConsulta &&
                                  vm.primeraConsulta &&
                                  vm.opcion2 != ""
                              ? vm.auditoriasTemp[i]
                              : vm.auditorias[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: MaterialButton(
                              onPressed: () =>
                                  vm.modificarAuditoria(context, auditoria),
                              color: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 70,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          vm.opcion1 == "Usuario"
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      auditoria.userId,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color:
                                                            AppColors.brownDark,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Fecha: ${auditoria.fecha}",
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .brownDark,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      "Tabla: ${auditoria.nombreTabla}",
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .brownDark,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                )
                                              : vm.opcion1 == "Tabla"
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          auditoria.nombreTabla,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            color: AppColors
                                                                .brownDark,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Fecha: ${auditoria.fecha}",
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .brownDark,
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          "Usuario: ${auditoria.userId}",
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .brownDark,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    )
                                                  : vm.opcion1 == "Fecha"
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              auditoria.fecha,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                color: AppColors
                                                                    .brownDark,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                            Text(
                                                              "Usuario: ${auditoria.userId}",
                                                              style: const TextStyle(
                                                                  color: AppColors
                                                                      .brownDark,
                                                                  fontSize: 12),
                                                            ),
                                                            Text(
                                                              "Tabla: ${auditoria.nombreTabla}",
                                                              style: const TextStyle(
                                                                  color: AppColors
                                                                      .brownDark,
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox()
                                        ],
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
        ),
      ),
    );
  }
}
