import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'data/data_point.dart';
import 'functions.dart';

String lastDisplayedDate = "32";

class LineChartWidget extends StatelessWidget {
  final List<DataPoint> points;
  final List<String> timeStampList;
  final String unit;

  const LineChartWidget(this.points, this.timeStampList, this.unit, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the minimum and maximum values of the y-axis
    final minValue = points
        .reduce((value, element) => value.y < element.y ? value : element)
        .y;
    final maxValue = points
        .reduce((value, element) => value.y > element.y ? value : element)
        .y;

    return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.95,
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
                            giveDateTime(timeStampList[touchedSpot.spotIndex]);
                        String time =
                            DateFormat('dd MMM.HH:mm').format(dateTime);
                        return LineTooltipItem(
                          "${(points[touchedSpot.spotIndex].y).toString()} $unit \n${time}",
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
                          color: Colors.black,
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
                isCurved: false,
                barWidth: 5,
                color: Color.fromARGB(255, 184, 119, 0),
                dotData: FlDotData(
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 3,
                      color: Color.fromARGB(255, 160, 104, 0),
                      strokeWidth: 2,
                      strokeColor: Color.fromARGB(255, 68, 68, 68),
                    );
                  },
                  show: true,
                ),
              ),
            ],
            borderData: FlBorderData(
                border: const Border(bottom: BorderSide(), left: BorderSide())),
            minY: minValue - (maxValue - minValue) * 0.2,
            maxY: (maxValue - minValue) * 0.2 + maxValue,
            gridData: FlGridData(
              show: true,
              horizontalInterval: 2,
              verticalInterval: 8.5,
              drawHorizontalLine: true,
              drawVerticalLine: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Color.fromARGB(255, 100, 100, 100),
                  strokeWidth: 1,
                  dashArray: [8, 4],
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Color.fromARGB(255, 43, 43, 43),
                  strokeWidth: 1,
                  dashArray: [8, 4],
                );
              },
            ),
            backgroundColor: Color.fromARGB(255, 131, 150, 161),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: _bottomTitles),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: _leftTitles),
            ),
          ),
        ));
  }

  SideTitles get _bottomTitles => SideTitles(
      showTitles: true,
      interval: 17,
      reservedSize: 50,
      getTitlesWidget: (value, meta) {
        String title = '';
        int steps = value.toInt();
        String input = timeStampList[steps];
        DateTime dateTime = giveDateTime(input);
        if (lastDisplayedDate != DateFormat('dd').format(dateTime)) {
          // Display date only if it's a different day from last displayed date
          title = DateFormat(' HH:00\ndd MMM.').format(dateTime);
          lastDisplayedDate = DateFormat('dd').format(dateTime);
        } else {
          // Display time only
          title = DateFormat('HH:00').format(dateTime);
        }
        if (value == (timeStampList.length)) {
          title = '';
        }
        return Padding(
          padding: EdgeInsets.only(top: 8.0), // Add desired padding here
          child: Text(title),
        );
      });
  SideTitles get _leftTitles => SideTitles(
        showTitles: true,
        reservedSize: 55,
        getTitlesWidget: (value, meta) {
          String title = value.toString();
          if (title == meta.max.toString() || title == meta.min.toString()) {
            title = "";
          } else {
            title = value.toStringAsFixed(1);
          }
          return SideTitleWidget(
            axisSide: meta.axisSide,
            angle: 0,
            child: Text(title),
          );
        },
      );
}
