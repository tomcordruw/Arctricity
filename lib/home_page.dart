import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'functions.dart';
import 'graphs_page.dart';
import 'data_page.dart';
import 'about_page.dart';
import 'hp_data_processing.dart';
import 'data/data_point.dart';
import 'GraphWidgets.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class HomePage extends StatelessWidget {
  final int selectedContainerIndex;
  final ValueChanged<int> onContainerSelected;

  const HomePage(
      {Key? key,
      required this.selectedContainerIndex,
      required this.onContainerSelected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Get the current DateTime for displaying
    DateTime now = DateTime.now();
    String Date = DateFormat('dd. MMMM yyyy').format(now);
    String selectedPlaceholder = ''; // Initial selected placeholder
    int numDocuments = 100; // Number of documents to fetch
    List<DocumentSnapshot> historicalData = [];
    double electricityCost = 0.070;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "./assets/background.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Only for smartphones because of potential notches (part 1)
          /*Positioned(
            child: Container(
              height: 42,
              color: Color.fromARGB(255, 3, 46, 48),
            ),
          ),*/
          Column(children: [
            // Only for smartphones because of potential notches (part 2)
            /*SizedBox(
              height: 42,
            ),*/
            Stack(
              children: [
                ClipRect(
                    child: BackdropFilter(
                        filter: ui.ImageFilter.blur(
                            sigmaX: 1, sigmaY: 1), // Specify blur amount
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 56, bottom: 20, left: 235, right: 30),
                          color: Color.fromARGB(255, 3, 46, 48),
                          /*decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color.fromARGB(121, 24, 124, 116),
                                Color.fromARGB(0, 255, 255, 255)
                              ],
                              tileMode: TileMode
                                  .mirror, // Use TileMode to specify how the gradient should be repeated or mirrored
                            ),
                          ),*/
                        ))),
                /*   BackdropFilter(
                    filter: ui.ImageFilter.blur(
                        sigmaX: 0.7, sigmaY: 0.7), // Specify blur amount
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 56, bottom: 20, left: 235, right: 30),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color.fromARGB(121, 24, 124, 116),
                            Color.fromARGB(0, 255, 255, 255)
                          ],
                          tileMode: TileMode
                              .mirror, // Use TileMode to specify how the gradient should be repeated or mirrored
                        ),
                      ),
                    )),*/
                // Buttons are here
                Row(children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 85, 85, 85),
                          Color.fromARGB(255, 57, 104, 100),
                        ],
                        tileMode: TileMode
                            .mirror, // Use TileMode to specify how the gradient should be repeated or mirrored
                      ),
                      border: Border.all(
                        color: Color.fromARGB(255, 40, 73, 70),
                        width: 2,
                      ),
                      color: Color.fromARGB(255, 59, 59, 59),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.show_chart),
                      tooltip: 'Graphs',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GraphsPage()),
                        );
                      },
                      iconSize: 36.0,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 85, 85, 85),
                          Color.fromARGB(255, 57, 104, 100),
                        ],
                        tileMode: TileMode
                            .mirror, // Use TileMode to specify how the gradient should be repeated or mirrored
                      ),
                      border: Border.all(
                        color: Color.fromARGB(255, 40, 73, 70),
                        width: 2,
                      ),
                      color: Color.fromARGB(255, 59, 59, 59),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.info_outline),
                      tooltip: 'Info',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutPage()),
                        );
                      },
                      iconSize: 36.0,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 85, 85, 85),
                          Color.fromARGB(255, 57, 104, 100),
                        ],
                        tileMode: TileMode
                            .mirror, // Use TileMode to specify how the gradient should be repeated or mirrored
                      ),
                      border: Border.all(
                        color: Color.fromARGB(255, 40, 73, 70),
                        width: 2,
                      ),
                      color: Color.fromARGB(255, 59, 59, 59),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.account_tree_outlined),
                      tooltip: 'Data',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DataPage()),
                        );
                      },
                      iconSize: 36.0,
                    ),
                  ),
                  Container(
                      width: 150,
                      height: 30,
                      padding: EdgeInsets.only(left: 10),
                      child: Image.asset(
                        "./assets/arctricity.png",
                        fit: BoxFit.fill,
                      )),
                ]),
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                children: [
                  Column(children: [
                    Container(
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 20)),

                          // Container 1
                          Visibility(
                            visible: selectedContainerIndex == 0,
                            child: Container(
                              child: FutureBuilder(
                                future: Future.wait([
                                  getLatestDocuments(21),
                                  getHistorical(
                                      numDocuments, selectedPlaceholder),
                                  fetchApiData(
                                      'https://api.porssisahko.net/v1/latest-prices.json'),
                                  fetchApiData(
                                      'https://api.open-meteo.com/v1/forecast?latitude=66.48&longitude=25.72&hourly=temperature_2m&forecast_days=3&timezone=auto')
                                ]),
                                builder: (context, snapshot) {
                                  // Empty Lists for storing temperature API data
                                  List<String> timeList = [];
                                  List<double> tempList = [];
                                  if (snapshot.hasData) {
                                    var docs = snapshot.data!;
                                    double currentPrice = 5.0;
                                    if (docs.isNotEmpty) {
                                      List<dynamic> pricesList =
                                          docs[2]["prices"];
                                      DateTime currentTime = DateTime.now();
                                      // Iterate through the prices list and find the current price
                                      PriceData? currentHour;
                                      for (var priceObj in pricesList) {
                                        double price =
                                            priceObj['price'].toDouble();
                                        DateTime startDate = DateTime.parse(
                                            priceObj['startDate']);
                                        DateTime endDate =
                                            DateTime.parse(priceObj['endDate']);

                                        if (currentTime.isAfter(startDate) &&
                                            currentTime.isBefore(endDate)) {
                                          currentHour = PriceData(
                                              price: price,
                                              startDate: startDate,
                                              endDate: endDate);
                                          break;
                                        }
                                      }
                                      // Return the current hourly price
                                      if (currentHour != null) {
                                        currentPrice =
                                            currentHour.price.toDouble();
                                      }

                                      var processedData =
                                          processData(docs[0], currentPrice);
                                      historicalData = docs[1];
                                      String waterTankStatus = "changing";
                                      Color waterTankColour =
                                          Color.fromARGB(255, 255, 255, 255);
                                      // Process the data from the last 11 documents and get
                                      // the data variables
                                      var outsideTemp =
                                          processedData['outsideTemp'];
                                      var tankTemp = processedData['tankTemp'];
                                      var compressorInfo =
                                          processedData['compressorInfo'];
                                      var ahiValue = processedData['ahiValue'];
                                      var heatingRate =
                                          processedData['heatingRate'];
                                      var advice = processedData['advice'];
                                      var advice2 = processedData['advice2'];
                                      Color triangleColor =
                                          getColorFromAHI(ahiValue);
                                      double vPosition =
                                          getVPositionFromAHI(ahiValue)
                                              .toDouble();
                                      if (heatingRate < 0) {
                                        waterTankStatus = "cooling: ";
                                        waterTankColour = Colors.blue;
                                      } else if (heatingRate == 0) {
                                        waterTankStatus = "constant: ";
                                        waterTankColour = Colors.green;
                                      } else {
                                        waterTankStatus = "heating: ";
                                        waterTankColour = Colors.red;
                                      }
                                      // Calculate electricity usage from the past day
                                      DateTime targetTime = DateTime.now()
                                          .subtract(Duration(hours: 24));
                                      int closestIndex = -1;
                                      Duration closestDuration =
                                          Duration(days: 365);
                                      // Go through all the documents to save the data to a list
                                      // Find the document from ~24 hours ago
                                      for (DocumentSnapshot document
                                          in historicalData) {
                                        Map<String, dynamic> data = document
                                            .data() as Map<String, dynamic>;
                                        String timestamp = data['timestamp'];
                                        // Iterate through the timestamps and find the closest one
                                        DateTime dateTimestamp = giveDateTime(
                                            timestamp); // Parse the timestamp
                                        Duration duration = dateTimestamp
                                            .difference(targetTime)
                                            .abs(); // Calculate time difference
                                        if (duration < closestDuration) {
                                          closestDuration = duration;
                                          closestIndex =
                                              historicalData.indexOf(document);
                                        }
                                      }
                                      double consToday = historicalData[0]
                                              ['avgValues']['total_consumption']
                                          .toDouble();
                                      double consPastDay =
                                          historicalData[closestIndex]
                                                      ['avgValues']
                                                  ['total_consumption']
                                              .toDouble();
                                      double kWhDiff =
                                          (consToday - consPastDay) / 1000;

                                      // 24 hour-minimum temperature calculation
                                      timeList = docs[3]["hourly"]["time"]
                                          .cast<String>()
                                          .toList();
                                      tempList = docs[3]["hourly"]
                                              ["temperature_2m"]
                                          .cast<double>()
                                          .toList();

                                      // Initialise minTemp, j (counts to 24 from current time)
                                      // minIndex to store the index of the lowest temperature
                                      double minTemp = double.infinity;
                                      int j = 0;
                                      int minIndex = -1;
                                      // Find the minimum temperature during the night
                                      for (int i = 0;
                                          i < tempList.length && j < 24;
                                          i++) {
                                        DateTime time =
                                            DateTime.parse(timeList[i]);
                                        if (time.isAfter(DateTime.now())) {
                                          if (tempList[i] < minTemp) {
                                            minTemp = tempList[i];
                                            minIndex = i;
                                          }
                                          j++;
                                        }
                                      }
                                      DateTime dateTime =
                                          DateTime.parse(timeList[minIndex]);
                                      String time =
                                          DateFormat('h:mm a').format(dateTime);
                                      return Column(children: [
                                        // Textbox for AHI and most important info
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Container(
                                                  width: 480,
                                                  height: 350,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        46, 11, 114, 133),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                                131, 87, 87, 87)
                                                            .withOpacity(0.5),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 20,
                                                          top: 10,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Positioned(
                                                              left: 0,
                                                              child: Text(
                                                                "$Date\n",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        24),
                                                              ),
                                                            ),
                                                            Text(
                                                              "AHI: ${ahiValue.toStringAsFixed(0)}",
                                                              style: TextStyle(
                                                                  fontSize: 56,
                                                                  color:
                                                                      triangleColor),
                                                            ),
                                                            SizedBox(
                                                                height: 42),
                                                            Text(
                                                              "Current electricity price:\t\t\t\t\t\t\t\t\t\t\t\t\t\t${currentPrice.toStringAsFixed(3)} cnt/kWh"
                                                              "\nMin. temperature (next 24 h):     ${tempList[minIndex]}°C at ${time}"
                                                              "\n\n$advice\n$advice2",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                left: 300),
                                                        child: Stack(
                                                          children: [
                                                            // Indicator bar
                                                            Positioned(
                                                              left: 11,
                                                              top: 19,
                                                              child:
                                                                  Image.asset(
                                                                "./assets/indicator.png",
                                                                height: 138,
                                                                width: 50,
                                                              ),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(25),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      const LinearGradient(
                                                                    begin: Alignment
                                                                        .centerLeft,
                                                                    end: Alignment
                                                                        .bottomRight,

                                                                    colors: [
                                                                      Color.fromARGB(
                                                                          126,
                                                                          85,
                                                                          85,
                                                                          85),
                                                                      Color.fromARGB(
                                                                          164,
                                                                          241,
                                                                          240,
                                                                          240),
                                                                    ],
                                                                    tileMode:
                                                                        TileMode
                                                                            .mirror, // Use TileMode to specify how the gradient should be repeated or mirrored
                                                                  ),
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.elliptical(
                                                                              16,
                                                                              20)),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1.5,
                                                                  ),
                                                                ),
                                                                width: 22,
                                                                height: 126,
                                                              ),
                                                            ),
                                                            // Arrow indicator
                                                            Positioned(
                                                              right: 43,
                                                              top:
                                                                  vPosition, // move triangle along the bar based on AHI
                                                              child: Container(
                                                                  child: Text(
                                                                "⫸",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      triangleColor, // change triangle color based on AHI
                                                                  shadows: const [
                                                                    Shadow(
                                                                      color: Colors
                                                                          .black,
                                                                      offset: Offset(
                                                                          2.0,
                                                                          2.0),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))),

                                        // Textbox that gives detailed info
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                top: 15,
                                                left: 10,
                                                bottom: 16,
                                                right: 10,
                                              ), // Add padding to the bottom of the container
                                              child: Container(
                                                width: 480,
                                                height: 260,
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      78, 156, 156, 156),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                              131, 87, 87, 87)
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      top: 16,
                                                      left: 16,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255,
                                                              161,
                                                              161,
                                                              161), // Background color of the container
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                            color: Color.fromARGB(
                                                                255,
                                                                56,
                                                                56,
                                                                56), // Border color
                                                            width:
                                                                3, // Border width
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          Icons.info_outline,
                                                          color: Color.fromARGB(
                                                              255, 56, 56, 56),
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 56,
                                                          top: 16,
                                                          bottom: 16,
                                                          right: 16),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Detailed Info',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      "\nOutside temperature: ${outsideTemp / 10}°C\nWater tank temperature: ${tankTemp / 10}°C"
                                                                      "\nWater tank is $waterTankStatus ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w100,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      "${heatingRate.toStringAsFixed(2)}°C",
                                                                  style: TextStyle(
                                                                      color:
                                                                          waterTankColour,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      " / 10 min\n\n$compressorInfo "
                                                                      "\n\nElectricity consumption (past 24h): \n${kWhDiff.toStringAsFixed(2)} kWh"
                                                                      " (~${(kWhDiff * electricityCost).toStringAsFixed(2)} €)",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w100,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        )
                                      ]); // Stack
                                    } else {
                                      return Text('No documents found');
                                    }
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container 2
                    Visibility(
                        visible: selectedContainerIndex == 1,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Container(
                                    child:
                                        // Call Weather API and create weather graph
                                        FutureBuilder<dynamic>(
                                      future: fetchApiData(
                                          'https://api.open-meteo.com/v1/forecast?latitude=66.48&longitude=25.72&hourly=temperature_2m&forecast_days=3&timezone=auto'),
                                      builder: (context, snapshot) {
                                        List<String> timeList = [];
                                        List<double> tempList = [];
                                        if (snapshot.hasData) {
                                          // The lists are dynamic, so they are casted to their
                                          // respective formats
                                          timeList = snapshot.data["hourly"]
                                                  ["time"]
                                              .cast<String>()
                                              .toList();
                                          tempList = snapshot.data["hourly"]
                                                  ["temperature_2m"]
                                              .cast<double>()
                                              .toList();
                                          timeList = parseDateTimes(timeList);
                                          List<DataPoint> dataPoints =
                                              mergeLists(timeList, tempList);
                                          var weatherGraph = Container(
                                              padding: EdgeInsets.only(
                                                  top: 20, right: 30),
                                              width: 480,
                                              height: 220,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 40, 73, 70),
                                                  width: 1.5,
                                                ),
                                                color: Color.fromARGB(
                                                    46, 11, 114, 133),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color.fromARGB(
                                                            131, 0, 0, 0)
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Column(children: [
                                                Text(
                                                  '3-day Temperature Forecast',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                WeatherWidget(
                                                    dataPoints, timeList)
                                              ]));
                                          return weatherGraph;
                                        }
                                        return CircularProgressIndicator();
                                      },
                                    ),
                                  )),
                              const SizedBox(height: 30),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  padding: EdgeInsets.only(top: 10),
                                  width: 480,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 40, 73, 70),
                                      width: 1.5,
                                    ),
                                    color: Color.fromARGB(46, 11, 114, 133),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(131, 0, 0, 0)
                                            .withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child:
                                      // Get electricity data and create electricity graph
                                      FutureBuilder<dynamic>(
                                    future: fetchApiData(
                                        'https://api.porssisahko.net/v1/latest-prices.json'),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<dynamic> pricesList =
                                            snapshot.data["prices"];
                                        List<String> startDateList = pricesList
                                            .map((item) =>
                                                item['startDate'].toString())
                                            .toList();
                                        List<double> priceList = pricesList
                                            .map((item) =>
                                                item['price'] as double)
                                            .toList();
                                        // reverse the lists with the data so that the graph goes from left to right
                                        startDateList =
                                            startDateList.reversed.toList();
                                        priceList = priceList.reversed.toList();
                                        startDateList =
                                            parseDateTimes(startDateList);
                                        List<DataPoint> priceData = mergeLists(
                                            startDateList, priceList);

                                        var priceGraph = Container(
                                            padding: EdgeInsets.only(
                                                right: 30, top: 10),
                                            child: Column(children: [
                                              Text(
                                                'Electricity Price (cnt/kWh)',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              PriceWidget(
                                                  priceData, startDateList)
                                            ]));
                                        return priceGraph;
                                      }
                                      return CircularProgressIndicator();
                                    },
                                  ),
                                ),
                              )
                            ]))),
                  ]),
                ],
              ),
            )),
          ]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 3, 46, 48),
        currentIndex: selectedContainerIndex,
        onTap: onContainerSelected,
        iconSize: 42,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny_snowing),
            label: 'Forecasts',
          ),
        ],
      ),
    );
  }
}
