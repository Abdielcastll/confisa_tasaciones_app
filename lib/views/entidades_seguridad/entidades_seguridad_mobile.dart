part of entidades_seguridad_view;

class _EntidadesSeguridadMobile extends StatelessWidget {
  final EntidadesSeguridadViewModel vm;

  const _EntidadesSeguridadMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: GlobalDrawerDartDesktop(),
      backgroundColor: Colors.white,
      appBar: const Appbar(titulo: "Configuración de Seguridad", textSize: 13),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.brownLight,
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                          width: size.width * .6,
                          height: 35,
                          child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              style: appDropdown,
                              borderRadius: BorderRadius.circular(10),
                              dropdownColor: AppColors.brownLight,
                              items: vm.items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                vm.dropdownvalue = newValue!;
                                vm.onDropDownChangeButtons(newValue, context);
                                vm.onDropDownChangeTable(newValue, context);
                              },
                              value: vm.dropdownvalue,

                              // Down Arrow Icon
                              icon: const Icon(
                                Icons.arrow_drop_down_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ))),
                    ),
                    Expanded(child: Container()),
                    Row(
                      children: [
                        vm.button1,
                        const SizedBox(
                          width: 5,
                        ),
                        vm.button2
                      ],
                    ),
                  ],
                ),
              ),
              vm.dataTable
            ],
          ),
        ),
      ),
    );
  }
}
