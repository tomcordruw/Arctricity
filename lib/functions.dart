import 'main.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PriceData {
  double price;
  DateTime startDate;
  DateTime endDate;

  PriceData(
      {required this.price, required this.startDate, required this.endDate});
}

// Function for getting the latest documents, number of documents is given as argument
Future<List<DocumentSnapshot>> getLatestDocuments(int numDocuments) async {
  var querySnapshot = await firestoreInstance
      .collection('Data')
      .orderBy('timestamp', descending: true)
      .limit(numDocuments)
      .get();
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs;
  } else {
    throw Exception('No documents found');
  }
}

Future<dynamic> fetchApiData(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch API data');
  }
}

// parsing Timestamps to give DateTime
DateTime giveDateTime(String input) {
  int year = int.parse(input.substring(0, 4));
  int month = int.parse(input.substring(5, 7));
  int day = int.parse(input.substring(8, 10));
  int hour = int.parse(input.substring(11, 13));
  int minute = int.parse(input.substring(13, 15));
  DateTime dateTime = DateTime(year, month, day, hour, minute);
  return dateTime;
}

// Convert String fields in document to integers
int convertToInt(List<DocumentSnapshot> docs, int i, String field) {
  int error = 999;
  Map<String, dynamic> stringData = docs[i].data() as Map<String, dynamic>;
  String stringValue = stringData[field]; // Get string value from data
  int? intValue = int.tryParse(stringValue
      .trim()); // Remove spaces and parse as integer, with nullable int type
  if (intValue != null) {
    // If parsing is successful, use the integer value
    return intValue;
  } else {
    return error;
  }
}

// Get a string value from a specific document field
String getField(List<DocumentSnapshot> docs, int i, String field) {
  Map<String, dynamic> stringData = docs[i].data() as Map<String, dynamic>;
  String stringValue = stringData[field]; // Get string value from data
  if (stringValue != null) {
    return stringValue;
  } else {
    return "error";
  }
}

// Get a number from a specific document field
double getNumber(List<DocumentSnapshot> docs, int i, String field) {
  Map<String, dynamic> stringData = docs[i].data() as Map<String, dynamic>;
  double number = stringData[field]; // Get string value from data
  if (number != null) {
    return number;
  } else {
    return -666;
  }
}

// count how many documents a field has been " 1" from the latest
int countConsecutiveOnValues(List<DocumentSnapshot> documents, String field) {
  int count = 0;
  for (int i = 0; i < documents.length; i++) {
    Map<String, dynamic> data = documents[i].data() as Map<String, dynamic>;
    if (data[field] == "  1") {
      count++;
    } else {
      break;
    }
  }
  return count;
}

// Calculate the average difference per minute
double calculateRate(List<DocumentSnapshot> documents, int time,
    double temp_delta, String field) {
  double heating_rate = temp_delta / time;
  return heating_rate;
}

// Function for getting the latest documents, number of documents is given as argument
Future<List<DocumentSnapshot>> getHistorical(
    int numDocuments, String placeholder) async {
  String field = 'avgValues.$placeholder';
  var querySnapshot = await firestoreInstance
      .collection('data_history')
      .orderBy('timestamp', descending: true)
      .limit(numDocuments)
      .get();
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs;
  } else {
    throw Exception('No documents found');
  }
}

// Function for returning °C if the field contains "temp", or nothing
String getUnit(String key, dynamic value) {
  if (key.toLowerCase().contains('temp')) {
    return '°C';
  } else {
    return '';
  }
}

double getVPositionFromAHI(int ahi) {
  if (ahi == 100) {
    return 14;
  } else if (ahi >= 80 && ahi < 100) {
    return 20;
  } else if (ahi >= 60 && ahi <= 79) {
    return 45;
  } else if (ahi >= 40 && ahi <= 59) {
    return 73;
  } else if (ahi >= 20 && ahi <= 39) {
    return 96;
  } else if (ahi >= 0 && ahi <= 19) {
    return 115;
  } else {
    throw ArgumentError('Invalid AHI variable. Must be between 0 and 100.');
  }
}

Color getColorFromAHI(int ahi) {
  if (ahi == 100) {
    return Color.fromARGB(200, 200, 0, 0);
  } else if (ahi >= 80 && ahi <= 99) {
    return Color.fromARGB(255, 200, 0, 0);
  } else if (ahi >= 60 && ahi <= 79) {
    return Color.fromARGB(255, 200, 100, 0);
  } else if (ahi >= 40 && ahi <= 59) {
    return Color.fromARGB(255, 230, 220, 0);
  } else if (ahi >= 20 && ahi <= 39) {
    return Color.fromARGB(255, 150, 200, 0);
  } else if (ahi >= 0 && ahi <= 19) {
    return Color.fromARGB(255, 0, 200, 0);
  } else {
    throw ArgumentError('Invalid AHI variable. Must be between 0 and 100.');
  }
}

List<String> parseDateTimes(List<String> timeList) {
  List<String> parsedList = [];
  for (String time in timeList) {
    DateTime dateTime = DateTime.parse(time);
    String formattedTime = DateFormat('yyyy_MM_dd_HHmmss').format(dateTime);
    parsedList.add(formattedTime);
  }
  return parsedList;
}
