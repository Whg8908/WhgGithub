import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:github/common/style/whg_style.dart';
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
  final Key refreshKey;

  WhgPullLoadWidget(
      this.itemBuilder, this.onRefresh, this.onLoadMore, this.control,
      {this.refreshKey});

  @override
  WhgPullLoadWidgetState createState() => WhgPullLoadWidgetState(
      this.itemBuilder,
      this.onRefresh,
      this.onLoadMore,
      this.control,
      this.refreshKey);
}

class WhgPullLoadWidgetState extends State<WhgPullLoadWidget> {
  final IndexedWidgetBuilder itemBuilder;

  final RefreshCallback onRefresh;
  final RefreshCallback onLoadMore;

  WhgPullLoadWidgetControl control;
  final Key refreshKey;

  WhgPullLoadWidgetState(this.itemBuilder, this.onRefresh, this.onLoadMore,
      this.control, this.refreshKey);

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
      key: refreshKey,
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (!control.needHeader &&
              index == control.dataList.length &&
              control.dataList.length != 0) {
            return _buildProgressIndicator();
          } else if (control.needHeader &&
              index == _getListCount() - 1 &&
              control.dataList.length != 0) {
            return _buildProgressIndicator();
          } else if (!control.needHeader && control.dataList.length == 0) {
            return _buildEmpty();
          } else {
            return itemBuilder(context, index);
          }
        },
        itemCount: _getListCount(),
        controller: scrollController,
      ),
    );
  }

  //空白页面
  Widget _buildEmpty() {
    return new Container(
      height: MediaQuery.of(context).size.height - 100,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: new Image(
                image: new AssetImage(WhgICons.DEFAULT_USER_ICON),
                width: 70.0,
                height: 70.0),
          ),
          Container(
            child: Text(WhgStrings.app_empty, style: WhgConstant.normalText),
          ),
        ],
      ),
    );
  }

  //listview个数
  _getListCount() {
    if (control.needHeader) {
      return (control.dataList.length > 0)
          ? control.dataList.length + 2
          : control.dataList.length + 1;
    } else {
      if (control.dataList.length == 0) {
        return 1;
      }
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
        ? new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                new SpinKitWave(
                  color: Color(WhgColors.primaryValue),
                  size: 20.0,
                ),
                new Container(
                  width: 5.0,
                ),
                new Text(
                  WhgStrings.load_more_text,
                  style: WhgConstant.smallTextBold,
                )
              ])
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
