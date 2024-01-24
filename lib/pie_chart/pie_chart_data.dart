import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<PieChartSectionData> getSections() => Piedata.data.asMap().map<int, PieChartSectionData>((index, data) {
  final value = PieChartSectionData(
    color: data.color,
    title: '${data.percent}%',
    value: data.percent,
    showTitle: true,
    titleStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black
    )
  );
  return MapEntry(index, value);

}).values.toList();

class Piedata {
  static List<Data> data = [
    Data(name: 'television', percent: 40, color: Colors.green),
    Data(name: 'fridge', percent: 30, color: Colors.red),
    Data(name: 'Laptop', percent: 15, color: Colors.purple),
    Data(name: 'computer', percent: 15, color: Colors.amberAccent),
  ];
}

class Data {
  final String name;
  final double percent;
  final Color color;

  Data({required this.name, required this.percent, required this.color});

}