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
import 'package:covid19app/history.dart';

class Spread extends StatefulWidget {
  @override
  _SpreadState createState() => _SpreadState();
}

class _SpreadState extends State<Spread> {

  ScrollController _controller;
  Icon arrow = Icon(Icons.arrow_drop_down, color: Colors.white70);
  var activeVariable = 'newCases';

  headerTitle() {
    switch(activeVariable) {
      case 'newCases': { return 'Cases every 5 days'; }
      break;
      case 'newDeaths': { return 'Deaths every 5 days'; }
      break;
      case 'totalCases': { return 'Total Cases'; }
      break;
      case 'totalDeaths': { return 'Total deaths'; }
      break;
    }
  }

  recordsCombiner(historicRecords, lastIndex) {
    double combinedFigure = 0.0;
    for (var f = 0; f < 5; f++) {
      if (lastIndex - f >= 0) {
        combinedFigure +=
        recordsIntoMaps(historicRecords[lastIndex - f])[activeVariable];
      }
    }
    return combinedFigure;
  }

  dataPointsArrayBuilder(historicRecords) {
    List<DataPoint> array = [];

    for (var i = historicRecords.length - 1; i >= 0; i-=5) {
      DataPoint newDataPoint = DataPoint<DateTime>(
          value: recordsCombiner(historicRecords, i),
          xAxis: historicRecords[i].recordedAt);
      array.add(newDataPoint);
    }

    List<DataPoint> arrayReversed = new List.from(array.reversed);

    return arrayReversed;
  }

