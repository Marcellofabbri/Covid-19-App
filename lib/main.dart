import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void getData() async {

    Response response = await get('https://coronavirus-monitor.p.rapidapi.com/coronavirus/latest_stat_by_country.php?country=Italy', headers: {"x-rapidapi-key": "558013d577mshda14e3082866bccp17df82jsncdc9b261bdcc"});
    Map data = jsonDecode(response.body);
    print(data['latest_stat_by_country'][0]);

  }

  @override
  void initState() {
    super.initState();
    getData();
  }

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
                        child:
                          Text("Died today")
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

