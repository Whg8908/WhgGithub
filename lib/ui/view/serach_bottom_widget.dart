import 'package:flutter/material.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/ui/view/repository_issue_list_header.dart';
import 'package:github/ui/view/whg_search_input_widget.dart';

class SearchBottom extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<String> onChanged;

  final ValueChanged<String> onSubmitted;

  final SelectItemChanged selectItemChanged;

  SearchBottom(this.onChanged, this.onSubmitted, this.selectItemChanged);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        WhgSearchInputWidget(onChanged, onSubmitted),
        new WhgSelectItemWidget(
          [
            WhgStrings.search_tab_repos,
            WhgStrings.search_tab_user,
          ],
          selectItemChanged,
          margin: const EdgeInsets.only(top: 10.0),
        )
      ],
    );
  }

  @override
  Size get preferredSize {
    return new Size.fromHeight(100.0);
  }
}
