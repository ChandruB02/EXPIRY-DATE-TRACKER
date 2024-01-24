import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:scannar_app_project/pie_chart/pie_chart_data.dart';

import '../components/drawer.dart';

class PIeChart extends StatelessWidget {
  const PIeChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Pie Chart'),
      ),
      //drawer: const DrawerScreen(),
      body: Card(

        child: Column(
          children: <Widget>[
            Expanded(
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 8,
                  centerSpaceRadius: 80,
                  sections: getSections(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Padding(padding: const EdgeInsets.all(16),
                  child: IndicatorsWidget(),
                  )
              ],
            )

          ],
        ),
      ),
    );
  }
}

class IndicatorsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: Piedata.data
        .map(
          (data) => Container(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: buildIndicator(
            color: data.color,
            text: data.name,
            isSquare: true,
          )),
    )
        .toList(),
  );

  Widget buildIndicator({
    required Color color,
    required String text,
    bool isSquare = false,
    double size = 16,
    Color textColor = const Color(0xff505050),
  }) =>
      Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      );
}
