import 'package:covid19app/loader.dart';

class Country {
  
  var dataToday = {};
  int index;
  String nation = 'LOADING';
  String diedToday = 'LOADING';
  String diedSoFar = 'LOADING';
  String illToday = 'LOADING';
  String illSoFar = 'LOADING';
  String healedSoFar = 'LOADING';
  String tally = 'LOADING';
  String timeStamp = 'LOADING';

  Country( {this.dataToday, this.index} );

  populate() {
    nation = dataToday['response'][index]['country'].toString();
    diedToday = dataToday['response'][index]['deaths']['new'].toString();
    diedSoFar = dataToday['response'][index]['deaths']['total'].toString();
    illToday = dataToday['response'][index]['cases']['new'].toString();
    illSoFar = dataToday['response'][index]['cases']['active'].toString();
    healedSoFar = dataToday['response'][index]['cases']['recovered'].toString();
    tally = dataToday['response'][index]['cases']['total'].toString();
    timeStamp = dataToday['response'][index]['time'].toString();
  }

}