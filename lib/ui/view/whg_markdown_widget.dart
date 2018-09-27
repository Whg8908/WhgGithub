import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/8
 *
 * @Description 自定义markdownwidget
 *
 * PS: Stay hungry,Stay foolish.
 */

class WhgMarkdownWidget extends StatelessWidget {
  static const int DARK_WHITE = 0;

  static const int DARK_LIGHT = 1;

  static const int DARK_THEME = 2;

  final String markdownData;
  final int style;

  WhgMarkdownWidget({this.markdownData = "", this.style = DARK_WHITE});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: _getBackgroundColor(),
        child: SingleChildScrollView(
          child: MarkdownBody(
            styleSheet: _getStyle(context),
            syntaxHighlighter: new WhgHighlighter(),
            data: markdownData,
            onTapLink: (String source) {
              CommonUtils.launchUrl(context, source);
            },
          ),
        ));
  }

  _getStyleSheetTheme(BuildContext context) {
    return _getCommonSheet(context, Color(WhgColors.subTextColor)).copyWith(
      p: WhgConstant.smallTextWhite,
      h1: WhgConstant.largeLargeTextWhite,
      h2: WhgConstant.largeTextWhite,
      h3: WhgConstant.normalTextWhite,
      h4: WhgConstant.middleTextWhite,
      h5: WhgConstant.smallTextWhite,
      h6: WhgConstant.smallTextWhite,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: WhgConstant.middleTextWhite,
      code: WhgConstant.subSmallText,
    );
  }

  _getBackgroundColor() {
    Color background = Color(WhgColors.white);
    switch (style) {
      case DARK_LIGHT:
        background = Color(WhgColors.primaryLightValue);
        break;
      case DARK_THEME:
        background = Color(WhgColors.primaryValue);
        break;
    }
    return background;
  }

  _getStyle(BuildContext context) {
    var styleSheet = _getStyleSheetWhite(context);
    switch (style) {
      case DARK_LIGHT:
        styleSheet = _getStyleSheetDark(context);
        break;
      case DARK_THEME:
        styleSheet = _getStyleSheetTheme(context);
        break;
    }
    return styleSheet;
  }

  _getCommonSheet(BuildContext context, Color codeBackground) {
    MarkdownStyleSheet markdownStyleSheet =
        MarkdownStyleSheet.fromTheme(Theme.of(context));
    return markdownStyleSheet
        .copyWith(
            codeblockDecoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: codeBackground,
                border: new Border.all(
                    color: Color(WhgColors.subTextColor), width: 0.3)))
        .copyWith(
            blockquoteDecoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: Color(WhgColors.subTextColor),
                border: new Border.all(
                    color: Color(WhgColors.subTextColor), width: 0.3)),
            blockquote: WhgConstant.smallTextWhite);
  }

  _getStyleSheetDark(BuildContext context) {
    return _getCommonSheet(context, Color(WhgColors.primaryValue)).copyWith(
      p: WhgConstant.smallTextWhite,
      h1: WhgConstant.largeLargeTextWhite,
      h2: WhgConstant.largeTextWhite,
      h3: WhgConstant.normalTextWhite,
      h4: WhgConstant.middleTextWhite,
      h5: WhgConstant.smallTextWhite,
      h6: WhgConstant.smallTextWhite,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: WhgConstant.middleTextWhite,
      code: WhgConstant.subSmallText,
    );
  }

  _getStyleSheetWhite(BuildContext context) {
    return _getCommonSheet(context, Color(WhgColors.primaryValue)).copyWith(
      p: WhgConstant.smallText,
      h1: WhgConstant.largeLargeText,
      h2: WhgConstant.largeText,
      h3: WhgConstant.normalText,
      h4: WhgConstant.middleText,
      h5: WhgConstant.smallText,
      h6: WhgConstant.smallText,
      strong: WhgConstant.middleText,
      code: WhgConstant.subSmallText,
    );
  }
}

class WhgHighlighter extends SyntaxHighlighter {
  @override
  TextSpan format(String source) {
    return new TextSpan(
      text: source,
      style: WhgConstant.smallTextWhite,
    );
  }
}
