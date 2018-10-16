import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:github/common/delegate/whg_localizations.dart';

class WhgLocalizationsDelegate extends LocalizationsDelegate<WhgLocalizations> {
  WhgLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<WhgLocalizations> load(Locale locale) {
    return new SynchronousFuture<WhgLocalizations>(
        new WhgLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<WhgLocalizations> old) {
    return false;
  }

  static WhgLocalizationsDelegate delegate = new WhgLocalizationsDelegate();
}
