import 'package:github/common/style/whg_style.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/14
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */
class HtmlUtils {
  static generateCode2HTml(String mdData,
      {String backgroundColor = WhgColors.miWhiteString,
      String lang = 'java',
      userBR = true}) {
    String currentData = (mdData != null && mdData.indexOf("<code>") == -1)
        ? "<body>\n" +
            "<pre class=\"pre\">\n" +
            "<code lang='$lang'>\n" +
            mdData +
            "</code>\n" +
            "</pre>\n" +
            "</body>\n"
        : "<body>\n" +
            "<pre class=\"pre\">\n" +
            mdData +
            "</pre>\n" +
            "</body>\n";
    return generateHtml(currentData,
        backgroundColor: backgroundColor, userBR: userBR);
  }

  static generateHtml(String mdData,
      {String backgroundColor = WhgColors.webDraculaBackgroundColorString,
      userBR = true}) {
    if (mdData == null) {
      return "";
    }
    RegExp exp = new RegExp("<code(([\\s\\S])*?)<\/code>");
    Iterable<Match> tags = exp.allMatches(mdData);
    String mdDataCode = mdData;
//    print("---------------------`--------------------------");
//    print(tags);
    for (Match m in tags) {
      print(m.group(0));
      String match = m.group(0).replaceAll(new RegExp("\n"), "\n\r<br>");
      print(match);
      mdDataCode = mdDataCode.replaceAll(m.group(0), match);
    }

    exp = new RegExp("<pre(([\\s\\S])*?)<\/pre>");
    tags = exp.allMatches(mdDataCode);
    for (Match m in tags) {
      if (m.group(0).indexOf("<code>") < 0) {
        String match = m.group(0).replaceAll(new RegExp("\n"), "\n\r<br>");
        mdDataCode = mdDataCode.replaceAll(m.group(0), match);
      }
    }

    exp = new RegExp("<pre>(([\\s\\S])*?)<\/pre>");
    tags = exp.allMatches(mdDataCode);
    for (Match m in tags) {
      if (m.group(0).indexOf("<code>") < 0) {
        String match = m.group(0).replaceAll(new RegExp("\n"), "\n\r<br>");
        mdDataCode = mdDataCode.replaceAll(m.group(0), match);
      }
    }

    exp = new RegExp("href=\"(.*?)\"");
    tags = exp.allMatches(mdDataCode);
    for (Match m in tags) {
      String capture = m.group(0);
      if (capture.indexOf("http://") < 0 &&
          capture.indexOf("https://") < 0 &&
          capture.indexOf("#") != 0) {
        mdDataCode =
            mdDataCode.replaceAll(m.group(0), "gsygithub://" + capture);
      }
    }

    return generateCodeHtml(mdDataCode, false,
        backgroundColor: backgroundColor,
        actionColor: WhgColors.actionBlueString,
        userBR: userBR);
  }

  /**
   * style for mdHTml
   */
  static generateCodeHtml(mdHTML, wrap,
      {backgroundColor = WhgColors.white,
      String actionColor = WhgColors.actionBlueString,
      userBR = true}) {
    return "<html>\n" +
        "<head>\n" +
        "<meta charset=\"utf-8\" />\n" +
        "<title></title>\n" +
        "<meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/>" +
        "<link href=\"https:\/\/cdn.bootcss.com/highlight.js/9.12.0/styles/dracula.min.css\" rel=\"stylesheet\">\n" +
        "<script src=\"https:\/\/cdn.bootcss.com/highlight.js/9.12.0/highlight.min.js\"></script>  " +
        "<script>hljs.configure({'useBR': " +
        userBR.toString() +
        "});hljs.initHighlightingOnLoad();</script> " +
        "<style>" +
        "body{background: " +
        backgroundColor +
        ";}" +
        "a {color:" +
        actionColor +
        " !important;}" +
        ".highlight pre, pre {" +
        " word-wrap: " +
        (wrap ? "break-word" : "normal") +
        "; " +
        " white-space: " +
        (wrap ? "pre-wrap" : "pre") +
        "; " +
        "}" +
        "thead, tr {" +
        "background:" +
        WhgColors.miWhiteString +
        ";}" +
        "td, th {" +
        "padding: 5px 10px;" +
        "font-size: 12px;" +
        "direction:hor" +
        "}" +
        ".highlight {overflow: scroll; background: " +
        WhgColors.miWhiteString +
        "}" +
        "tr:nth-child(even) {" +
        "background:" +
        WhgColors.primaryLightValueString +
        ";" +
        "color:" +
        WhgColors.miWhiteString +
        ";" +
        "}" +
        "tr:nth-child(odd) {" +
        "background: " +
        WhgColors.miWhiteString +
        ";" +
        "color:" +
        WhgColors.primaryLightValueString +
        ";" +
        "}" +
        "th {" +
        "font-size: 14px;" +
        "color:" +
        WhgColors.miWhiteString +
        ";" +
        "background:" +
        WhgColors.primaryLightValueString +
        ";" +
        "}" +
        "</style>" +
        "</head>\n" +
        "<body>\n" +
        mdHTML +
        "</body>\n" +
        "</html>";
  }

