import 'package:flutter/material.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/ui/view/card_item.dart';
import 'package:github/ui/view/whg_input_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/29
 *
 * @Description IssueEditDialog
 *
 * PS: Stay hungry,Stay foolish.
 */

class IssueEditDialog extends StatefulWidget {
  final String dialogTitle;

  final ValueChanged<String> onTitleChanged;

  final ValueChanged<String> onContentChanged;

  final VoidCallback onPressed;

  final TextEditingController titleController;

  final TextEditingController valueController;

  final bool needTitle;

  IssueEditDialog(this.dialogTitle, this.onContentChanged, this.onTitleChanged,
      this.onPressed,
      {this.titleController, this.valueController, this.needTitle = true});

  @override
  IssueEditDialogState createState() => IssueEditDialogState(
      this.dialogTitle,
      this.onContentChanged,
      this.onTitleChanged,
      this.onPressed,
      titleController,
      valueController,
      needTitle);
}

class IssueEditDialogState extends State<IssueEditDialog> {
  final String dialogTitle;

  final ValueChanged<String> onTitleChanged;

  final ValueChanged<String> onContentChanged;

  final VoidCallback onPressed;

  final TextEditingController titleController;

  final TextEditingController valueController;

  final bool needTitle;

  IssueEditDialogState(
      this.dialogTitle,
      this.onContentChanged,
      this.onTitleChanged,
      this.onPressed,
      this.titleController,
      this.valueController,
      this.needTitle);

  @override
  Widget build(BuildContext context) {
    Widget title = (needTitle)
        ? new Padding(
            padding: new EdgeInsets.all(5.0),
            child: new WhgInputWidget(
              onChange: onTitleChanged,
              controller: titleController,
              hintText: WhgStrings.issue_edit_issue_title_tip,
              obscureText: false,
            ))
        : new Container();
    return new Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black12,
      child: new GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new Center(
          child: new WhgCardItem(
            margin: EdgeInsets.all(50.0),
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: new Padding(
              padding: new EdgeInsets.all(12.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Padding(
                      padding: new EdgeInsets.only(top: 5.0, bottom: 15.0),
                      child: new Center(
                        child: new Text(dialogTitle,
                            style: WhgConstant.normalTextBold),
                      )),
                  renderTitleInput(),
                  new Container(
                    height: MediaQuery.of(context).size.width * 3 / 4,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      color: Color(WhgColors.white),
                      border: new Border.all(
                          color: Color(WhgColors.subTextColor), width: .3),
                    ),
                    padding: new EdgeInsets.only(
                        left: 20.0, top: 12.0, right: 20.0, bottom: 12.0),
                    child: new Column(
                      children: <Widget>[
                        new Expanded(
                          child: new TextField(
                            autofocus: false,
                            maxLines: 999,
                            onChanged: onContentChanged,
                            controller: valueController,
                            decoration: new InputDecoration.collapsed(
                              hintText: WhgStrings.issue_edit_issue_title_tip,
                              hintStyle: WhgConstant.middleSubText,
                            ),
                            style: WhgConstant.middleText,
                          ),
                        ),

                        ///快速输入框
                        _renderFastInputContainer(),
                      ],
                    ),
                  ),
                  new Container(height: 10.0),
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(
                          child: new RawMaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.all(4.0),
                              constraints: const BoxConstraints(
                                  minWidth: 0.0, minHeight: 0.0),
                              child: new Text(WhgStrings.app_cancel,
                                  style: WhgConstant.normalSubText),
                              onPressed: () {
                                Navigator.pop(context);
                              })),
                      new Container(
                          width: 0.3,
                          height: 25.0,
                          color: Color(WhgColors.subTextColor)),
                      new Expanded(
                          child: new RawMaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.all(4.0),
                              constraints: const BoxConstraints(
                                  minWidth: 0.0, minHeight: 0.0),
                              child: new Text(WhgStrings.app_ok,
                                  style: WhgConstant.normalTextBold),
                              onPressed: onPressed)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///标题输入框
  renderTitleInput() {
    return (needTitle)
        ? new Padding(
            padding: new EdgeInsets.all(5.0),
            child: new WhgInputWidget(
              onChange: onTitleChanged,
              controller: titleController,
              hintText: WhgStrings.issue_edit_issue_title_tip,
              obscureText: false,
            ))
        : new Container();
  }

  ///快速输入框
  _renderFastInputContainer() {
    ///因为是Column下包含了ListView，所以需要设置高度
    return new Container(
      height: 30.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return new RawMaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
              constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
              child: Icon(FAST_INPUT_LIST[index].iconData, size: 16.0),
              onPressed: () {
                String text = FAST_INPUT_LIST[index].content;
                String newText = "";
                if (valueController.value != null) {
                  newText = valueController.value.text;
                }
                newText = newText + text;
                setState(() {
                  valueController.value = new TextEditingValue(text: newText);
                });
                if (onContentChanged != null) {
                  onContentChanged(newText);
                }
              });
        },
        itemCount: FAST_INPUT_LIST.length,
      ),
    );
  }
}

var FAST_INPUT_LIST = [
  FastInputIconModel(WhgICons.ISSUE_EDIT_H1, "\n# "),
  FastInputIconModel(WhgICons.ISSUE_EDIT_H2, "\n## "),
  FastInputIconModel(WhgICons.ISSUE_EDIT_H3, "\n### "),
  FastInputIconModel(WhgICons.ISSUE_EDIT_BOLD, "****"),
  FastInputIconModel(WhgICons.ISSUE_EDIT_ITALIC, "__"),
  FastInputIconModel(WhgICons.ISSUE_EDIT_QUOTE, "` `"),
  FastInputIconModel(WhgICons.ISSUE_EDIT_CODE, " \n``` \n\n``` \n"),
  FastInputIconModel(WhgICons.ISSUE_EDIT_LINK, "[](url)"),
];

class FastInputIconModel {
  final IconData iconData;
  final String content;

  FastInputIconModel(this.iconData, this.content);
}
