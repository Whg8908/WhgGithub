import 'package:flutter/material.dart';
import 'package:github/common/utils/commonutils.dart';

class TrendTypeModel {
  final String name;
  final String value;

  TrendTypeModel(this.name, this.value);
}

trendTime(BuildContext context) {
  return [
    new TrendTypeModel(CommonUtils.getLocale(context).trend_day, "daily"),
    new TrendTypeModel(CommonUtils.getLocale(context).trend_week, "weekly"),
    new TrendTypeModel(CommonUtils.getLocale(context).trend_month, "monthly"),
  ];
}

trendType(BuildContext context) {
  return [
    TrendTypeModel(CommonUtils.getLocale(context).trend_all, null),
    TrendTypeModel("Java", "Java"),
    TrendTypeModel("Kotlin", "Kotlin"),
    TrendTypeModel("Dart", "Dart"),
    TrendTypeModel("Objective-C", "Objective-C"),
    TrendTypeModel("Swift", "Swift"),
    TrendTypeModel("JavaScript", "JavaScript"),
    TrendTypeModel("PHP", "PHP"),
    TrendTypeModel("Go", "Go"),
    TrendTypeModel("C++", "C++"),
    TrendTypeModel("C", "C"),
    TrendTypeModel("HTML", "HTML"),
    TrendTypeModel("CSS", "CSS"),
  ];
}
