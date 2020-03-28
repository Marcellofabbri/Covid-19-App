import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19app/country.dart';
import 'package:covid19app/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MaterialApp(
  routes: {
    '/': (context) => Home(),
  }
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var circleColor;
  List<Country> countryList = [];
  int selectedCountry = 0;
  Country selectedCountryInstance = Country();
  Map dataToday;
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

  propertySetter(index) {
    switch(index) {
      case 0: { return countryList[selectedCountry].diedToday; }
      break;

      case 1: { return countryList[selectedCountry].diedSoFar; }
      break;

      case 2: { return countryList[selectedCountry].illToday; }
      break;

      case 3: { return countryList[selectedCountry].illSoFar; }
      break;

      case 4: { return countryList[selectedCountry].healedSoFar; }
      break;

      case 5: { return countryList[selectedCountry].tally; }
      break;
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
    print(countryList[0].nation);
  }

  Future<Map> getData() async {
    Loader loader = Loader();
    await loader.retrieveFromApi();
    return loader.dataToday;
  }

  Future loadUp() async {
    setState(() {
      circleColor = SpinKitRotatingCircle(color: Colors.red, size: 18);
    });
    setState(() async {
      populateCountryList(await getData());
      propertySetter(1);
      countryList.sort((country1, country2) => (country1.nation).compareTo(country2.nation));
      countryList.forEach((country) => nameDebugger(country));
      print('AM I HERE NOW?');
      setState(() {
        circleColor = Container(child: Image.asset('assets/blue-circle-2.png'));
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

  nameDebugger(country) {
    if (country.nation == 'Cura&ccedil;ao') {
      country.nation = 'Curacao';
    } else if (country.nation == 'R&eacute;union') {
      country.nation = 'Reunion';
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Updated: ${countryList[selectedCountry].timeStamp}',
                style: TextStyle(
                  letterSpacing: 0.0,
                  fontFamily: 'YK',
                  fontSize: 18.0,
                  color: Colors.white
                )),
            ),
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
            ),
          ],
        )
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[800],
//          image: DecorationImage (
//            image: AssetImage('assets/wallpapers/Arts1.jpg'),
//            fit: BoxFit.fitWidth
//          )
       ),
        child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 200.0,
                          child: Scrollbar(
                            child: ListView(
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.fromLTRB(33.0, 10.0, 33.0, 0.0),
                                  height: 184.0,
                                  child: new ListView(
                                    scrollDirection: Axis.vertical,
                                    children: new List.generate(countryList.length, (int index) {
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
                                              });
                                              build(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                              Container(
                                                alignment: AlignmentDirectional.centerEnd,
                                                width: 35.0,
                                                height: 35.0,
                                                child: Image.asset('assets/flags/${countryList[index].nation}.png',
                                                  height: 35,
                                                  width: 35),
                                                  decoration: BoxDecoration(
                                                    //border: Border.all(color: index == selectedCountry ? Colors.blue[600] : Colors.grey[600], width: index == selectedCountry ? 4.0 : 3.5),
                                                    //borderRadius: BorderRadius.circular(12)
                                                    ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 0.0),
                                                  width: 135.0,
                                                  alignment: AlignmentDirectional.centerStart,
                                                  height: 45.0,
                                                  child: new Text('${countryList[index].nation}',
                                                    style: TextStyle(
                                                      fontFamily: 'YK',
                                                      color: index == selectedCountry ? Colors.blue[600] : Colors.amberAccent[200],
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 25.0,
                                                      shadows: [Shadow(blurRadius: 15, color: Colors.brown, offset: Offset(2, 2))]
                                                    )),
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
                    margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Row(
                      children: <Widget>[
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    margin: EdgeInsets.fromLTRB(33, 15, 33, 0),
                    child: ListView(
                      children: List.generate(6, (int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.blueGrey[900]),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                                color: Colors.blueGrey[900].withOpacity(0.30 + (0.08 * index)),
                              ),
                              margin: EdgeInsets.fromLTRB((index * 0.0), 0, 0, 0),
                              padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                              alignment: AlignmentDirectional.center,
                              height: 49,
                              width: 195,
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
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              alignment: AlignmentDirectional.center,
                              height: 49,
                              width: 87,
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