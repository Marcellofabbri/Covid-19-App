import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19app/country.dart';
import 'package:covid19app/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jiffy/jiffy.dart';
import 'package:covid19app/history.dart';
import 'package:covid19app/record.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => Home(),
    '/history': (context) => History(),
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
  var historicData;
  List<Record> historicRecords;
  List selectedCountryHistory;
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
          historicData['records'][n]['geoId'] == countryListForDisplay[selectedCountry].nation) {
        String extrapolatedDate = historicData['records'][n]['dateRep'];
        String formattedExtrapolatedDate = extrapolatedDate.substring(6, 10) +
            extrapolatedDate.substring(3, 5) + extrapolatedDate.substring(0, 2);
        DateTime dateOfRecord = DateTime.parse(formattedExtrapolatedDate);
        String extrapolatedNewCases = historicData['records'][n]['cases'];
        double numberOfNewCases = double.parse(extrapolatedNewCases);
        Record newRecord = Record(
            recordedAt: dateOfRecord, newCases: numberOfNewCases);
        historicRecords.add(newRecord);
      }
    }
    historicRecords.sort((record1, record2) => (record1.recordedAt).compareTo(record2.recordedAt));
    return historicRecords;
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
      case 0: { return Colors.deepPurple[900]; }
      break;

      case 1: { return Colors.deepPurple[900]; }
      break;

      case 2: { return Colors.red; }
      break;

      case 3: { return Colors.red; }
      break;

      case 4: { return Colors.green; }
      break;

      case 5: { return Colors.amber; }
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
        },
      ),
    );
  }

  epidemicTrendButton() async {
    List listOfHistoricRecords = await populateHistoricRecords();
    if (listOfHistoricRecords.isEmpty) {
      return FlatButton.icon(
        label: Text('Epidemic trend not available'),
        icon: Icon(Icons.do_not_disturb_alt, color: Colors.red, size: 20),
        onPressed: () {},
      );
    } else {
      return FlatButton.icon(
          icon: Icon(Icons.assessment, color: Colors.lightGreen),
          label: Text("${countryListForDisplay[selectedCountry].nation}'s epidemic trend",
              style: TextStyle(
                  color: Colors.white70
              )
          ),
          onPressed: () {
            Navigator.pushNamed(
                context,
                '/history',
                arguments: ScreenArguments(countryListForDisplay[selectedCountry], historicRecords)
            );
          }
      );
    }
  }

  loadingEpidemicTrendButton() {
    return FlatButton.icon(
      label: Text('Epidemic trend not available'),
      icon: SpinKitRotatingCircle(color: Colors.amber, size: 17),
      onPressed: () {},
    );
  }

  timestampBuilder() {
    if (countryList[selectedCountry].timeStamp.replaceFirst(RegExp('T'), ' | ').length > 16) {
      return countryList[selectedCountry].timeStamp.replaceFirst(RegExp('T'), ' | ').substring(0, 18) + ' GMT';
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
                  build(context);},
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
                    height: 275,
                    margin: EdgeInsets.fromLTRB(33, 0, 33, 0),
                    child: ListView(
                      children: List.generate(6, (int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.blueGrey[900]),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
                                color: Colors.blueGrey[900].withOpacity(0.30 + (0.08 * index)),
                              ),
                              margin: EdgeInsets.fromLTRB((index * 0.0), 0, 0, 0),
                              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                              alignment: AlignmentDirectional.center,
                              height: 40,
                              width: 190,
                              child: Text('${cardInfo[index]['title']}',
                                style: TextStyle(
                                  fontFamily: 'YK',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.grey[300],
                                  shadows: [Shadow(blurRadius: 1, color: Colors.blueGrey[700], offset: Offset(2, 1))]
                                )
                            )
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: colorSetter(index).withOpacity(0.3),
                                border: Border.all(width: 1, color: Colors.blueGrey[900]),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(6), bottomRight: Radius.circular(6)),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              alignment: AlignmentDirectional.center,
                              height: 40,
                              width: 90,
                              child: Text('${propertySetter(index)}',
                                style: TextStyle(
                                  fontFamily: 'YK',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 21,
                                  color: Colors.amber[300],
                                  shadows: [Shadow(blurRadius: 5, color: Colors.brown, offset: Offset(0, 0))]
                                )
                              )
                            )
                          ],
                        );
                      })
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}