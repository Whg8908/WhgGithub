import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:github/common/style/whg_string_base.dart';
import 'package:github/common/style/whg_string_en.dart';
import 'package:github/common/style/whg_string_zh.dart';

class WhgLocalizations {
  final Locale locale;

  WhgLocalizations(this.locale);

  static Map<String, WhgStringBase> _localizedValues = {
    'en': new WhgStringEn(),
    'zh': new WhgStringZh(),
  };

  WhgStringBase get currentLocalized {
    print("++++++++++++++++++++++++++++++++++");
    print(locale.languageCode);
    print("++++++++++++++++++++++++++++++++++");
    return _localizedValues[locale.languageCode];
  }

  static WhgLocalizations of(BuildContext context) {
    return Localizations.of(context, WhgLocalizations);
  }
}
