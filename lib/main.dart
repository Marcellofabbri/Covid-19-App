import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19app/country.dart';
import 'package:covid19app/loader.dart';
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

  List<Country> countryList = [];
  int selectedCountry = 0;
  Map dataToday;
  List<Map> cardInfo = [
    {
      'title' : 'DIED TODAY',
      'number' : 5
    },
    {
      'title' : 'DIED IN TOTAL',
      'number' : 5
    },
    {
      'title' : 'FELL ILL TODAY',
      'number' : 5
    },
    {
      'title' : 'ILL AT THE MOMENT',
      'number' : 5
    },
    {
      'title' : 'RECOVERED SO FAR',
      'number' : 5
    },
    {
      'title' : 'TOTAL CASES IN SPAIN',
      'number' :
      5
    }
  ];

  setCountry(index) {
    selectedCountry = index;
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

  @override
  void initState() {
    super.initState();
    this.selectedCountry = 0;
    createCountryList();
    loadUp();
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        populateCountryList(dataToday);
      });
    });
  }

  Future loadUp() async {
    dataToday = await getData();
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
          child: Text('RECORDS UPDATED AT ${countryList[selectedCountry].timeStamp}',
            style: TextStyle(
              letterSpacing: 0.0,
              fontFamily: 'YK',
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
                                      return new Card(
                                        color: Colors.brown[900].withOpacity(0.005 * index),
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
                                              build(context);
                                            }
                                        ),
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 0.0),
                                              width: 130.0,
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
                  Container(
                    height: 300,
                    margin: EdgeInsets.fromLTRB(33, 40, 33, 0),
                    child: ListView(
                      children: List.generate(6, (int index) {
                        return Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB((index * 15.0), 0, 0, 0),
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                              alignment: AlignmentDirectional.center,
                              height: 49,
                              color: Colors.black26,
                              child: Text('DIED TODAY',
                                style: TextStyle(
                                  fontFamily: 'YK',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                                )
                            )
                            )
                          ],
                        );
                      })
                    ),
                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Center(
//                        child: Container(
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(10),
//                            color: Colors.grey[900]
//                          ),
//                          alignment: Alignment.center,
//                          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
//                          width: 130.0,
//                          child:
//                            Column(
//                              children: <Widget>[
//                                Text("DIED TODAY",
//                                  style: TextStyle(
//                                    fontFamily: 'YK',
//                                    color: Colors.white,
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 20.0,
//                                  )),
//                                Text("${countryList[selectedCountry].diedToday}",
//                                    style: TextStyle(
//                                      fontFamily: 'YK',
//                                      color: Colors.white,
//                                      fontWeight: FontWeight.bold,
//                                      fontSize: 25.0,
//                                    ))
//                              ],
//                            )
//                        )
//                      ),
//                      Center(
//                        child: Container(
//                          alignment: Alignment.center,
//                          decoration: BoxDecoration(
//                            color: Colors.grey[700],
//                            borderRadius: BorderRadius.circular(10)
//                          ),
//                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
//                          width: 130.0,
//                          child: Column(
//                            children: <Widget>[
//                              Text("DIED SO FAR",
//                                  style: TextStyle(
//                                    fontFamily: 'YK',
//                                    color: Colors.white,
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 20.0,
//                                  )),
//                              Text('${countryList[selectedCountry].diedSoFar}',
//                                  style: TextStyle(
//                                    fontFamily: 'YK',
//                                    color: Colors.white,
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 25.0,
//                                  ))
//                            ],
//                          )
//                         )
//                      )
//                    ],
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Center(
//                        child: Container(
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(10),
//                            color: Colors.deepOrange[900]
//                          ),
//                          alignment: Alignment.center,
//                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
//                          width: 130.0,
//                          child: Column(
//                            children: <Widget>[
//                              Text("FALLEN ILL TODAY",
//                                  style: TextStyle(
//                                    fontFamily: 'YK',
//                                    color: Colors.white,
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 20.0,
//                                  )),
//                              Text('${countryList[selectedCountry].illToday}',
//                                  style: TextStyle(
//                                    fontFamily: 'YK',
//                                    color: Colors.white,
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 25.0,
//                                  ))
//                            ],
//                          )
//                        )
//                      ),
//                      Center(
//                        child: Container(
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(10),
//                            color: Colors.deepOrange[700]
//                          ),
//                          alignment: Alignment.center,
//                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
//                          width: 130.0,
//                          child: Column(
//                            children: <Widget>[
//                              Text("CURRENTLY ILL",
//                                  style: TextStyle(
//                                    fontFamily: 'YK',
//                                    color: Colors.white,
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 20.0,
//                                  )),
//                              Text('${countryList[selectedCountry].illSoFar}',
//                                  style: TextStyle(
//                                    fontFamily: 'YK',
//                                    color: Colors.white,
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 25.0,
//                                  ))
//                            ],
//                          )
//                        )
//                      )
//                    ],
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Center(
//                          child: Container(
//                              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(10),
//                                color: Colors.lightGreen[800]
//                              ),
//                              alignment: Alignment.center,
//                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
//                              width: 130.0,
//                              child: Column(
//                                children: <Widget>[
//                                  Text("HEALED TODAY",
//                                      style: TextStyle(
//                                        fontFamily: 'YK',
//                                        color: Colors.white,
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 20.0,
//                                      )),
//                                  Text('healed today',
//                                      style: TextStyle(
//                                        fontFamily: 'YK',
//                                        color: Colors.white,
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 25.0,
//                                      ))
//                                ],
//                              )
//                          )
//                      ),
//                      Center(
//                          child: Container(
//                              decoration: BoxDecoration(
//                                color: Colors.lightGreen[600],
//                                borderRadius: BorderRadius.circular(10)
//                              ),
//                              alignment: Alignment.center,
//                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
//                              width: 130.0,
//                              child: Column(
//                                children: <Widget>[
//                                  Text("HEALED IN TOTAL",
//                                      style: TextStyle(
//                                        fontFamily: 'YK',
//                                        color: Colors.white,
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 20.0,
//                                      )),
//                                  Text('${countryList[selectedCountry].healedSoFar}',
//                                      style: TextStyle(
//                                        fontFamily: 'YK',
//                                        color: Colors.white,
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 25.0,
//                                      ))
//                                ],
//                              )
//                          )
//                      )
//                    ],
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Center(
//                        child: Container(
//                          decoration: BoxDecoration(
//                            color: Colors.brown[500],
//                            borderRadius: BorderRadius.circular(10)
//                          ),
//                          width: 310,
//                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
//                          child: Center(
//                            child: Text('${countryList[selectedCountry].tally} TOTAL CASES IN ${countryList[selectedCountry].nation.toUpperCase()}',
//                                style: TextStyle(
//                                  fontFamily: 'YK',
//                                  color: Colors.white,
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: 24.0,
//                                )),
//                          )
//                        )
//                      )
//                    ],
//                  )
                ],
              ),
      ),
    );
  }
}