  boardColor() {
    switch(activeVariable) {
      case 'newCases': { return Colors.red[400].withOpacity(0.3); }
      break;
      case 'newDeaths': { return Colors.blue.withOpacity(0.2); }
      break;
      case 'totalCases': { return Colors.green.withOpacity(0.2); }
      break;
      case 'totalDeaths': { return Colors.purpleAccent.withOpacity(0.2); }
      break;
    }
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  recordsIntoMaps(record) {
    Map mappedRecord = {
      'recordedAt': record.recordedAt,
      'newCases': record.newCases,
      'newDeaths': record.newDeaths,
      'totalDeaths': record.totalDeaths,
      'totalCases' : record.totalCases
    };
    return mappedRecord;
  }

  rowsBuilder(dataPointsArray) {
    eachDataPointRetriever(i) {
      return dataPointsArray[dataPointsArray.length - i];
    }
    eachDataPointRetrieverMinusOne(i) {
      return dataPointsArray[dataPointsArray.length - i - 1];
    }
    List<Widget>rows = [];
    for (var i = 1; i < dataPointsArray.length; i++) {
      var date = eachDataPointRetriever(i).xAxis;
      var periodEndingOn = Jiffy(date).format("MMM dd");
      var periodStartingOn = Jiffy(Jiffy(date).subtract(duration: Duration(days: 4))).format("MMM dd");
      var figureToday = eachDataPointRetriever(i).value.toInt();
      var figure5daysAgo = (eachDataPointRetrieverMinusOne(i)).value.toInt();
      Icon arrow = figureToday < figure5daysAgo ? Icon(Icons.arrow_downward, color: Colors.lightGreen[700]) : figureToday == figure5daysAgo ? Icon(Icons.arrow_forward) : Icon(Icons.arrow_upward, color: Colors.red);
      double percentage = figure5daysAgo == 0 ? 0.0 : roundDouble(((figureToday / figure5daysAgo) - 1) * 100, 2);
      Row newRow = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              height: 40,
              width: 107,
              decoration: BoxDecoration(
                  color: Colors.grey[(i.isEven? 300 : 400)]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                    ),
                    child: Text(' $periodStartingOn \n $periodEndingOn'),
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
                  height: 40,
                  width: 30,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[(i.isEven? 300 : 400)]),
                      color: Colors.grey[800]
                  ),
                  child: arrow
              ),
              Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 70,
                  decoration: BoxDecoration(
                      color: Colors.grey[(i.isEven? 300 : 400)]
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
              height: 40,
              width: 70,
              decoration: BoxDecoration(
                  color: Colors.grey[(i.isEven? 300 : 400)]
              ),
              child: Text('${(figureToday - figure5daysAgo) >= 0 ? '+' : '-'}' + '${figureToday - figure5daysAgo}')
          )
        ],
      );
      rows.add(newRow);
    }
    return rows;
  }

  generateScrollBar(dataPointsArray) {
    return Scrollbar(

        child: ListView(
          controller: _controller,
          scrollDirection: Axis.vertical,
          children: List.generate((rowsBuilder(dataPointsArray).length), (int index) {
            return rowsBuilder(dataPointsArray)[index];
          }),
        )
    );
  }

  TextStyle boldStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        arrow = Icon(Icons.arrow_drop_up, color: Colors.white70);
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        arrow = Icon(Icons.arrow_drop_down, color: Colors.white70);
      });
    }
  }

  floatingLabel() {
    switch(activeVariable) {
      case 'newCases':
        { return 'ill in the past 5 days'; }
        break;
      case 'newDeaths':
        { return 'died in the past 5 days'; }
        break;
      case 'totalCases':
        { return 'cases so far'; }
        break;
      case 'totalDeaths':
        { return 'died so far'; }
        break;
    }
  }

  abscissaConstructor(dataPointsArray) {
    List abscissa = [];
    List<double>abscissaPoints = [];
    double x = -1.0;
    dataPointsArray.forEach((dataPoint) => abscissa.add(dataPoint.xAxis));
    dataPointsArray.forEach((dataPoint) => abscissaPoints.add(x += 1));
    return abscissaPoints;
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    List<DataPoint> dataPointsArray = dataPointsArrayBuilder(args.historicRecords);
    final fromDate = DateTime(2019, 12, 01);
    final toDate = dataPointsArray.last.xAxis.add(new Duration(days: 1));

    return Scaffold(
        backgroundColor: Colors.blueGrey[800],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                    height: 45,
                    child: Image.asset('assets/flags/${args.country.nation}.png')
                ),
                Container(
                    height: 55,
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
              margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.red[400].withOpacity(0.3),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6))
                      ),
                      width: 115,
                      height: 35,
                      child: FlatButton(
                          onPressed: () {
                            setState(() {
                              activeVariable = 'newCases';
                            });
                          },
                          child: Text('Cases every\n5 days',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: (activeVariable == 'newCases') ? Colors.amberAccent : Colors.white
                              )
                          )
                      )
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[700].withOpacity(0.3),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6))
                      ),
                      width: 115,
                      height: 35,
                      child: FlatButton(
                          onPressed: () {
                            setState(() {
                              activeVariable = 'newDeaths';
                            });
                          },
                          child: Text('Deaths every\n5 days',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: (activeVariable == 'newDeaths') ? Colors.amberAccent : Colors.white
                              ))
                      )
                  ),
                ],
              ),
            ),
            Card(
              color: boardColor(),
              margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
              elevation: 12,
              clipBehavior: Clip.hardEdge,
              child: Container(
                padding: EdgeInsets.only(top: 25),
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                child: BezierChart(
                  bezierChartScale: BezierChartScale.CUSTOM,
                    xAxisCustomValues: abscissaConstructor(dataPointsArray),
                    bubbleLabelValueBuilder: (value) {
                      var formatter = DateFormat('y-MMM-d');
                      var date = dataPointsArray[value.toInt()].xAxis;
                      String bubbleDate =  formatter.format(date);
                      return bubbleDate.substring(0, 4) + ' ' + bubbleDate.substring(5, 8) + ' ' + bubbleDate.substring(9) + '\n';
                    },
                    bubbleLabelDateTimeBuilder: (DateTime date, bezierChartScale) {
                    var formatter = DateFormat('y-MMM-d');
                    String bubbleDate =  formatter.format(date);
                    return bubbleDate.substring(0, 4) + ' ' + bubbleDate.substring(5, 8) + ' ' + bubbleDate.substring(9) + '\n';
                  },
                  series: [
                    BezierLine(
                        lineStrokeWidth: 3,
                        dataPointFillColor: Colors.red,
                        label: floatingLabel(),
                        onMissingValue: (dateTime) {
                          return 0.0;
                        },
                        data: dataPointsArray
                    ),
                  ],
                  config: BezierChartConfig(
                      showDataPoints: false,
                      displayLinesXAxis: true,
                      verticalIndicatorStrokeWidth: 3.0,
                      verticalIndicatorColor: Colors.red,
                      showVerticalIndicator: true,
                      verticalIndicatorFixedPosition: false,
                      backgroundColor: boardColor(),
                      footerHeight: 28.0,
                      pinchZoom: true,
                      snap: false
                  ),
                ),
              ),
            ),
            Container(
                height: 35,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Text('Long press to inspect the chart\nFigures may be offset by one day based on where you live',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'YK',
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: Colors.amber[400]
                  ),
                )
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 35),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 107,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                        ),
                        child: Text(headerTitle(),
                            textAlign: TextAlign.center,
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
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.red
                        ),
                        child: Text('VS. previous 5day-span',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10
                          ),
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
                child: SizedBox(
                  child: generateScrollBar(dataPointsArray),
                )
            ),
            Container(
              height: 23,
              color: Colors.blueGrey[700],
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 35),
              child: arrow,
            )
          ],
        )
    );
  }
}
