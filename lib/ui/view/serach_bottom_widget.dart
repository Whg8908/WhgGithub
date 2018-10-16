import 'package:flutter/material.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/ui/view/repository_issue_list_header.dart';
import 'package:github/ui/view/whg_search_input_widget.dart';

class SearchBottom extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<String> onChanged;

  final ValueChanged<String> onSubmitted;

  final VoidCallback onSubmitPressed;

  final SelectItemChanged selectItemChanged;

  SearchBottom(this.onChanged, this.onSubmitted, this.onSubmitPressed,
      this.selectItemChanged);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        WhgSearchInputWidget(onChanged, onSubmitted, onSubmitPressed),
        new WhgSelectItemWidget(
          [
            CommonUtils.getLocale(context).search_tab_repos,
            CommonUtils.getLocale(context).search_tab_user,
          ],
          selectItemChanged,
          elevation: 0.0,
          margin: const EdgeInsets.all(5.0),
        )
      ],
    );
  }

  @override
  Size get preferredSize {
    return new Size.fromHeight(100.0);
  }
}
