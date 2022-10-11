part of porcentajes_honorarios_entidad_view;

class _PorcentajesHonorariosEntidadMobile extends StatelessWidget {
  final PorcentajesHonorariosEntidadViewModel vm;

  const _PorcentajesHonorariosEntidadMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.cargando,
      opacity: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: const Text(
            'Porcentajes Honorarios Entidad',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.brownLight,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () => vm.onRefresh(),
                child: vm.porcentajesHonorariosEntidad.isEmpty
                    ? const RefreshWidget()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: vm.porcentajesHonorariosEntidad.length + 1,
                        controller: vm.listController,
                        itemBuilder: (context, i) {
                          if (i >= vm.porcentajesHonorariosEntidad.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: !vm.hasNextPage
                                  ? const SizedBox()
                                  : const Center(
                                      child: CircularProgressIndicator()),
                            );
                          }
                          final GlobalKey<FormState> _formKey = GlobalKey();
                          var porcentajeHonorarioEntidad =
                              vm.porcentajesHonorariosEntidad[i];
                          TextEditingController controller =
                              TextEditingController();
                          controller.text = porcentajeHonorarioEntidad.valor;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: MaterialButton(
                              onPressed: () =>
                                  vm.modificarPorcentajeHonorarioEntidad(
                                      context,
                                      porcentajeHonorarioEntidad,
                                      controller.text),
                              color: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      height: 70,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        porcentajeHonorarioEntidad
                                            .descripcionEntidad,
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
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: controller,
                                              validator: (newValor) => int
                                                          .parse(newValor!) >
                                                      100
                                                  ? "El porcentaje no puede ser mayor a 100"
                                                  : null,
                                              decoration: const InputDecoration(
                                                border: UnderlineInputBorder(),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                vm.modificarPorcentajeHonorarioEntidad(
                                                    context,
                                                    porcentajeHonorarioEntidad,
                                                    controller.text);
                                              }
                                            }, // button pressed
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
