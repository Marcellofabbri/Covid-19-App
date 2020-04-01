import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:covid19app/country.dart';
import 'package:covid19app/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:intl/intl.dart';

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

  dataPointsArrayBuilder(historicRecords) {
    List<DataPoint> array = [];
    for (var i = 0; i < historicRecords.length; i++) {
      DataPoint newDataPoint = DataPoint<DateTime>(value: historicRecords[i].newCases, xAxis: historicRecords[i].recordedAt);
      array.add(newDataPoint);
    }
    return array;
  }

  @override
  Widget build(BuildContext context) {

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final fromDate = DateTime(2019, 12, 01);
    final toDate = DateTime.now();

    List<DataPoint> dataPointsArray = dataPointsArrayBuilder(args.historicRecords);

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
          Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Text('${args.country.nation}',
              style: TextStyle(
                fontFamily: 'YK',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.amber[400]
              ),
            )
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
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
            margin: EdgeInsets.all(15),
            elevation: 12,
            clipBehavior: Clip.hardEdge,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.5,
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
                  verticalIndicatorStrokeWidth: 3.0,
                  verticalIndicatorColor: Colors.red,
                  showVerticalIndicator: true,
                  verticalIndicatorFixedPosition: false,
                  backgroundColor: Colors.deepPurple[900],
                  footerHeight: 30.0,
                  snap: false
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
