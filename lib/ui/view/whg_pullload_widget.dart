import 'package:flutter/material.dart';
import 'package:whg_github/common/style/whg_style.dart';
/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description  上拉刷新下拉加载控件
 *
 * PS: Stay hungry,Stay foolish.
 */

class WhgPullLoadWidget extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;

  final RefreshCallback onRefresh;
  final RefreshCallback onLoadMore;

  final WhgPullLoadWidgetControl control;

  WhgPullLoadWidget(
      this.itemBuilder, this.onRefresh, this.onLoadMore, this.control);

  @override
  WhgPullLoadWidgetState createState() => WhgPullLoadWidgetState(
      this.itemBuilder, this.onRefresh, this.onLoadMore, this.control);
}

class WhgPullLoadWidgetState extends State<WhgPullLoadWidget> {
  final IndexedWidgetBuilder itemBuilder;

  final RefreshCallback onRefresh;
  final RefreshCallback onLoadMore;

  WhgPullLoadWidgetControl control;

  WhgPullLoadWidgetState(
      this.itemBuilder, this.onRefresh, this.onLoadMore, this.control);

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (this.onLoadMore != null && this.control.needLoadMore) {
          this.onLoadMore();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == control.dataList.length &&
              control.dataList.length != 0) {
            return _buildProgressIndicator();
          } else {
            return itemBuilder(context, index);
          }
        },
        itemCount: _getListCount(),
        controller: scrollController,
      ),
    );
  }

  _getListCount() {
    if (control.needHeader) {
      return (control.dataList.length > 0)
          ? control.dataList.length + 2
          : control.dataList.length + 1;
    } else {
      return (control.dataList.length > 0)
          ? control.dataList.length + 1
          : control.dataList.length;
    }
  }

  /*
  * 加载进度条
  * */
  Widget _buildProgressIndicator() {
    Widget bottomWidget = (control.needLoadMore)
        ? new CircularProgressIndicator()
        : new Text(WhgStrings.load_more_not);
    return new Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Center(
        child: bottomWidget,
      ),
    );
  }
}

class WhgPullLoadWidgetControl {
  List dataList = new List();
  bool needLoadMore = true;
  bool needHeader = false;
}
