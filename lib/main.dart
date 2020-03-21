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
      body: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.grey[700],
                        padding: EdgeInsets.all(30.0),
                        child: Text("Died today")
                      )
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[600],
                        padding: EdgeInsets.all(30.0),
                        child: Text("Died so far")
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

