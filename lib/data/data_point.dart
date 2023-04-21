import 'dart:math';
import 'package:collection/collection.dart';

class DataPoint {
  double x;
  double y;

  DataPoint({required this.x, required this.y});
}

List<DataPoint> mergeLists(List<String> timestamps, List<double> values) {
  List<DataPoint> dataPoints = [];
  for (int i = 0; i < timestamps.length; i++) {
    DataPoint dataPoint = DataPoint(x: i.toDouble(), y: values[i]);
    dataPoints.add(dataPoint);
  }
  return dataPoints;
}
