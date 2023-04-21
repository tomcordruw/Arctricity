// create Widget
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'functions.dart';

class DataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time sensor data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: SingleChildScrollView(
              // get the latest document from the database
              scrollDirection: Axis.vertical,
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: getLatestDocuments(1),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var docs = snapshot.data!;
                    if (docs.isNotEmpty) {
                      var doc = docs.first;
                      if (doc.exists) {
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;
                        final keys = data.keys.toList();

                        // Move the row with the time information to the top
                        keys.remove('time');
                        keys.sort();
                        keys.insert(0, 'time');

                        // Return all the data in a datatable
                        return DataTable(
                          dataRowHeight: 50, // set the height of rows
                          columnSpacing: 60, // set the spacing between columns
                          columns: const [
                            DataColumn(label: Text('Description')),
                            DataColumn(label: Text('Value')),
                          ],
                          rows:
                              List<DataRow>.generate(keys.length - 1, (index) {
                            final key = keys[index];
                            var value =
                                double.tryParse(data[key].replaceAll(' ', ''))
                                        ?.toString() ??
                                    data[key];
                            var unit = getUnit(key, value);
                            if (unit == "" &&
                                (value == "0.0" || value == "1.0")) {
                              value = value == "0.0" ? "off" : "on";
                            } else if (unit == "°C") {
                              value = double.parse(value) / 10;
                            }
                            return DataRow(
                              cells: [
                                DataCell(Text(key)),
                                DataCell(
                                  Text(
                                    "${value.toString()} $unit",
                                  ),
                                ),
                              ],
                            );
                          }),
                        );
                      } else {
                        return const Text('Latest document does not exist');
                      }
                    } else {
                      return const Text('No documents found');
                    }
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
