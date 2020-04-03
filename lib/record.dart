import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19app/country.dart';
import 'package:covid19app/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:covid19app/history.dart';

class Record {

  DateTime recordedAt;
  double newCases;
  double newDeaths;
  double totalCases;
  double totalDeaths;

  Record({this.recordedAt, this.newCases, this.newDeaths, this.totalCases, this.totalDeaths});

}
