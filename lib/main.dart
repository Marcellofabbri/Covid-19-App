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

  void setCountry() async {
    Country countryObject = Country(nation: 'Italy');
    await countryObject.getData();
    setState(() {
      diedSoFar = countryObject.diedSoFar;
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
      body: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 250.0,
                        child: ListView(
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
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
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey[700],
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30.0),
                        width: 150.0,
                        child:
                          Text("Died today")
                      )
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey[600],
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30.0),
                        width: 150.0,
                        child: Text("Died so far: $diedSoFar")
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
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30.0),
                        width: 150.0,
                        child: Text("Fallen ill today")
                      )
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.red[600],
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30.0),
                        width: 150.0,
                        child: Text("Fallen ill at present")
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
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30.0),
                            width: 150.0,
                            child: Text("Healed today")
                        )
                    ),
                    Center(
                        child: Container(
                            alignment: Alignment.center,
                            color: Colors.cyan[500],
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30.0),
                            width: 150.0,
                            child: Text("Healed in total")
                        )
                    )
                  ],
                )
              ],
            ),
    );
  }
}

