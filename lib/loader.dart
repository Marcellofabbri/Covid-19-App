import 'package:http/http.dart';
import 'dart:convert';

class Loader {

  Map dataToday = {};
  Map historicData = {};

  Loader();

  retrieveFromApi() async {
    Response responseToday = await get(
        'https://covid-193.p.rapidapi.com/statistics', headers: {
      'x-rapidapi-key': '558013d577mshda14e3082866bccp17df82jsncdc9b261bdcc'
    });

    dataToday = jsonDecode(responseToday.body);

  }

  retrieveHistoricData() async {
    Response responseHistoric = await get('https://opendata.ecdc.europa.eu/covid19/casedistribution/json/', headers: {
      'Content-Type': 'application/json; charset=utf-8'
    });
    var body = responseHistoric.body;
    body = body.substring(body.indexOf('{'));
    historicData = jsonDecode(body);
  }

}