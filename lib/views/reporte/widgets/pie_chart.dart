import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart' as pie;

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Solicitados vs Valorados",
              style: TextStyle(fontSize: 15),
            ),
            Divider(),
            pie.PieChart(
              dataMap: const <String, double>{
                "Solicitados": 49,
                "Valorados": 51,
              },
            )
          ],
        ),
      ),
    );
  }
}
