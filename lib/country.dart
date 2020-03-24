import 'package:http/http.dart';
import 'dart:convert';
import 'package:jiffy/jiffy.dart';

class Country {

  String nation;
  String diedToday;
  String diedSoFar;
  String illToday;
  String illSoFar;
  String healedUpToYesterday;
  String healedToday;
  String healedSoFar;
  String tally;

  Country({ this.nation });

  Future<void> getDataLatestStatByCountry() async {

    String today = Jiffy().format('yyyy-MM-dd');
    print(today);
    String yesterday = Jiffy().subtract(days: 1).toString().substring(0, 10);
    print(yesterday);
    //DateTime yesterday = DateTime.now()(date.year, date.month, date.day - 1);
    //String formattedDate = DateFormat('yyyy-MM-dd').format(today);

    Response responseToday = await get('https://coronavirus-monitor.p.rapidapi.com/coronavirus/history_by_country_and_date.php?country=${this.nation}&date=2020-03-24', headers: {"x-rapidapi-key": "558013d577mshda14e3082866bccp17df82jsncdc9b261bdcc"});
    Map dataToday = jsonDecode(responseToday.body);
    print(dataToday);

    Response responseYesterday = await get('https://coronavirus-monitor.p.rapidapi.com/coronavirus/history_by_country_and_date.php?country=${this.nation}&date=$yesterday', headers: {"x-rapidapi-key": "558013d577mshda14e3082866bccp17df82jsncdc9b261bdcc"});
    Map dataYesterday = jsonDecode(responseYesterday.body);

    diedToday= dataToday['stat_by_country'][0]['new_deaths'];
    diedSoFar = dataToday['stat_by_country'][0]['total_deaths'];
    illToday = dataToday['stat_by_country'][0]['new_cases'];
    illSoFar = dataToday['stat_by_country'][0]['active_cases'];
    healedSoFar = dataToday['stat_by_country'][0]['total_recovered'];
    healedUpToYesterday = dataYesterday['stat_by_country'][0]['total_recovered'];
    healedToday = (int.parse(healedSoFar.replaceAll(new RegExp(r','), '')) - int.parse(healedUpToYesterday.replaceAll(new RegExp(r','), ''))).toString();
    tally = dataToday['stat_by_country'][0]['total_cases'];

  }

}