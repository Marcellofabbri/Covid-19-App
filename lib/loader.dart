import 'package:http/http.dart';
import 'dart:convert';

class Loader {

  Map dataToday = {};

  Loader();

  retrieveFromApi() async {
    Response responseToday = await get(
        'https://covid-193.p.rapidapi.com/statistics', headers: {
      'x-rapidapi-key': '558013d577mshda14e3082866bccp17df82jsncdc9b261bdcc'
    });

    dataToday = jsonDecode(responseToday.body);

  }

}