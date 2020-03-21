import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatelessWidget {
  @override //redefines the build method otherwise inherited from StatelessWidget
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
      body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  color: Colors.grey[600],
                  padding: EdgeInsets.all(30.0),
                  child: Text("Died today")
                ),
                Container(
                  padding: EdgeInsets.all(30.0),
                  color: Colors.redAccent[100],
                  child: Text("Infected today")
                ),
                Container(
                  padding: EdgeInsets.all(30.0),
                  color: Colors.yellow[300],
                  child: Text("Healed today")
                )
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  color: Colors.grey[600],
                  padding: EdgeInsets.all(30.0),
                  child: Text("Died in total")
                ),
                Container(
                  padding: EdgeInsets.all(30.0),
                  color: Colors.redAccent[100],
                  child: Text("Infected in total")
                ),
                Container(
                  padding: EdgeInsets.all(30.0),
                  color: Colors.yellow[300],
                  child: Text("Healed in total")
                )
              ],
            )
          ]
      ),
    );
  }
}

