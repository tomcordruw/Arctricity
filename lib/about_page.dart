// create Widget
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'functions.dart';
import 'data/data_point.dart';
import 'GraphWidgets.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 36, 60, 66),
        appBar: AppBar(
          title: Text('About'),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(26),
                  child: Column(children: [
                    const Text(
                      "\n\nHeat pump system visualisation",
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Color.fromARGB(255, 222, 222, 222),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Image.asset(
                          './assets/hp_system.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: 64),
                    Container(
                      child: Text(
                        'Explanation',
                        style: TextStyle(
                            fontSize: 28,
                            color: Color.fromARGB(255, 222, 222, 222)),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            color: Color.fromARGB(160, 116, 116, 116),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            "\nData:\n\nHP_compressor_on_off:\tGives the current status of the heat pump's compressor, while it is on the system is heating"
                            "\n\nAHI:\t(Auxiliary Heat Index) - An estimate for whether the heat pump can is able to heat enough by itself"
                            "\n 100 is the worst case scenario and 0 the best case scenario"
                            "\n\nHP_compressor_on_off:\tGives the current status of the heat pump's compressor, while it is on the system is heating"
                            "\n\nalarms 0-8:\tGives the current status of the heat pump's compressor, while it is on the system is heating"
                            "\n\ntemp_HP_high_limit:\tThe temperature of the water tank at which the compressor turns off"
                            "\n\ntemp_HP_low_limit:\tThe temperature of the water tank at which the compressor turns on"
                            "\n\ntemp_out:\tOutside temperature"
                            "\n\nelectricheater:\tetc.",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 64),
                    Container(
                      child: Text(
                        'Our Team',
                        style: TextStyle(
                            fontSize: 28,
                            color: Color.fromARGB(255, 222, 222, 222)),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            './assets/arctricity_logo.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          width: 700,
                          height: 500,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            color: Color.fromARGB(160, 116, 116,
                                116), // Set background color, first value determines transparency
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            "\nTuomas Pasanen\nHouda Banyny\nJanne Vänskä\nTom Cordruwisch"
                            "\n\nThanks to all our team members for their contributions to this project!", // Set the desired placeholder text
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              )
            ],
          ),
        ));
  }
}
