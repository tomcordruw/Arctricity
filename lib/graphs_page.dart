import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'functions.dart';
import 'data/data_point.dart';
import 'line_chart_widget.dart';

class GraphsPage extends StatefulWidget {
  @override
  _GraphsPageState createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  String selectedPlaceholder = 'temp_out'; // Initial selected placeholder
  int numDocuments = 100; // Number of documents to fetch
  List<DocumentSnapshot> historicalData = [];

  // Widget build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphs'),
      ),
      body: ListView(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 44),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(
                  value: selectedPlaceholder,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPlaceholder = newValue!;
                    });
                  },
                  items: [
                    'temp_out', // Replace with your actual placeholder values
                    'temp_hotwater',
                    'temp_watertank_lower',
                    'temp_watertank_upper',
                    'total_consumption',
                    'temp_HPcondensation',
                    'temp_HPgas_hot',
                    'temp_HPgas_suction',
                    'temp_floofheating_out',
                    'temp_floorheating_OUT_target',
                    'temp_floorheating_in',
                    'temp_groundwater_in',
                    'temp_groundwater_out',
                    'temp_in_not_connected',
                    // Add more placeholders as needed
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              )),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: getHistorical(numDocuments, selectedPlaceholder),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  historicalData = snapshot.data!;
                  List<String> timeStampList = [];
                  List<double> valueList = [];

                  // Calculate electricity usage from the past day
                  DateTime targetTime =
                      DateTime.now().subtract(Duration(hours: 24));
                  int closestIndex = -1;
                  Duration closestDuration = Duration(days: 365);
                  String firstTimestamp = historicalData[0]['timestamp'];

                  // Go through all the documents to save the data to a list
                  // Find the document from ~24 hours ago
                  for (DocumentSnapshot document in historicalData) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String timestamp = data['timestamp'];
                    // Iterate through the timestamps and find the closest one
                    DateTime dateTimestamp =
                        giveDateTime(timestamp); // Parse the timestamp
                    Duration duration = dateTimestamp
                        .difference(targetTime)
                        .abs(); // Calculate time difference
                    if (duration < closestDuration) {
                      closestDuration = duration;
                      closestIndex = historicalData.indexOf(document);
                    }

                    timeStampList.add(timestamp);

                    double avgValue =
                        data['avgValues'][selectedPlaceholder].toDouble();
                    // Change the Watthours to kWh
                    if (selectedPlaceholder == "total_consumption") {
                      double kWh = avgValue / 1000;
                      avgValue = double.parse(kWh.toStringAsFixed(2));
                    }
                    valueList.add(avgValue);
                  }
                  double consToday = historicalData[0]['avgValues']
                          ['total_consumption']
                      .toDouble();
                  double consPastDay = historicalData[closestIndex]['avgValues']
                          ['total_consumption']
                      .toDouble();
                  double kWhDiff = (consToday - consPastDay) / 1000;

                  // Reverse the list of data points,r
                  // so the data goes from left to right
                  List<double> valueListR = valueList.reversed.toList();
                  List<String> timeListR = timeStampList.reversed.toList();
                  List<DataPoint> dataPoints =
                      mergeLists(timeStampList, valueListR);
                  String unit = "";
                  if (selectedPlaceholder.contains("temp")) {
                    unit = "°C";
                  } else if (selectedPlaceholder
                      .contains("total_consumption")) {
                    unit = "kWh";
                  }
                  // The next ~10 lines of code are for testing the list output
                  /*String getAllDataPointsAsString(List<DataPoint> dataPoints) {
                    String result = '';
                    for (DataPoint dataPoint in dataPoints) {
                      String dataPointString =
                          'x: ${dataPoint.x}, y: ${dataPoint.y}\n';
                      result += dataPointString;
                    }
                    return result;
                  }

                  String allData = getAllDataPointsAsString(dataPoints);*/

                  return Container(
                    // Graph is being created from line_chart_widget.dart
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        LineChartWidget(dataPoints, timeListR, unit),
                        const Padding(padding: EdgeInsets.all(60)),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text("Unknown error"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
