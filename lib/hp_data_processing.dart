import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'functions.dart';
import 'dart:math';

Map<String, dynamic> processData(
    List<DocumentSnapshot> docs, double currentPrice) {
  // Initialising a bunch of variables, priceIndex tells how cheap power is
  // compressorTime records the time the compressor has been on
  // tempLast is the latest temperature
  // tempFirst is initially set to tempLast
  // hpMultiplier determines if the heat pump compressor struggles to heat
  String field = "HP_compressor_on_off";
  String compressorInfo = "Current compressor status unknown.";
  String advice = "No need for additional heating.";
  String advice2 = "Electricity is normal.";
  double priceIndex = 0;
  int compressorTime = countConsecutiveOnValues(docs, field);
  int tempLast = convertToInt(docs, 0, "temp_watertank_lower");
  int tempFirst = tempLast;
  double heatingRate = 0;
  double hpMultiplier = 1.0;

  // if the compressor is off, the starting temperature is taken from 5 minutes ago
  // if the compressor is on, the starting temperature is taken from when it
  // turned on (up to 20 minutes before)
  if (compressorTime == 0) {
    tempFirst = convertToInt(docs, 5, "temp_watertank_lower");
  } else {
    tempFirst = convertToInt(docs, compressorTime, "temp_watertank_lower");
  }
  // An example of how to get any string value, the middle
  // argument is position of the document in the list
  // the last arg is the field
  String value = getField(docs, 0, "temp_out");

  // Divide by 10 to get temperature with decimals (e.g. 83 -> 8.3°C)
  double tempDelta = (tempLast - tempFirst) / 10;
  if (compressorTime == 0) {
    compressorInfo = "Compressor is currently off.";
    heatingRate = tempDelta / 5;
    print(tempFirst);
    print(tempLast);
  } else if (compressorTime <= 15) {
    compressorInfo = "Compressor has been on for $compressorTime minutes.";
    heatingRate = tempDelta / compressorTime;
  } else if (compressorTime == 1) {
    compressorInfo = "Compressor has been on for $compressorTime minute.";
    heatingRate = tempDelta;
  } else {
    compressorInfo = "Compressor has been on for over 15 minutes.";
  }
  double standardPrice = 5;
  double ahiValue = 50;
  double priceFactor = 10;
  double tempFactor = 0;
  int outsideTemp = convertToInt(docs, 0, "temp_out");
  int tankTemp = convertToInt(docs, 0, "temp_watertank_lower");

  // if the compressor was unable to heat over 15 minutes, AHI set to 100
  // if the compressor only heats slightly over 15 minutes, increase the multiplier
  // so that AHI rises more quickly
  if (compressorTime > 15 && heatingRate < 0) {
    ahiValue = 100;
  } else {
    if (compressorTime > 15 && heatingRate < 0.3) {
      hpMultiplier = 1.5;
    }
    if (outsideTemp < -250) {
      tempFactor = 100;
      if (currentPrice < standardPrice) {
        ahiValue =
            hpMultiplier * tempFactor + 30 * log(currentPrice / standardPrice);
      }
    } else if (outsideTemp > 250) {
      tempFactor = 0;
      ahiValue = tempFactor;
    } else {
      tempFactor = (-0.2) * outsideTemp + 50;
      ahiValue =
          hpMultiplier * tempFactor + 30 * log(currentPrice / standardPrice);
    }
  }

  if (ahiValue < 0) {
    ahiValue = 0;
  } else if (ahiValue == 0) {
  } else if (ahiValue <= 30) {
    advice = "Additional heating probably not necessary.";
  } else if (ahiValue <= 50) {
    advice = "Additional heating might be a good idea.";
  } else if (ahiValue <= 70) {
    advice = "Additional heating is recommended.";
  } else if (ahiValue <= 90) {
    advice = "Additional heating is advised.";
  } else if (ahiValue <= 100) {
    advice = "Additional heating strongly advised!";
  } else {
    ahiValue = 100;
    advice = "Time to go burn some firewood!";
  }

  if ((currentPrice / standardPrice) < 1) {
    priceIndex = (1 - currentPrice / standardPrice) * 100;
    advice2 =
        "Electricity is ${priceIndex.toStringAsFixed(1)}% cheaper than average.";
  } else if ((currentPrice / standardPrice) > 1) {
    priceIndex = (currentPrice / standardPrice - 1) * 100;
    advice2 =
        "Electricity is ${priceIndex.toStringAsFixed(1)}% more expensive than average.";
  }

  return {
    'outsideTemp': outsideTemp,
    'tankTemp': tankTemp,
    'compressorInfo': compressorInfo,
    'tempDelta': tempDelta,
    'tempLast': tempLast,
    'tempFirst': tempFirst,
    'ahiValue': ahiValue.toInt(),
    'heatingRate': heatingRate,
    'advice': advice,
    'advice2': advice2,
  };
}
