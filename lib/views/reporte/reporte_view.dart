import 'package:confisa_tasaciones_app/constants.dart';
import 'package:confisa_tasaciones_app/widgets/appbar_example.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ReporteView extends StatelessWidget {
  static const routeName = 'reporte';
  const ReporteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const AppbarExample(
        titulo: "Reporte",
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: size.height * .1,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Mes Actual",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: size.width * 0.12,
                            decoration: const BoxDecoration(color: Colors.grey),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Mes Pasado",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: size.width * 0.12,
                            decoration: const BoxDecoration(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.5,
                children: List.generate(6, (index) {
                  int rand = Random().nextInt(100);
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      alignment: AlignmentDirectional.bottomStart,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            rand.toString() + "%",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Ejemplo Tipo",
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          LinearProgressIndicator(
                              minHeight: 7,
                              value: rand / 100,
                              color: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)]),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
