part of componentes_vehiculo_suplidor_view;

class _ComponentesVehiculoSuplidorMobile extends StatelessWidget {
  final ComponentesVehiculoSuplidorViewModel vm;

  const _ComponentesVehiculoSuplidorMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.cargando,
      opacity: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: const Text(
            'Vehículo Componentes Suplidor',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.brownLight,
        ),
        body: !(vm.usuario!.idSuplidor != 0 ||
                vm.usuario!.roles!.any(
                    (element) => element.roleName == "AprobadorTasaciones"))
            ? Column(
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
                              onSubmitted: vm.buscarComponentesVehiculoSuplidor,
                              style: const TextStyle(
                                color: AppColors.brownDark,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Buscar Suplidor',
                                hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                                suffixIcon: !vm.busqueda
                                    ? IconButton(
                                        icon: const Icon(AppIcons.search),
                                        onPressed: () => vm
                                            .buscarComponentesVehiculoSuplidor(
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
                    ],
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      onRefresh: () => vm.onRefresh(),
                      child: vm.suplidores.isEmpty
                          ? const RefreshWidget()
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: vm.suplidores.length + 1,
                              controller: vm.listController,
                              itemBuilder: (context, i) {
                                if (i >= vm.suplidores.length) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    child: !vm.hasNextPage
                                        ? const SizedBox()
                                        : const Center(
                                            child: CircularProgressIndicator()),
                                  );
                                }
                                var suplidor = vm.suplidores[i];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 5),
                                  child: MaterialButton(
                                    onPressed: () =>
                                        vm.modificarComponentesVehiculoSuplidor(
                                            context, suplidor),
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
                                                Text(
                                                  suplidor.nombre,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: AppColors.brownDark,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                Text(
                                                  "Identificación: ${suplidor.identificacion}",
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color:
                                                          AppColors.brownDark,
                                                      fontSize: 12),
                                                ),
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
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buscador(
                      text: 'Buscar componente...',
                      onChanged: (value) => vm.buscarAprobadorSuplidor(value)),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: AppColors.gold, width: 2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DataTable(
                                    onSelectAll: (isSelectedAll) =>
                                        vm.selectAll(isSelectedAll!),
                                    columns: const [
                                      DataColumn(
                                        label: Text("Componente"),
                                      ),
                                    ],
                                    rows: vm.componentesAprobador
                                        .map((e) => DataRow(
                                                selected: vm.select(e),
                                                onSelectChanged: (isSelected) =>
                                                    vm.selectChange(
                                                        isSelected!, e),
                                                cells: [
                                                  DataCell(
                                                    Text(
                                                      e.descripcion,
                                                    ),
                                                    onTap: null,
                                                  ),
                                                ]))
                                        .toList()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => vm.guardar(context),
                          // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Icon(
                                AppIcons.save,
                                color: AppColors.green,
                              ),
                              SizedBox(
                                height: 3,
                              ), // icon
                              Text("Guardar"), // text
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
