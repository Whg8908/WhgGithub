import 'package:github/common/style/whg_style.dart';

class TrendTypeModel {
  final String name;
  final String value;

  TrendTypeModel(this.name, this.value);
}

var TrendTime = [
  TrendTypeModel(WhgStrings.trend_day, "daily"),
  TrendTypeModel(WhgStrings.trend_week, "weekly"),
  TrendTypeModel(WhgStrings.trend_month, "monthly"),
];

var TrendType = [
  TrendTypeModel(WhgStrings.trend_all, null),
  TrendTypeModel("Java", "Java"),
  TrendTypeModel("Kotlin", "Kotlin"),
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
