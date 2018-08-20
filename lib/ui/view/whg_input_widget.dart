import 'package:flutter/material.dart';

class WhgInputWidget extends StatefulWidget {
  final String hintText;
  final IconData iconData;

  WhgInputWidget({Key key, this.hintText, this.iconData}) : super(key: key);

  @override
  WhgInputWidgetState createState() =>
      new WhgInputWidgetState(hintText, iconData);
}

class WhgInputWidgetState extends State<WhgInputWidget> {
  final String hintText;
  final IconData iconData;
  final TextEditingController _controller = TextEditingController();

  WhgInputWidgetState(this.hintText, this.iconData) : super();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: hintText,
        icon: Icon(iconData),
      ),
    );
  }
}
