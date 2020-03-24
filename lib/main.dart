import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19app/country.dart';
import 'package:flutter/widgets.dart';

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

  List<Country> countryList = [
    Country(nation: 'Italy'),
    Country(nation: 'China'),
    Country(nation: 'France'),
    Country(nation: 'Spain'),
    Country(nation: 'Germany'),
    Country(nation: 'UK'),
    Country(nation: 'USA')
  ];

  String diedSoFar = 'LOADING';
  String diedToday = 'LOADING';
  String illSoFar = 'LOADING';
  String healedSoFar = 'LOADING';
  String healedToday = 'LOADING';
  String illToday = 'LOADING';
  String tally = 'LOADING';
  int selectedCountry = 2;
  String timeStamp = '...';

  void setCountry() async {
    Country countryObject = countryList[selectedCountry];
    await countryObject.getDataLatestStatByCountry();
    setState(() {
      diedSoFar = countryObject.diedSoFar;
      diedToday = countryObject.diedToday;
      illSoFar = countryObject.illSoFar;
      illToday = countryObject.illToday;
      healedSoFar = countryObject.healedSoFar;
      healedToday = countryObject.healedToday;
      tally = countryObject.tally;
      selectedCountry = selectedCountry;
      timeStamp = countryObject.timeStamp;
    });
  }

  @override
  void initState() {
    super.initState();
    this.selectedCountry = 0;
    setCountry();
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('RECORDS UPDATED AT $timeStamp',
            style: TextStyle(
              letterSpacing: 0.0,
              fontFamily: 'MMD',
              fontSize: 20.0,
              color: Colors.white
            )),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 250.0,
                          child: Scrollbar(
                            child: ListView(
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.fromLTRB(33.0, 10.0, 33.0, 0.0),
                                  height: 230.0,
                                  child: new ListView(
                                    scrollDirection: Axis.vertical,
                                    children: new List.generate(countryList.length, (int index) {
                                      return new Card(
                                        color: Colors.brown[100 + (index * 100)],
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                        InkWell(
                                        child: Container(
                                            alignment: AlignmentDirectional.centerEnd,
                                            width: 35.0,
                                            height: 35.0,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: index == selectedCountry ? Colors.blue[600] : Colors.grey[600], width: index == selectedCountry ? 4.0 : 3.5),
                                                borderRadius: BorderRadius.circular(12),
                                                image: DecorationImage(
                                                    image: AssetImage('assets/flags/${countryList[index].nation}.jpg'),
                                                    fit: BoxFit.fill,
                                                ),
                                                )
                                            ),
                                            onTap: () {
                                              setState(() {
                                                selectedCountry = index;
                                              });
                                              setCountry();
                                              build(context);
                                            }
                                        ),
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                                              width: 100.0,
                                            alignment: AlignmentDirectional.centerStart,
                                            height: 50.0,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[900]
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                          width: 130.0,
                          child:
                            Column(
                              children: <Widget>[
                                Text("DIED TODAY",
                                  style: TextStyle(
                                    fontFamily: 'YK',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  )),
                                Text("$diedToday",
                                    style: TextStyle(
                                      fontFamily: 'YK',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
                                    ))
                              ],
                            )
                        )
                      ),
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                          width: 130.0,
                          child: Column(
                            children: <Widget>[
                              Text("DIED SO FAR",
                                  style: TextStyle(
                                    fontFamily: 'YK',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  )),
                              Text('$diedSoFar',
                                  style: TextStyle(
                                    fontFamily: 'YK',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0,
                                  ))
                            ],
                          )
                         )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepOrange[900]
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                          width: 130.0,
                          child: Column(
                            children: <Widget>[
                              Text("FALLEN ILL TODAY",
                                  style: TextStyle(
                                    fontFamily: 'YK',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  )),
                              Text('$illToday',
                                  style: TextStyle(
                                    fontFamily: 'YK',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0,
                                  ))
                            ],
                          )
                        )
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepOrange[700]
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                          width: 130.0,
                          child: Column(
                            children: <Widget>[
                              Text("CURRENTLY ILL",
                                  style: TextStyle(
                                    fontFamily: 'YK',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  )),
                              Text('$illSoFar',
                                  style: TextStyle(
                                    fontFamily: 'YK',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0,
                                  ))
                            ],
                          )
                        )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.lightGreen[800]
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                              width: 130.0,
                              child: Column(
                                children: <Widget>[
                                  Text("HEALED TODAY",
                                      style: TextStyle(
                                        fontFamily: 'YK',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      )),
                                  Text('$healedToday',
                                      style: TextStyle(
                                        fontFamily: 'YK',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                      ))
                                ],
                              )
                          )
                      ),
                      Center(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.lightGreen[600],
                                borderRadius: BorderRadius.circular(10)
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                              width: 130.0,
                              child: Column(
                                children: <Widget>[
                                  Text("HEALED IN TOTAL",
                                      style: TextStyle(
                                        fontFamily: 'YK',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      )),
                                  Text('$healedSoFar',
                                      style: TextStyle(
                                        fontFamily: 'YK',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                      ))
                                ],
                              )
                          )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.brown[500],
                            borderRadius: BorderRadius.circular(10)
                          ),
                          width: 310,
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                          child: Center(
                            child: Text('$tally TOTAL CASES IN ${countryList[selectedCountry].nation.toUpperCase()}',
                                style: TextStyle(
                                  fontFamily: 'YK',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                )),
                          )
                        )
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }
}