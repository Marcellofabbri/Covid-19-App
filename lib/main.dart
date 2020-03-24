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
    Country(nation: 'Germany')
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
        backgroundColor: Colors.orange[900]
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('RECORDS UPDATED AT $timeStamp',
            style: TextStyle(
              letterSpacing: 3.0,
              fontFamily: 'YK',
              fontSize: 20.0,
              color: Colors.white
            )),
        )
      ),
      body: Column(
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
                                      color: Colors.amber[index * 100],
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            alignment: AlignmentDirectional.centerEnd,
                                            width: 30.0,
                                            height: 30.0,
                                            child: new RaisedButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedCountry = index;
                                                });
                                                setCountry();
                                                build(context);
                                                print(index);
                                              },
                                              color: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              )
                                            ),
                                          ),
                                          new Container(
                                            padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                                            width: 100.0,
                                          alignment: AlignmentDirectional.centerStart,
                                          height: 50.0,
                                          child: new Text('${countryList[index].nation}',
                                              style: TextStyle(
                                                fontFamily: 'YK',
                                                color: Colors.orange[900],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25.0,
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
                        alignment: Alignment.center,
                        color: Colors.grey[700],
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
                                  fontSize: 25.0,
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
                        color: Colors.grey[600],
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                        width: 130.0,
                        child: Column(
                          children: <Widget>[
                            Text("DIED SO FAR",
                                style: TextStyle(
                                  fontFamily: 'YK',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
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
                        alignment: Alignment.center,
                        color: Colors.red[700],
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                        width: 130.0,
                        child: Column(
                          children: <Widget>[
                            Text("FALLEN ILL TODAY",
                                style: TextStyle(
                                  fontFamily: 'YK',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
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
                        alignment: Alignment.center,
                        color: Colors.red[600],
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                        width: 130.0,
                        child: Column(
                          children: <Widget>[
                            Text("CURRENTLY ILL",
                                style: TextStyle(
                                  fontFamily: 'YK',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
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
                            alignment: Alignment.center,
                            color: Colors.cyan[700],
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                            width: 130.0,
                            child: Column(
                              children: <Widget>[
                                Text("HEALED TODAY",
                                    style: TextStyle(
                                      fontFamily: 'YK',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
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
                            alignment: Alignment.center,
                            color: Colors.cyan[500],
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                            width: 130.0,
                            child: Column(
                              children: <Widget>[
                                Text("HEALED IN TOTAL",
                                    style: TextStyle(
                                      fontFamily: 'YK',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
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
                        color: Colors.orange[900],
                        width: 330,
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                        child: Center(
                          child: Text('$tally TOTAL CASES IN ${countryList[selectedCountry].nation.toUpperCase()}',
                              style: TextStyle(
                                fontFamily: 'YK',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                              )),
                        )
                      )
                    )
                  ],
                )
              ],
            ),
    );
  }
}

