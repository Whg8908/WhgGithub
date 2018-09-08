import 'package:flutter/material.dart';

///配合AutomaticKeepAliveClientMixin可以keep住

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
  final Widget drawer;
  final Widget floatingActionButton;
  final TarWidgetControl tarWidgetControl;

  WhgTabBarWidget(
      {Key key,
      this.type,
      this.tabItems,
      this.tabViews,
      this.backgroundColor,
      this.indicatorColor,
      this.title,
      this.drawer,
      this.floatingActionButton,
      this.tarWidgetControl})
      : super(key: key);

  @override
  WhgTabBarWidgetState createState() => new WhgTabBarWidgetState(
      this.type,
      this.tabItems,
      this.tabViews,
      this.backgroundColor,
      this.indicatorColor,
      this.title,
      this.drawer,
      this.floatingActionButton,
      this.tarWidgetControl);
}

class WhgTabBarWidgetState extends State<WhgTabBarWidget>
    with SingleTickerProviderStateMixin {
  final int type;
  final List<Widget> tabItems;
  final List<Widget> tabViews;
  final Color backgroundColor;
  final Color indicatorColor;
  final String title;
  final Widget drawer;
  final Widget floatingActionButton;

  final TarWidgetControl tarWidgetControl;

  TabController _tabController;

  WhgTabBarWidgetState(
      this.type,
      this.tabItems,
      this.tabViews,
      this.backgroundColor,
      this.indicatorColor,
      this.title,
      this.drawer,
      this.floatingActionButton,
      this.tarWidgetControl)
      : super();

  @override
  void initState() {
    super.initState();
    if (this.type == WhgTabBarWidget.BOTTOM_TAB) {
      _tabController = TabController(length: tabItems.length, vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.type == WhgTabBarWidget.TOP_TAB) {
      return DefaultTabController(
        length: tabItems.length,
        child: Scaffold(
          floatingActionButton: floatingActionButton,
          persistentFooterButtons:
              tarWidgetControl == null ? [] : tarWidgetControl.footerButton,
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
      drawer: drawer,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: new Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: TabBarView(
        children: tabViews,
        controller: _tabController,
      ),
      bottomNavigationBar: Material(
        color: backgroundColor,
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

class TarWidgetControl {
  List<Widget> footerButton = [];
}
