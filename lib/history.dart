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

class ScreenArguments {
  final Country country;
  dynamic historicRecords;

  ScreenArguments(this.country, this.historicRecords);

}

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  Row header = Row(
    children: <Widget>[
      Container(
        height: 35,
        decoration: BoxDecoration(
          color: Colors.yellow,
        ),
        child: Text('NEW CASES')
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.red
        ),
        child: Text('PERCENTAGE')
      ),
      Container(
        child: Text('COMPARED TO YESTERDAY')
      )
    ],
  );

  dataPointsArrayBuilder(historicRecords) {
    List<DataPoint> array = [];
    for (var i = 0; i < historicRecords.length; i++) {
      DataPoint newDataPoint = DataPoint<DateTime>(value: historicRecords[i].newCases, xAxis: historicRecords[i].recordedAt);
      array.add(newDataPoint);
    }
    return array;
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  rowsBuilder(historicRecords) {
    List<Widget>rows = [];
    for (var i = 1; i < 6; i++) {
      var date = historicRecords[historicRecords.length - i].recordedAt;
      var figureToday = historicRecords[historicRecords.length - i].newCases.toInt();
      var figureYesterday = historicRecords[historicRecords.length - i - 1].newCases.toInt();
      var trend = figureToday > figureYesterday ? 'increase' : 'decrease';
      Icon arrow = figureToday < figureYesterday ? Icon(Icons.arrow_downward, color: Colors.lightGreen[700]) : figureToday == figureYesterday ? Icon(Icons.arrow_forward) : Icon(Icons.arrow_upward, color: Colors.red);
      double percentage = figureYesterday == 0 ? 0.0 : roundDouble(((figureToday / figureYesterday) - 1) * 100, 2);
      Row newRow = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 30,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100 + (i*100)]
            ),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                  ),
                  child: Text(' ${Jiffy(date).format("MMM dd")}: '),
                ),
                Container(
                  decoration: BoxDecoration(
                  ),
                  child: Text('$figureToday',
                    style: boldStyle()
                  )
                )
              ],
            )
          ),
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[100 + (i*100)]),
                    color: Colors.grey[800]
                ),
                child: arrow
              ),
              Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[100 + (i*100)]
                  ),
                  child: Text('${percentage == 0.0 ? 'N/A' : percentage}' + '%',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    )
                  )
              )
            ],
          ),
          Container(
            alignment: Alignment.center,
            height: 30,
            width: 115,
            decoration: BoxDecoration(
                color: Colors.grey[100 + (i*100)]
            ),
            child: Text('difference: ${figureToday - figureYesterday}')
          )
        ],
      );
      rows.add(newRow);
    }
    return rows;
  }

  TextStyle boldStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    List<DataPoint> dataPointsArray = dataPointsArrayBuilder(args.historicRecords);
    final fromDate = DateTime(2019, 12, 01);
    final toDate = dataPointsArray.last.xAxis.add(new Duration(days: 1));

    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                height: 45,
                child: Image.asset('assets/flags/${args.country.nation}.png')
              ),
              Container(
                height: 40,
                margin: EdgeInsets.fromLTRB(3, 20, 3, 0),
                child: Text('${args.country.nation}',
                  style: TextStyle(
                    fontFamily: 'YK',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[400]
                  ),
                )
              ),
            ],
          ),
          Container(
              height: 17,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text('Long press to inspect the chart',
                style: TextStyle(
                    fontFamily: 'YK',
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    color: Colors.amber[400]
                ),
              )
          ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
            elevation: 12,
            clipBehavior: Clip.hardEdge,
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: BezierChart(
                fromDate: fromDate,
                bezierChartScale: BezierChartScale.WEEKLY,
                toDate: toDate,
                selectedDate: toDate,
                bubbleLabelDateTimeBuilder: (DateTime date, bezierChartScale) {
                  var formatter = DateFormat('y-MMM-d');
                  String bubbleDate =  formatter.format(date);
                  return bubbleDate.substring(0, 4) + ' ' + bubbleDate.substring(5, 8) + ' ' + bubbleDate.substring(9) + '\n';
                },
                series: [
                  BezierLine(
                    dataPointFillColor: Colors.red,
                    label: "fallen ill on this day",
                    onMissingValue: (dateTime) {
                      return 0.0;
                    },
                    data: dataPointsArray
                  ),
                ],
                config: BezierChartConfig(
                  displayYAxis: false,
                  displayLinesXAxis: true,
                  verticalIndicatorStrokeWidth: 3.0,
                  verticalIndicatorColor: Colors.red,
                  showVerticalIndicator: true,
                  verticalIndicatorFixedPosition: false,
                  backgroundColor: Colors.deepPurple[900],
                  footerHeight: 45.0,
                  snap: false
                ),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 35),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                      ),
                      child: Text('New cases',
                        style: boldStyle()
                      )
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.orange
                    ),
                    child: Text('Percentage',
                      style: boldStyle()
                    )
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 35,
                    width: 115,
                    decoration: BoxDecoration(
                      color: Colors.red
                    ),
                      child: Text('VS. previous day',
                        style: boldStyle()
                      )
                  )
                ],
              )
          ),
          Container(
            height: 200,
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 35),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            decoration: BoxDecoration(
            ),
            child: Column(
              children: rowsBuilder(args.historicRecords),
            )
          ),
        ],
      )
    );
  }
}
