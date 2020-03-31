import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19app/country.dart';
import 'package:covid19app/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bezier_chart/bezier_chart.dart';

class ScreenArguments {
  final Country country;

  ScreenArguments(this.country);
}

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  @override
  Widget build(BuildContext context) {

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
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
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Text('${args.country.nation}')
          ),
          Card(
            elevation: 12,
            clipBehavior: Clip.hardEdge,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width * 0.9,
              child: BezierChart(
                bezierChartScale: BezierChartScale.CUSTOM,
                xAxisCustomValues: const [0, 5, 10, 15, 20, 25, 30, 35],
                footerValueBuilder: (double value) {
                  return "$value\ndays";
                },
                series: const [
                  BezierLine(
                    label: "m",
                    data: const [
                      DataPoint<double>(value: 10, xAxis: 0),
                      DataPoint<double>(value: 130, xAxis: 5),
                      DataPoint<double>(value: 50, xAxis: 10),
                      DataPoint<double>(value: 150, xAxis: 15),
                      DataPoint<double>(value: 75, xAxis: 20),
                      DataPoint<double>(value: 0, xAxis: 25),
                      DataPoint<double>(value: 5, xAxis: 30),
                      DataPoint<double>(value: 45, xAxis: 35),
                    ],
                  ),
                ],
                config: BezierChartConfig(
                  footerHeight: 40,
                  verticalIndicatorStrokeWidth: 3.0,
                  verticalIndicatorColor: Colors.black26,
                  showVerticalIndicator: true,
                  verticalIndicatorFixedPosition: false,
                  backgroundGradient: LinearGradient(
                    colors: [
                      Colors.red[300],
                      Colors.red[400],
                      Colors.red[400],
                      Colors.red[500],
                      Colors.red,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  snap: false,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
