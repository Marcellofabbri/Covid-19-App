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

  void setCountry() async {
    Country countryObject = Country(nation: 'Italy');
    await countryObject.getDataLatestStatByCountry();
    setState(() {
      diedSoFar = countryObject.diedSoFar;
      diedToday = countryObject.diedToday;
      illSoFar = countryObject.illSoFar;
      illToday = countryObject.illToday;
      healedSoFar = countryObject.healedSoFar;
      healedToday = countryObject.healedToday;
    });
  }

  @override
  void initState() {
    super.initState();
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
        child: Text('hello')
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
                                      child: new Container(
                                        height: 50.0,
                                        child: new Text('${countryList[index].nation}'),
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
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                        width: 150.0,
                        child:
                          Column(
                            children: <Widget>[
                              Text("Died today"),
                              Text("$diedToday")
                            ],
                          )
                      )
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey[600],
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                        width: 150.0,
                        child: Column(
                          children: <Widget>[
                            Text("Died so far"),
                            Text('$diedSoFar')
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
                        width: 150.0,
                        child: Column(
                          children: <Widget>[
                            Text("Fallen ill today"),
                            Text('$illToday')
                          ],
                        )
                      )
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.red[600],
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                        width: 150.0,
                        child: Column(
                          children: <Widget>[
                            Text("Currently ill"),
                            Text('$illSoFar')
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
                            width: 150.0,
                            child: Column(
                              children: <Widget>[
                                Text("Healed today"),
                                Text('$healedToday')
                              ],
                            )
                        )
                    ),
                    Center(
                        child: Container(
                            alignment: Alignment.center,
                            color: Colors.cyan[500],
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                            width: 150.0,
                            child: Column(
                              children: <Widget>[
                                Text("Healed in total"),
                                Text('$healedSoFar')
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
                        color: Colors.green[800],
                        width: 330,
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
                        child: Text('Data updated at')
                      )
                    )
                  ],
                )
              ],
            ),
    );
  }
}

