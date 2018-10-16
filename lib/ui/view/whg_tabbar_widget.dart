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
  final Widget title;
  final Widget drawer;
  final Widget floatingActionButton;
  final TarWidgetControl tarWidgetControl;
  final PageController topPageControl;
  final ValueChanged<int> onPageChanged;

  WhgTabBarWidget({
    Key key,
    this.type,
    this.tabItems,
    this.tabViews,
    this.backgroundColor,
    this.indicatorColor,
    this.title,
    this.drawer,
    this.floatingActionButton,
    this.tarWidgetControl,
    this.topPageControl,
    this.onPageChanged,
  }) : super(key: key);

  @override
  WhgTabBarWidgetState createState() => new WhgTabBarWidgetState(
      this.type,
      this.tabViews,
      this.indicatorColor,
      this.title,
      this.drawer,
      this.floatingActionButton,
      this.tarWidgetControl,
      this.topPageControl,
      this.onPageChanged);
}

class WhgTabBarWidgetState extends State<WhgTabBarWidget>
    with SingleTickerProviderStateMixin {
  final int type;
  final List<Widget> tabViews;
  final Color indicatorColor;
  final Widget title;
  final Widget drawer;
  final Widget floatingActionButton;
  final ValueChanged<int> _onPageChanged;

  final TarWidgetControl tarWidgetControl;
  final PageController _pageController;

  TabController _tabController;

  WhgTabBarWidgetState(
      this.type,
      this.tabViews,
      this.indicatorColor,
      this.title,
      this.drawer,
      this.floatingActionButton,
      this.tarWidgetControl,
      this._pageController,
      this._onPageChanged)
      : super();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabItems.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (this.type == WhgTabBarWidget.TOP_TAB) {
      return Scaffold(
        floatingActionButton: floatingActionButton,
        persistentFooterButtons:
            tarWidgetControl == null ? [] : tarWidgetControl.footerButton,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: title,
          bottom: TabBar(
            controller: _tabController,
            tabs: widget.tabItems,
            indicatorColor: indicatorColor,
          ),
        ),
        body: PageView(
          //类似于viewpager
          controller: _pageController,
          children: tabViews,
          onPageChanged: (index) {
            _tabController.animateTo(index);
            if (_onPageChanged != null) {
              _onPageChanged(index);
            }
          },
        ),
      );
    }

    return Scaffold(
      drawer: drawer,
      appBar:
          AppBar(backgroundColor: Theme.of(context).primaryColor, title: title),
      body: TabBarView(
        children: tabViews,
        controller: _tabController,
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor,
        child: TabBar(
          tabs: widget.tabItems,
          controller: _tabController,
          indicatorColor: indicatorColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}

class TarWidgetControl {
  List<Widget> footerButton = [];
}
