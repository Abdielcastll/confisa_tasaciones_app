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
                                vm.onDropDownChange(newValue, context);
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
                    Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.green,
                        ),
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ))),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.brownLight,
                        ),
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ))),
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
