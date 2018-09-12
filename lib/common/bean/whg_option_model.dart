import 'package:flutter/material.dart';

class WhgOptionModel {
  final String name;
  final String value;
  final PopupMenuItemSelected<WhgOptionModel> selected;

  WhgOptionModel(this.name, this.value, this.selected);
}
