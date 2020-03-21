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
      )
    );
  }
}

