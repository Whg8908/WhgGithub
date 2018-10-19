import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:github/common/style/whg_string_base.dart';
import 'package:github/common/style/whg_string_en.dart';
import 'package:github/common/style/whg_string_zh.dart';

///自定义多语言实现
class WhgLocalizations {
  final Locale locale;

  WhgLocalizations(this.locale);

  ///根据不同 locale.languageCode 加载不同语言对应
  ///WhgStringEn和GSYStringZh都继承了WhgStringBase
  static Map<String, WhgStringBase> _localizedValues = {
    'en': new WhgStringEn(),
    'zh': new WhgStringZh(),
  };

  WhgStringBase get currentLocalized {
    return _localizedValues[locale.languageCode];
  }

  ///通过 Localizations 加载当前的 WhgLocalizations
  ///获取对应的 WhgStringBase
  static WhgLocalizations of(BuildContext context) {
    return Localizations.of(context, WhgLocalizations);
  }
}
