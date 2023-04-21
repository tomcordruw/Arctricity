import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'data/data_point.dart';
import 'functions.dart';

class WeatherWidget extends StatelessWidget {
  final List<DataPoint> points;
  final List<String> timeStampList;

  const WeatherWidget(this.points, this.timeStampList, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
              enabled: true,
              touchCallback:
                  (FlTouchEvent event, LineTouchResponse? touchResponse) {},
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.blue,
                tooltipRoundedRadius: 20.0,
                showOnTopOfTheChartBoxArea: true,
                fitInsideHorizontally: true,
                tooltipMargin: 5,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map(
                    (LineBarSpot touchedSpot) {
                      const textStyle = TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      );
                      DateTime dateTime =
                          giveDateTime(timeStampList[touchedSpot.spotIndex]);
                      String time =
                          DateFormat('dd. MMM HH:mm').format(dateTime);
                      return LineTooltipItem(
                        "${time}\n${(points[touchedSpot.spotIndex].y).toStringAsFixed(1)}°C",
                        textStyle,
                      );
                    },
                  ).toList();
                },
              ),
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> indicators) {
                return indicators.map(
                  (int index) {
                    final line = FlLine(
                        color: Colors.black, strokeWidth: 2, dashArray: [4, 4]);
                    return TouchedSpotIndicatorData(
                      line,
                      FlDotData(show: false),
                    );
                  },
                ).toList();
              },
              getTouchLineEnd: (_, __) => double.infinity),
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              barWidth: 4,
              isCurved: true,
              color: Color.fromARGB(255, 255, 51, 0),
              dotData: FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: Colors.blue,
                    strokeWidth: 1,
                    strokeColor: Colors.black,
                  );
                },
                show: false,
              ),
            ),
          ],
          borderData: FlBorderData(
              border: const Border(bottom: BorderSide(), left: BorderSide())),
          // define where the top and bottom of the Y-axis are
          minY: (points
                      .reduce((value, element) =>
                          value.y < element.y ? value : element)
                      .y -
                  2)
              .roundToDouble(),
          maxY: (points
                      .reduce((value, element) =>
                          value.y > element.y ? value : element)
                      .y +
                  2)
              .roundToDouble(),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 4.4,
            verticalInterval: 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: Colors.black, strokeWidth: 1);
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Color.fromARGB(255, 0, 0, 0),
                strokeWidth: 1,
              );
            },
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        interval: 25,
        reservedSize: 35,
        getTitlesWidget: (value, meta) {
          String input = '';
          int steps = value.toInt();
          input = timeStampList[steps];
          const style = TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 12,
          );
          // Parse the timestamp
          int year = int.parse(input.substring(0, 4));
          int month = int.parse(input.substring(5, 7));
          int day = int.parse(input.substring(8, 10));
          int hour = int.parse(input.substring(11, 13));
          int minute = int.parse(input.substring(13, 15));
          DateTime dateTime = DateTime(year, month, day, hour, minute);
          String title = DateFormat('dd MMM.\n HH:mm').format(dateTime);
          return SideTitleWidget(
            axisSide: meta.axisSide,
            angle: 0,
            child: Text(title, style: style),
          );
        },
      );
}

class PriceWidget extends StatelessWidget {
  final List<DataPoint> points;
  final List<String> timeStampList;

  const PriceWidget(this.points, this.timeStampList, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
              enabled: true,
              touchCallback:
                  (FlTouchEvent event, LineTouchResponse? touchResponse) {},
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Color.fromARGB(255, 114, 114, 114),
                tooltipRoundedRadius: 20.0,
                showOnTopOfTheChartBoxArea: true,
                fitInsideHorizontally: true,
                tooltipMargin: 5,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map(
                    (LineBarSpot touchedSpot) {
                      const textStyle = TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      );
                      DateTime dateTime =
                          giveDateTime(timeStampList[touchedSpot.spotIndex])
                              .add(const Duration(hours: 3));
                      String time =
                          DateFormat('dd. MMM HH:mm').format(dateTime);
                      return LineTooltipItem(
                        "${(points[touchedSpot.spotIndex].y).toStringAsFixed(2)} cnt/kWh\n${time}",
                        textStyle,
                      );
                    },
                  ).toList();
                },
              ),
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> indicators) {
                return indicators.map(
                  (int index) {
                    final line = FlLine(
                        color: Color.fromARGB(255, 0, 0, 0),
                        strokeWidth: 2,
                        dashArray: [4, 4]);
                    return TouchedSpotIndicatorData(
                      line,
                      FlDotData(show: false),
                    );
                  },
                ).toList();
              },
              getTouchLineEnd: (_, __) => double.infinity),
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              barWidth: 3,
              isCurved: false,
              color: Color.fromARGB(255, 0, 0, 0),
              dotData: FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotSquarePainter(
                    size: 4,
                    color: Color.fromARGB(255, 141, 141, 141),
                    strokeWidth: 1,
                    strokeColor: Color.fromARGB(255, 95, 95, 95),
                  );
                },
                show: false,
              ),
            ),
          ],
          borderData: FlBorderData(
              border: const Border(bottom: BorderSide(), left: BorderSide())),
          minY: 0,
          maxY: points
                  .reduce(
                      (value, element) => value.y > element.y ? value : element)
                  .y +
              2,
          gridData: FlGridData(
              show: true,
              horizontalInterval: 2,
              verticalInterval: 5,
              getDrawingVerticalLine: (value) {
                return FlLine(
                  strokeWidth: 0,
                );
              }),
          backgroundColor: Color.fromARGB(255, 216, 166, 0),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        interval: 25,
        reservedSize: 35,
        getTitlesWidget: (value, meta) {
          String input = '';
          int steps = value.toInt();
          input = timeStampList[steps];
          const style = TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 12,
          );
          DateTime dateTime = giveDateTime(input).add(const Duration(hours: 3));
          String title = DateFormat('dd-MMM\nHH:mm').format(dateTime);
          return SideTitleWidget(
            axisSide: meta.axisSide,
            angle: 0,
            child: Text(title, style: style),
          );
        },
      );
}
