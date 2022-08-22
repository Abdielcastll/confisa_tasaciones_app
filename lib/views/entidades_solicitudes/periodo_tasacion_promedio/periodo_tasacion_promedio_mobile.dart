part of periodo_tasacion_promedio_view;

class _PeriodoTasacionPromedioMobile extends StatelessWidget {
  final PeriodoTasacionPromedioViewModel vm;

  const _PeriodoTasacionPromedioMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.cargando,
      opacity: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: const Text(
            'Períodos Tasación Promedio',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
                child: vm.periodoTasacionPromedio.isEmpty
                    ? const RefreshWidget()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: vm.periodoTasacionPromedio.length + 1,
                        controller: vm.listController,
                        itemBuilder: (context, i) {
                          if (i >= vm.periodoTasacionPromedio.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: !vm.hasNextPage
                                  ? const SizedBox()
                                  : const Center(
                                      child: CircularProgressIndicator()),
                            );
                          }
                          var periodoTasacionPromedio =
                              vm.periodoTasacionPromedio[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: MaterialButton(
                              onPressed: () =>
                                  vm.modificarPeriodoTasacionPromedio(
                                      context, periodoTasacionPromedio),
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
                                            periodoTasacionPromedio.description,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppColors.brownDark,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
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
        ),
      ),
    );
  }
}
