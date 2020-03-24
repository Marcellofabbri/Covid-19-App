import 'package:flutter/material.dart';

InkWell(
  child: Container(
    alignment: AlignmentDirectional.centerEnd,
    width: 30.0,
    height: 30.0,
    border: Border.all(color: index == selectedCountry ? Colors.orange[900] : Colors.white, width: index == selectedCountry ? 5.0 : 0.0),
    decoration: BoxDecoration(
      image: AssetImage('assets/flags/germany.jpg'),
      fit: BoxFit.contain
    ),
    onTap: () {
setState(() {
selectedCountry = index;
});
setCountry();
build(context);
}
)