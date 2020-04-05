import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:covid19app/country.dart';
import 'package:covid19app/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:math';

class About extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var scaledWidth = MediaQuery.of(context).size.width * 0.75;
    return Scaffold(
      appBar: AppBar(
        title: Text('COVID-19',
        style: TextStyle(
          color: Colors.amberAccent,
          letterSpacing: 0.0,
          fontFamily: 'YK',
          fontSize: 50.0,
          fontWeight: FontWeight.bold,
        )
      ),
      centerTitle: true,
      backgroundColor: Colors.grey[900]
      ),
      body: Container(
        decoration: BoxDecoration(
        color: Colors.blueGrey[800]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Image.asset('assets/icon/Covid-19-app-foreground.png', height: scaledWidth, width: scaledWidth)
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50,vertical: 5),
              width: scaledWidth,
              child: Text('AUTHOR: Marcello Fabbri',
                style: TextStyle(color: Colors.white70))
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                width: scaledWidth,
                child: Text('RESOURCES: https://rapidapi.com/astsiatsko/api/coronavirus-monitor/ (for latest figures on the main page)\nhttps://opendata.ecdc.europa.eu/ (for graphs and tables assembled through historic data',
                  style: TextStyle(color: Colors.white70))
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                width: scaledWidth,
                child: Text('NOTE: This is the first application I\'ve ever built. Originally I hadn\'t even planned to release it on Google Play. I just finished a software developer course and this project\'s aim was merely to continue learning by exploring new technologies, such as those to build mobile apps. This app was build through Flutter on Android Studio. The programming language is Dart.\nApril 5th 2020',
                  style: TextStyle(color: Colors.white70))
            )
          ],
        ),
    )
    );
  }
}
