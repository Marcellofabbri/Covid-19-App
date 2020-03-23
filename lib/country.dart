import 'package:http/http.dart';
import 'dart:convert';

class Country {

  String nation;
  String diedToday;
  String diedSoFar;

  Country({ this.nation });

  Future<void> getData() async {

    Response response = await get('https://coronavirus-monitor.p.rapidapi.com/coronavirus/latest_stat_by_country.php?country=${this.nation}', headers: {"x-rapidapi-key": "558013d577mshda14e3082866bccp17df82jsncdc9b261bdcc"});
    Map data = jsonDecode(response.body);

    diedToday = data['latest_stat_by_country'][0]['new_deaths'];
    diedSoFar = data['latest_stat_by_country'][0]['total_deaths'];

  }

}