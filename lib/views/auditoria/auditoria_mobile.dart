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
                Container(
                    width: vm.primeraConsulta
                        ? 150
                        : MediaQuery.of(context).size.width,
                    height: 66,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
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
                            onChanged: (String? value) => vm.opcion = value!),
                      ),
                    )),
                vm.primeraConsulta
                    ? Flexible(
                        fit: FlexFit.loose,
                        child: Card(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownSearch<String>(
                                  popupProps: const PopupProps.menu(
                                    fit: FlexFit.loose,
                                  ),
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          label: Text(vm.opcion1),
                                          border:
                                              const UnderlineInputBorder())),
                                  dropdownBuilder: (context, selectedItem) =>
                                      Text(
                                        selectedItem!,
                                        style: const TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  selectedItem:
                                      vm.auditorias.isEmpty ? "" : vm.opcion2,
                                  items: vm.auditorias.isEmpty
                                      ? [""]
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
                                                      auditoria.userName,
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
                                                      "Fecha: ${auditoria.fecha.split("T").first} Hora: ${auditoria.fecha.split("T")[1]}",
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
                                                          "Fecha: ${auditoria.fecha.split("T").first} Hora:${auditoria.fecha.split("T")[1]}",
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .brownDark,
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          "Usuario: ${auditoria.userName}",
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
                                                              "Fecha: ${auditoria.fecha.split("T").first} Hora:${auditoria.fecha.split("T")[1]}",
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
                                                              "Usuario: ${auditoria.userName}",
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
