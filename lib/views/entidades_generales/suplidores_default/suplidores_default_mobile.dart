part of suplidores_default_view;

class _SuplidoresDefaultMobile extends StatelessWidget {
  final SuplidoresDefaultViewModel vm;

  const _SuplidoresDefaultMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.cargando,
      opacity: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: const Text(
            'Suplidores Default Entidad',
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
                        onSubmitted: vm.buscarSuplidorDefault,
                        style: const TextStyle(
                          color: AppColors.brownDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Buscar Suplidores Default Entidad',
                          hintStyle: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w700),
                          suffixIcon: !vm.busqueda
                              ? IconButton(
                                  icon: const Icon(AppIcons.search),
                                  onPressed: () => vm
                                      .buscarSuplidorDefault(vm.tcBuscar.text),
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
                MaterialButton(
                  onPressed: () => vm.crearsuplidorDefault(context),
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
                ),
                const SizedBox(width: 5),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () => vm.onRefresh(),
                child: vm.suplidoresDefault.isEmpty
                    ? const RefreshWidget()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: vm.suplidoresDefault.length + 1,
                        controller: vm.listController,
                        itemBuilder: (context, i) {
                          if (i >= vm.suplidoresDefault.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: !vm.hasNextPage
                                  ? const SizedBox()
                                  : const Center(
                                      child: CircularProgressIndicator()),
                            );
                          }
                          var suplidor = vm.suplidoresDefault[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: MaterialButton(
                              onPressed: () => vm.modificarSuplidorDefault(
                                  context, suplidor),
                              color: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: 70,
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      suplidor.descripcionEntidad,
                                      style: const TextStyle(
                                        color: AppColors.brownDark,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DropdownSearch<String>(
                                              selectedItem: vm.suplidores
                                                  .firstWhere((element) =>
                                                      element.codigoRelacionado
                                                          .toString() ==
                                                      suplidor.valor)
                                                  .nombre,
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Debe escojer un suplidor'
                                                  : null,
                                              dropdownDecoratorProps:
                                                  const DropDownDecoratorProps(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                                  hintText: "Segmento",
                                                  border:
                                                      UnderlineInputBorder(),
                                                ),
                                              ),
                                              popupProps: const PopupProps.menu(
                                                  fit: FlexFit.loose,
                                                  showSelectedItems: true,
                                                  searchDelay: Duration(
                                                      microseconds: 0)),
                                              items: vm.suplidores
                                                  .map((e) => e.nombre)
                                                  .toList(),
                                              onChanged: (value) {
                                                vm.suplidor = vm.suplidores
                                                    .firstWhere((element) =>
                                                        element.nombre ==
                                                        value);
                                              },
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              vm.modificarSuplidorDefault(
                                                  context,
                                                  suplidor), // button pressed
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const <Widget>[
                                              Icon(
                                                AppIcons.save,
                                                color: AppColors.green,
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ), // icon
                                              Text("Actualizar"), // text
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
                        }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
