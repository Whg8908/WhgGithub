import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/commonutils.dart';
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
  final String markdownData;
  final int style;

  WhgMarkdownWidget({this.markdownData = "", this.style = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: style == 0
            ? Color(WhgColors.white)
            : Color(WhgColors.primaryLightValue),
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: MarkdownBody(
            styleSheet: style == 0
                ? _getStyleSheetWhite(context)
                : _getStyleSheetDark(context),
            syntaxHighlighter: new WhgHighlighter(),
            data: markdownData,
            onTapLink: (String source) {
              CommonUtils.launchUrl(context, source);
            },
          ),
        ));
  }

  _getCommonSheet(BuildContext context) {
    MarkdownStyleSheet markdownStyleSheet =
        MarkdownStyleSheet.fromTheme(Theme.of(context));
    return markdownStyleSheet
        .copyWith(
            codeblockDecoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: Color(WhgColors.primaryValue),
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
    return _getCommonSheet(context).copyWith(
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
    return _getCommonSheet(context).copyWith(
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