  static parseDiffSource(String diffSource, bool wrap) {
    if (diffSource == null) {
      return "";
    }
    List<String> lines = diffSource.split("\n");
    String source = "";
    int addStartLine = -1;
    int removeStartLine = -1;
    int addLineNum = 0;
    int removeLineNum = 0;
    int normalLineNum = 0;
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String lineNumberStr = "";
      String classStr = "";
      int curAddNumber = -1;
      int curRemoveNumber = -1;

      if (line.indexOf("+") == 0) {
        classStr = "class=\"hljs-addition\";";
        curAddNumber = addStartLine + normalLineNum + addLineNum;
        addLineNum++;
      } else if (line.indexOf("-") == 0) {
        classStr = "class=\"hljs-deletion\";";
        curRemoveNumber = removeStartLine + normalLineNum + removeLineNum;
        removeLineNum++;
      } else if (line.indexOf("@@") == 0) {
        classStr = "class=\"hljs-literal\";";
        removeStartLine = getRemoveStartLine(line);
        addStartLine = getAddStartLine(line);
        addLineNum = 0;
        removeLineNum = 0;
        normalLineNum = 0;
      } else if (!(line.indexOf("\\") == 0)) {
        curAddNumber = addStartLine + normalLineNum + addLineNum;
        curRemoveNumber = removeStartLine + normalLineNum + removeLineNum;
        normalLineNum++;
      }
      lineNumberStr = getDiffLineNumber(
          curRemoveNumber == -1 ? "" : (curRemoveNumber.toString() + ""),
          curAddNumber == -1 ? "" : (curAddNumber.toString() + ""));
      source = source +
          "\n" +
          "<div " +
          classStr +
          ">" +
          (wrap ? "" : lineNumberStr + getBlank(1)) +
          line +
          "</div>";
    }
    return source;
  }

  static getRemoveStartLine(line) {
    try {
      return int.parse(
          line.substring(line.indexOf("-") + 1, line.indexOf(",")));
    } catch (e) {
      return 1;
    }
  }

  static getAddStartLine(line) {
    try {
      return int.parse(line.substring(
          line.indexOf("+") + 1, line.indexOf(",", line.indexOf("+"))));
    } catch (e) {
      return 1;
    }
  }

  static getDiffLineNumber(String removeNumber, String addNumber) {
    int minLength = 4;
    return getBlank(minLength - removeNumber.length) +
        removeNumber +
        getBlank(1) +
        getBlank(minLength - addNumber.length) +
        addNumber;
  }

  static getBlank(num) {
    String builder = "";
    for (int i = 0; i < num; i++) {
      builder += " ";
    }
    return builder;
  }

  static resolveHtmlFile(var res, String defaultLang) {
    if (res != null && res.result) {
      String startTag = "class=\"instapaper_body ";
      int startLang = res.data.indexOf(startTag);
      int endLang = res.data.indexOf("\" data-path=\"");
      String lang;
      if (startLang >= 0 && endLang >= 0) {
        String tmpLang =
            res.data.substring(startLang + startTag.length, endLang);
        if (tmpLang != null) {
          lang = formName(tmpLang.toLowerCase());
        }
      }
      if (lang == null) {
        lang = defaultLang;
      }
      if ('markdown' == lang) {
        return generateHtml(res.data, backgroundColor: WhgColors.miWhiteString);
      } else {
        return generateCode2HTml(res.data,
            backgroundColor: WhgColors.webDraculaBackgroundColorString,
            lang: lang);
      }
    } else {
      return "<h1>" + "Not Support" + "</h1>";
    }
  }

  static formName(name) {
    switch (name) {
      case 'sh':
        return 'shell';
      case 'js':
        return 'javascript';
      case 'kt':
        return 'kotlin';
      case 'c':
      case 'cpp':
        return 'cpp';
      case 'md':
        return 'markdown';
      case 'html':
        return 'xml';
    }
    return name;
  }
}
