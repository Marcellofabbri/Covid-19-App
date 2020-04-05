import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19app/country.dart';
import 'package:covid19app/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jiffy/jiffy.dart';
import 'package:covid19app/history.dart';
import 'package:covid19app/record.dart';
import 'package:covid19app/spread.dart';
import 'package:async/async.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => Home(),
    '/history': (context) => History(),
    '/spread': (context) => Spread(),
  }
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var circleColor;
  List<Country> countryList = [];
  List<Country> countryListForDisplay = [Country(), Country(), Country(), Country(), Country(), Country()];
  int selectedCountry = 0;
  Country selectedCountryInstance = Country();
  Map dataToday;
  var historicDeaths;
  var historicData;
  List<Record> historicRecords;
  List selectedCountryHistory;
  var graphButtons1 = Container(child: Icon(Icons.assessment, color: Colors.lightGreen, size: 40));
  var graphButtons2 = Container(child: Icon(Icons.assessment, color: Colors.lightGreen, size: 40));
  List<Map> cardInfo = [
    {
      'title' : 'DAILY DEATHS',
      'property' : 'diedToday'
    },
    {
      'title' : 'DEATHS IN TOTAL',
      'property' : 'diedSoFar'
    },
    {
      'title' : 'DAILY NEW CASES',
      'property' : 'illToday'
    },
    {
      'title' : 'ILL AT THE MOMENT',
      'property' : 'illSoFar'
    },
    {
      'title' : 'RECOVERED SO FAR',
      'property' : 'healedSoFar'
    },
    {
      'title' : 'CASES IN TOTAL',
      'property' : 'tally'
    }
  ];

  setCountry(index) {
    selectedCountry = index;
  }

  populateHistoricRecords() async {
    historicRecords = [];
    historicData = await historicData;
    for (var n = 0; n < historicData['records'].length; n++) {
      if (historicData['records'][n]['countriesAndTerritories'] == countryListForDisplay[selectedCountry].nation ||
          historicData['records'][n]['countryterritoryCode'] == countryListForDisplay[selectedCountry].nation ||
          historicData['records'][n]['geoId'] == countryListForDisplay[selectedCountry].nation ||
          historicData['records'][n]['countriesAndTerritories'] == countryListForDisplay[selectedCountry].thirdName) {
        String extrapolatedDate = historicData['records'][n]['dateRep'];
        String formattedExtrapolatedDate = extrapolatedDate.substring(6, 10) +
            extrapolatedDate.substring(3, 5) + extrapolatedDate.substring(0, 2);
        DateTime dateOfRecord = DateTime.parse(formattedExtrapolatedDate);
        String extrapolatedNewCases = historicData['records'][n]['cases'];
        String extrapolatedNewDeaths = historicData['records'][n]['deaths'];
        double numberOfNewCases = double.parse(extrapolatedNewCases);
        double numberOfNewDeaths = double.parse(extrapolatedNewDeaths);
        Record newRecord = Record(
            recordedAt: dateOfRecord,
            newCases: numberOfNewCases,
            newDeaths: numberOfNewDeaths,
            totalCases: 0,
            totalDeaths: 0);
        historicRecords.add(newRecord);
      }
    }
    historicRecords.sort((record1, record2) => (record1.recordedAt).compareTo(record2.recordedAt));
    completeTheRecords();
    return historicRecords;
  }

  completeTheRecords() {
    Record oldestRecord = historicRecords[0];
    oldestRecord.totalCases = oldestRecord.newCases;
    oldestRecord.totalDeaths = oldestRecord.newDeaths;
    for (var h = 1; h < historicRecords.length; h++)  {
      historicRecords[h].totalCases = historicRecords[(h - 1)].totalCases + historicRecords[h].newCases;
      historicRecords[h].totalDeaths = historicRecords[(h - 1)].totalDeaths + historicRecords[h].newDeaths;
    }
  }

  propertySetter(index) {
    if (countryListForDisplay.length == 0) {
      return '';
    } else {
      switch(index) {
        case 0:
          {
            return countryListForDisplay[selectedCountry].diedToday;
          }
          break;

        case 1:
          {
            return countryListForDisplay[selectedCountry].diedSoFar;
          }
          break;

        case 2:
          {
            return countryListForDisplay[selectedCountry].illToday;
          }
          break;

        case 3:
          {
            return countryListForDisplay[selectedCountry].illSoFar;
          }
          break;

        case 4:
          {
            return countryListForDisplay[selectedCountry].healedSoFar;
          }
          break;

        case 5:
          {
            return countryListForDisplay[selectedCountry].tally;
          }
          break;
      }
    }
  }

  colorSetter(index) {
    switch(index) {
      case 0: { return Colors.blueGrey[900].withOpacity(0.4); }
      break;

      case 1: { return Colors.blueGrey[900].withOpacity(0.5); }
      break;

      case 2: { return Colors.blueGrey[900].withOpacity(0.4); }
      break;

      case 3: { return Colors.blueGrey[900].withOpacity(0.5); }
      break;

      case 4: { return Colors.blueGrey[900].withOpacity(0.4); }
      break;

      case 5: { return Colors.blueGrey[900].withOpacity(0.5); }
      break;
    }
  }

  createCountryList() {
    for (var i = 0; i < 200; i++) {
      Country instanceOfCountry = Country(dataToday: dataToday, index: i);
      countryList.add(instanceOfCountry);
    }
  }

  populateCountryList(data) {
    countryList = [];
    for (int i = 0; i < 200; i++) {
      Country instanceOfCountry = Country(dataToday: data, index: i);
      instanceOfCountry.populate();
      countryList.add(instanceOfCountry);
    }
  }

  Future<Map> getData() async {
    Loader loader = Loader();
    await loader.retrieveFromApi();
    return loader.dataToday;
  }

  Future<Map> getHistoricData() async {
    Loader loader = Loader();
    await loader.retrieveHistoricData();
    return loader.historicData;
  }

  addHistoricData() async {
    setState(() async {
      historicData = await getHistoricData();
    });
  }

  Future loadUp() async {
    setState(() {
      circleColor = SpinKitRotatingCircle(color: Colors.red, size: 18);
    });
    setState(() async {
      populateCountryList(await getData());
      getHistoricData();
      propertySetter(1);
      countryList.sort((country1, country2) => (country1.nation).compareTo(country2.nation));
      countryList.forEach((country) => nameDebugger(country));
      Country world = countryList.removeAt(3);
      countryList.insert(0, world);
      countryListForDisplay = countryList;

      setState(() {
        circleColor = Container(child: Image.asset('assets/blue-circle-2.png'));
      });

      setState(() {
        historicData = getHistoricData();
        historicRecords = populateHistoricRecords();
      });
    });
   }

   loadingButtonColor() {
    return circleColor;
   }

  @override
  void initState() {
    super.initState();
    this.selectedCountry = 0;
    createCountryList();
    loadUp();
  }
  
  fontSizeDecider(index) {
    if (countryListForDisplay[index].nation.length < 19) {
      return 25.0;
    } else {
      return 20.0;
    }
  }

  nameDebugger(country) {
    if (country.nation == 'Cura&ccedil;ao') {
      country.nation = 'Curacao';
    } else if (country.nation == 'R&eacute;union') {
      country.nation = 'Reunion';
    } else if (country.nation == 'All') {
      country.nation = 'World';
    } else if (country.nation == 'UK') {
      country.secondName = ', United Kingdom';
    } else if (country.nation == 'USA') {
      country.secondName = ', United States';
    } else if (country.nation == 'S.-Korea') {
      country.secondName = ', South Korea';
    } else if (country.nation == 'Bosnia-and-Herzegovina') {
      country.thirdName = 'Bosnia_and_Herzegovina';
    } else if (country.nation == 'Brunei-') {
      country.thirdName = 'Brunei_Darussalam';
    } else if (country.nation == 'Burkina-Faso') {
      country.thirdName = 'Burkina_Faso';
    } else if (country.nation == 'CAR') {
      country.secondName = 'Central African Republic';
      country.thirdName = 'Central_African_Republic';
    } else if (country.nation == 'Cabo-Verde') {
      country.thirdName = 'Cape_Verde';
    } else if (country.nation == 'Cayman-Islands') {
      country.thirdName = 'Cayman_Islands';
    } else if (country.nation == 'Costa-Rica') {
      country.thirdName = 'Costa_Rica';
    } else if (country.nation == 'Curacao') {
      country.thirdName = 'Curaçao';
    } else if (country.nation == 'Czechia') {
      country.thirdName = 'Czech Republic';
    } else if (country.nation == 'DRC') {
      country.secondName = 'Dem. Rep. of Congo';
      country.thirdName = 'Democratic_Republic_of_the_Congo';
    } else if (country.nation == 'Dominican-Republic') {
      country.thirdName = 'Dominican_Republic';
    } else if (country.nation == 'El-Salvador') {
      country.thirdName = 'El_Salvador';
    } else if (country.nation == 'Equatorial-Guinea') {
      country.thirdName = 'Equatorial_Guinea';
    } else if (country.nation == 'Eswatini') {
      country.secondName = 'Swaziland';
    } else if (country.nation == 'French-Polynesia') {
      country.thirdName = 'French_Polynesia';
    } else if (country.nation == 'Isle-of-Man') {
      country.thirdName = 'Isle_of_Man';
    } else if (country.nation == 'Ivory-Coast') {
      country.thirdName = 'Cote_dIvoire';
    } else if (country.nation == 'New-Caledonia') {
      country.thirdName = 'New_Caledonia';
    } else if (country.nation == 'New-Zealand') {
      country.thirdName = 'New_Zealand';
    } else if (country.nation == 'North-Macedonia') {
      country.thirdName = 'North_Macedonia';
    } else if (country.nation == 'Papua-New-Guinea') {
      country.thirdName = 'Papua_New_Guinea';
    } else if (country.nation == 'Puerto-Rico') {
      country.thirdName = 'Puerto_Rico';
    } else if (country.nation == 'S.-Korea') {
      country.thirdName = 'South_Korea';
    } else if (country.nation == 'Saint-Lucia') {
      country.thirdName = 'Saint_Lucia';
    } else if (country.nation == 'San-Marino') {
      country.thirdName = 'San_Marino';
    } else if (country.nation == 'Saudi-Arabia') {
      country.thirdName = 'Saudi_Arabia';
    } else if (country.nation == 'Sint-Maarten') {
      country.thirdName = 'Sint_Maarten';
    } else if (country.nation == 'South-Africa') {
      country.thirdName = 'South_Africa';
    } else if (country.nation == 'Sri-Lanka') {
      country.thirdName = 'Sri_Lanka';
    } else if (country.nation == 'St.-Barth') {
      country.thirdName = 'Saint_Barthelemy';
    } else if (country.nation == 'St.-Vincent-Grenadines') {
      country.thirdName = 'Saint_Vincent_and_the_Grenadines';
    } else if (country.nation == 'Tanzania') {
      country.thirdName = 'United_Republic_of_Tanzania';
    } else if (country.nation == 'Trinidad-and-Tobago') {
      country.thirdName = 'Trinidad_and_Tobago';
    } else if (country.nation == 'Turks-and-Caicos') {
      country.thirdName = 'Turks_and_Caicos_islands';
    } else if (country.nation == 'UAE') {
      country.thirdName = 'United_Arab_Emirates';
      country.secondName = 'United Arab Emirates';
    } else if (country.nation == 'U.S.-Virgin-Islands') {
      country.thirdName = 'United_States_Virgin_Islands';
    } else if (country.nation == 'Vatican-City') {
      country.thirdName = 'Holy_See';
    }
  }

  selectedCountryHistoryUpdater() {
    selectedCountryHistory = [];
    for (var w = 0; w < historicData['records'].length; w++) {
      if (historicData['records'][w]['countriesAndTerritories'] == countryListForDisplay[selectedCountry].nation) {
        selectedCountryHistory.add(historicData['records'][w]);
      }
    }
  }

  searchBar() {
    return Container(
      child: TextField(
        textAlign: TextAlign.justify,
        style: TextStyle(
            color: Colors.amberAccent,
            fontFamily: 'YK',
            fontSize: 25),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, size: 40),
          hintText: '  Search...',
          hintStyle: TextStyle(
            fontFamily: 'YK',
            fontSize: 25,
            color: Colors.amber[100],
          )
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            selectedCountry = 0;
            countryListForDisplay = countryList.where((country) {
              var countryName = country.nation.toLowerCase();
              var countrySecondName = country.secondName.toLowerCase();
              return countryName.contains(text) || countrySecondName.contains(text);
            }).toList();
          });
          populateHistoricRecords();
        },
      ),
    );
  }

  epidemicTrendButton() async {
    List listOfHistoricRecords = historicRecords;
    if (listOfHistoricRecords.isEmpty) {
      return FlatButton.icon(
        label: Text(''),
        icon: Icon(Icons.assessment, color: Colors.blueGrey[700], size: 40),
        onPressed: () {
        },
      );
    } else {
      return FlatButton.icon(
          icon: graphButtons1,
          label: Text("${countryListForDisplay[selectedCountry].nation}'s day-by-day",
              style: TextStyle(
                  color: Colors.white70
              )
          ),
          onPressed: () {
            transition1();
          }
      );
    }
  }

  transition1() {
    Timer(Duration(milliseconds: 1), () { setState(() {
      graphButtons1 = Container(child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 1, 3, 0),
        child: SpinKitCubeGrid(color: Colors.lightGreen, size: 30),
      ));
    });});

    Timer(Duration(milliseconds: 1000), () { Navigator.pushNamed(
        context,
        '/history',
        arguments: ScreenArguments(countryListForDisplay[selectedCountry], historicRecords)
    );});

    Timer(Duration(milliseconds: 1500), () { setState(() {
      graphButtons1 = Container(child: Icon(Icons.assessment, color: Colors.lightGreen, size: 40));
    });});
  }

  spreadRateButton() async {
    List listOfHistoricRecords = historicRecords;
    if (listOfHistoricRecords.isEmpty) {
      return FlatButton.icon(
        label: Text(''),
        icon: Icon(Icons.assessment, color: Colors.blueGrey[700], size: 40),
        onPressed: () {},
      );
    } else {
      return FlatButton.icon(
          icon: graphButtons2,
          label: Text("${countryListForDisplay[selectedCountry].nation}'s trend",
              style: TextStyle(
                  color: Colors.white70
              )
          ),
          onPressed: () {
            transition2();
          }
      );
    }
  }

  transition2() {
    Timer(Duration(milliseconds: 1), () { setState(() {
      graphButtons2 = Container(child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 1, 3, 0),
        child: SpinKitCubeGrid(color: Colors.lightGreen, size: 30),
      ));
    });});

    Timer(Duration(milliseconds: 1000), () { Navigator.pushNamed(
        context,
        '/spread',
        arguments: ScreenArguments(countryListForDisplay[selectedCountry], historicRecords)
    );});

    Timer(Duration(milliseconds: 1500), () { setState(() {
      graphButtons2 = Container(child: Icon(Icons.assessment, color: Colors.lightGreen, size: 40));
    });});
  }

  loadingEpidemicTrendButton() {
    return FlatButton.icon(
      label: Text('Epidemic trend not available'),
      icon: SpinKitRotatingCircle(color: Colors.amber, size: 30),
      onPressed: () {},
    );
  }

  timestampBuilder() {
    if (countryList[selectedCountry].timeStamp.replaceFirst(RegExp('T'), ' | ').length > 16) {
      var timestamp = Jiffy(countryList[selectedCountry].timeStamp);
      var summerTimestamp = timestamp.subtract(duration: Duration(hours: 1));
      return Jiffy(summerTimestamp).format("dd MMM yyyy - HH:mm") + ' GMT';
    }
  }

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: timestampBuilder() == null ?
              SpinKitWave(color: Colors.white, size: 18) :
              Text('Updated: ${timestampBuilder()}',
                style: TextStyle(
                  letterSpacing: 0.0,
                  fontFamily: 'YK',
                  fontSize: 18.0,
                  color: Colors.white
                )
              ),
            ),
            (countryList[selectedCountry].timeStamp.replaceFirst(RegExp('T'), ' | ').length > 16) ?
            Container(
              width: 100,
              height: 25,
              child: RaisedButton(
                  color: Colors.blueGrey[700],
                  onPressed: () { loadUp();
                  build(context);
                  print(Jiffy(countryList[selectedCountry].timeStamp).format("dd-MMM-yyyy"));},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 20,
                        child: loadingButtonColor()
                      ),
                      Text('Reload',
                          style: TextStyle(
                              color: Colors.amber[300]
                          )
                      )
                    ],
                  )
              ),
            ) : Container(),
          ],
        )
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[800]
       ),
        child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 33),
                    child: searchBar()
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 140.0,
                          child: Scrollbar(
                            child: ListView(
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.fromLTRB(33.0, 10.0, 33.0, 0.0),
                                  height: 135.0,
                                  child: new ListView(
                                    scrollDirection: Axis.vertical,
                                    children: new List.generate((countryListForDisplay.length), (int index) {
                                      return Material(
                                        color: Colors.transparent,
                                        child: new Container(
                                          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.blueGrey[900].withOpacity(0.5),
                                            border: Border.all(color: index == selectedCountry ? Colors.blue[600].withOpacity(0.3) : Colors.blueGrey[900].withOpacity(0.0), width: index == selectedCountry ? 1.7 : 1.7),
                                            //boxShadow: [BoxShadow(color: Colors.blue[600], blurRadius: 2, spreadRadius: 1, offset: Offset(2, 2))]
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedCountry = index;
                                                populateHistoricRecords();
                                              });
                                              selectedCountryHistoryUpdater();
                                              build(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                              Container(
                                                alignment: AlignmentDirectional.centerEnd,
                                                width: 35.0,
                                                height: 35.0,
                                                child: Image.asset('assets/flags/${countryListForDisplay[index].nation}.png',
                                                  height: 35,
                                                  width: 35),
                                                  decoration: BoxDecoration(
                                                    ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                                  width: 150.0,
                                                  alignment: AlignmentDirectional.centerStart,
                                                  height: 35.0,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      new Text('${countryListForDisplay[index].nation}',
                                                        style: TextStyle(
                                                          fontFamily: 'YK',
                                                          color: index == selectedCountry ? Colors.blue[600] : Colors.amberAccent[200],
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: fontSizeDecider(index),
                                                          shadows: [Shadow(blurRadius: 15, color: Colors.brown, offset: Offset(2, 2))]
                                                        )
                                                      ),
                                                      new Text('${countryListForDisplay[index].secondName}',
                                                          style: TextStyle(
                                                              fontFamily: 'YK',
                                                              color: index == selectedCountry ? Colors.blue[600].withOpacity(0.5) : Colors.amberAccent[200].withOpacity(0.3),
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: fontSizeDecider(index)
                                                          )
                                                      )
                                                    ],
                                                  ),
                                              ),
                                              ]
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 200,
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: ListView(
                      children: List.generate(6, (int index) {
                        return SizedBox(
                          width: double.maxFinite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.05, color: Colors.blueGrey[900]),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3)),
                                  color: Colors.white70.withOpacity(index.isEven ? 0.6 : 0.5),
                                ),
                                margin: EdgeInsets.fromLTRB((index * 0.0), 0, 0, 0),
                                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                alignment: AlignmentDirectional.centerStart,
                                height: 33,
                                width: 195,
                                child: Text('${cardInfo[index]['title']}',
                                  style: TextStyle(
                                    //fontFamily: 'YK',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.black,
                                    //shadows: [Shadow(blurRadius: 1, color: Colors.blueGrey[700], offset: Offset(2, 1))]
                                  )
                              )
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: colorSetter(index),
                                  border: Border.all(width: 0.12, color: Colors.blueGrey[900]),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(3), bottomRight: Radius.circular(3)),
                                ),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                alignment: AlignmentDirectional.center,
                                height: 33,
                                width: 90,
                                child: Text('${propertySetter(index)}',
                                  style: TextStyle(
                                    //fontFamily: 'YK',
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.9),
                                    shadows: [Shadow(blurRadius: 5, color: Colors.brown, offset: Offset(0, 0))]
                                  )
                                )
                              )
                            ],
                          ),
                        );
                      })
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 33,
                          width: 195,
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          alignment: AlignmentDirectional.centerStart,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.05, color: Colors.blueGrey[900]),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3)),
                            color: Colors.white70.withOpacity(0.5)
                            ),
                          child: Text('${timestampBuilder()}',
                              style: TextStyle(
                                //fontFamily: 'YK',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.black,
                                  )
                          )
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[900].withOpacity(0.6),
                              border: Border.all(width: 0.12, color: Colors.blueGrey[900]),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(3), bottomRight: Radius.circular(3)),
                            ),
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            alignment: AlignmentDirectional.center,
                            height: 33,
                            width: 90,
                            child: Text('500',
                                style: TextStyle(
                                  //fontFamily: 'YK',
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.9),
                                    shadows: [Shadow(blurRadius: 5, color: Colors.brown, offset: Offset(0, 0))]
                                )
                            )
                        )
                      ],
                    )
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: FutureBuilder(
                              future: epidemicTrendButton(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data;
                                } else {
                                  return loadingEpidemicTrendButton();
                                }
                                return epidemicTrendButton();
                              }
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
                          height: 50,
                          child: FutureBuilder(
                              future: spreadRateButton(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data;
                                } else {
                                  return loadingEpidemicTrendButton();
                                }
                                return spreadRateButton();
                              }
                          )
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}