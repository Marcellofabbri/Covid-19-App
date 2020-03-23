import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19app/country.dart';

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
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 30.0, 0, 30.0),
                        color: Colors.amberAccent,
                        child:
                          Text('Pick country'),
                      ),
                    )
                  ]
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.grey[700],
                        padding: EdgeInsets.all(30.0),
                        child:
                          Text("Died today")
                      )
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[600],
                        padding: EdgeInsets.all(30.0),
                        child: Text("Died so far: ${diedSoFar}")
                       )
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.red[700],
                        padding: EdgeInsets.all(30.0),
                        child: Text("Fallen ill today")
                      )
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.red[600],
                        padding: EdgeInsets.all(30.0),
                        child: Text("Fallen ill at present")
                      )
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                            color: Colors.cyan[700],
                            padding: EdgeInsets.all(30.0),
                            child: Text("Healed today")
                        )
                    ),
                    Expanded(
                        child: Container(
                            color: Colors.cyan[500],
                            padding: EdgeInsets.all(30.0),
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

