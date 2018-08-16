import 'package:flutter/material.dart';

class WhgTabBarWidget extends StatefulWidget {
  //位置
  static const int BOTTOM_TAB = 1;
  static const int TOP_TAB = 2;

  final int type;
  final List<Widget> tabItems;
  final List<Widget> tabViews;
  final Color backgroundColor;
  final Color indicatorColor;
  final String title;

  WhgTabBarWidget(
      {Key key,
      this.type,
      this.tabItems,
      this.tabViews,
      this.backgroundColor,
      this.indicatorColor,
      this.title})
      : super(key: key);

  @override
  WhgTabBarWidgetState createState() => new WhgTabBarWidgetState(
      this.type,
      this.tabItems,
      this.tabViews,
      this.backgroundColor,
      this.indicatorColor,
      this.title);
}

class WhgTabBarWidgetState extends State<WhgTabBarWidget>
    with SingleTickerProviderStateMixin {
  final int type;
  final List<Widget> tabItems;
  final List<Widget> tabViews;
  final Color backgroundColor;
  final Color indicatorColor;
  final String title;

  TabController _tabController;

  WhgTabBarWidgetState(this.type, this.tabItems, this.tabViews,
      this.backgroundColor, this.indicatorColor, this.title)
      : super();

  @override
  void initState() {
    super.initState();
    if (this.type == WhgTabBarWidget.BOTTOM_TAB) {
      _tabController = TabController(length: 3, vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.type == WhgTabBarWidget.TOP_TAB) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundColor,
            title: Text(title),
            bottom: TabBar(
              tabs: tabItems,
              indicatorColor: indicatorColor,
            ),
          ),
          body: TabBarView(children: tabViews),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(title),
      ),
      body: TabBarView(
        children: tabViews,
        controller: _tabController,
      ),
      bottomNavigationBar: Material(
        color: Colors.deepOrange,
        child: TabBar(
          tabs: tabItems,
          controller: _tabController,
          indicatorColor: indicatorColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (this.type == WhgTabBarWidget.BOTTOM_TAB && _tabController != null) {
      _tabController.dispose();
    }
  }
}
