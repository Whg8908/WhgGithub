import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whg_github/common/style/whg_style.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/14
 *
 * @Description 类似于国际化
 *
 * PS: Stay hungry,Stay foolish.
 */
class MaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const MaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'zh';

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return new SynchronousFuture<MaterialLocalizations>(
        const WhgMaterialLocalizations());
  }

  @override
  bool shouldReload(MaterialLocalizationsDelegate old) => false;
}

class WhgMaterialLocalizations extends DefaultMaterialLocalizations {
  const WhgMaterialLocalizations();

  @override
  String get viewLicensesButtonLabel => WhgStrings.app_licenses;

  String get closeButtonLabel => WhgStrings.app_close;
}
