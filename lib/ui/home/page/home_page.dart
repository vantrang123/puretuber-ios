import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../constants/colors.dart';
import '../../../provider/home_tab.dart';
import 'tab_entertainment.dart';
import 'tab_music.dart';
import 'tab_sport.dart';
import 'tab_trending.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    HomeTabProvider tabProvider = Provider.of<HomeTabProvider>(context, listen: false);
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      int tabIndex = _tabController.index;
      if (tabIndex == 0) {
        tabProvider.currentHomeTab = HomeScreenTab.All;
      } else if (tabIndex == 1) {
        tabProvider.currentHomeTab = HomeScreenTab.Music;
      } else if (tabIndex == 2) {
        tabProvider.currentHomeTab = HomeScreenTab.Entertainment;
      } else if (tabIndex == 3) {
        tabProvider.currentHomeTab = HomeScreenTab.Sport;
      } else if (tabIndex == 4) {
        tabProvider.currentHomeTab = HomeScreenTab.Style;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: [
        Column(children: [
          _buildTabBar(),
          const SizedBox(height: 4),
          Expanded(child: TabBarView(
              controller: _tabController,
              children: [
                TabTrending(),
                TabMusic(),
                TabEntertainment(),
                TabSport(),
              ])
          ),
          // VideoPageCollapsed()
        ])
      ],
    );
  }

  Widget _buildTabBar() {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: Container(
          width: double.maxFinite,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              TabBar(
                indicatorPadding: EdgeInsets.only(bottom: 5),
                physics: BouncingScrollPhysics(),
                isScrollable: true,
                controller: _tabController,
                onTap: (int tabIndex) { },
                labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                unselectedLabelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textColorGray,
                indicator: MaterialIndicator(
                    height: 3,
                    topLeftRadius: 0,
                    topRightRadius: 0,
                    bottomLeftRadius: 5,
                    bottomRightRadius: 5,
                    horizontalPadding: 20,
                    tabPosition: TabPosition.bottom,
                    color: AppColors.accentColor[500]!),
                tabs: [
                  SizedBox(
                    width: 60,
                    child: Tab(text: "All"),
                  ),
                  SizedBox(
                    width: 60,
                    child: Tab(text: "Music"),
                  ),
                  SizedBox(
                    width: 90,
                    child: Tab(text: "Entertainment"),
                  ),
                  SizedBox(
                    width: 60,
                    child: Tab(text: "Sports"),
                  ),
                ],
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          )),
    );
  }
}
