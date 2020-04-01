import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19app/country.dart';
import 'package:covid19app/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bezier_chart/bezier_chart.dart';

class ScreenArguments {
  final Country country;
  dynamic countryHistory;

  ScreenArguments(this.country, this.countryHistory);

}

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  dateparser(object) {
    return object['year'] + object['dateRep'].substring(3, 5) + object['dateRep'].substring(0, 2);
  }

  horizontalAxis(countryHistory) {
    var abscissa = [];
    for (var m = 0; m < countryHistory.length; m++) {
      var x = DateTime.parse(dateparser(countryHistory[m]));
      abscissa.add(x);
    }
    return abscissa;
  }

  horizontalAxisLabel(countryHistory) {
    var abscissa = [];
    for (var m = 0; m < countryHistory.length; m++) {
      var x = countryHistory[m]['dateRep'];
      abscissa.add(x);
    }
    return abscissa;
  }

  mapper(countryHistory) {
    var listOfPoints = [];
    for (var m = 0; m < countryHistory.length; m++) {
      var y = double.parse(countryHistory[m]['cases']);
      var x = DateTime.parse(dateparser(countryHistory[m]));
      var point = DataPoint<DateTime>(value: y, xAxis: x);
      listOfPoints.add(point);
    }
    return listOfPoints;
  }

  @override
  Widget build(BuildContext context) {

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final fromDate = DateTime(2019, 12, 19);
    final toDate = DateTime.now();

    final date1 = DateTime.now().subtract(Duration(days: 2));
    final date2 = DateTime.now().subtract(Duration(days: 3));

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
              color: Colors.red,
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: BezierChart(
                fromDate: fromDate,
                bezierChartScale: BezierChartScale.WEEKLY,
                toDate: toDate,
                selectedDate: toDate,
                series: [
                  BezierLine(
                    label: "Duty",
                    onMissingValue: (dateTime) {
                      if (dateTime.day.isEven) {
                        return 10.0;
                      }
                      return 5.0;
                    },
                    data: [
                      DataPoint<DateTime>(value: 10, xAxis: date1),
                      DataPoint<DateTime>(value: 50, xAxis: date2),
                    ],
                  ),
                ],
                config: BezierChartConfig(
                  verticalIndicatorStrokeWidth: 3.0,
                  verticalIndicatorColor: Colors.black26,
                  showVerticalIndicator: true,
                  verticalIndicatorFixedPosition: false,
                  backgroundColor: Colors.red,
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
