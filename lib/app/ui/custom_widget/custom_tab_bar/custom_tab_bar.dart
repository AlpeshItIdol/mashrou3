import 'package:flutter/material.dart';
import 'package:mashrou3/utils/ui_components.dart';

import '../../../../config/resources/app_colors.dart';

class CustomTabBar extends StatefulWidget {
  CustomTabBar({
    super.key,
    required this.flexibleSpaceBarWidget,
    this.isScrollable = false,
    this.isPreferredSizeNeeded = false,
    this.expandedHeight = 210,
    required this.tabsList,
    required this.tabsLength,
    this.tabController,
    this.initialTabIndex = 0,
    required this.tabBarViewsList,
    required this.onTabControllerUpdated,
    required this.onTabChanged,
    this.tabAlignment = TabAlignment.start,
  });

  final Widget flexibleSpaceBarWidget;
  final bool isScrollable;
  final bool isPreferredSizeNeeded;
  final double? expandedHeight;
  final int tabsLength;
  final List<Widget> tabsList;
  final List<Widget> tabBarViewsList;
  TabController? tabController;
  final int initialTabIndex;
  final Function(TabController) onTabControllerUpdated;
  final TabAlignment? tabAlignment;
  final ValueChanged<int> onTabChanged;

  void moveToIndex(int index) {
    tabController?.animateTo(index);
  }

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabsLength,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    )..addListener(() {
        widget.onTabChanged(_tabController.index);
      });
    widget.onTabControllerUpdated(_tabController);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabsLength,
      initialIndex: widget.initialTabIndex,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.white,
              expandedHeight: widget.expandedHeight,
              stretch: true,
              floating: false,
              pinned: true,
              // Keeps the TabBar pinned
              flexibleSpace: FlexibleSpaceBar(
                background: widget.flexibleSpaceBarWidget,
              ),
              bottom: widget.isPreferredSizeNeeded
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(70),
                      child: TabBar(
                        isScrollable: widget.isScrollable,
                        controller: _tabController,
                        labelColor: AppColors.colorPrimary,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 3,
                        tabAlignment: TabAlignment.center,
                        indicatorColor: AppColors.colorPrimary,
                        tabs: widget.tabsList,
                      ),
                    )
                  : TabBar(
                      isScrollable: widget.isScrollable,
                      controller: _tabController,
                      labelColor: AppColors.colorPrimary,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 3,
                      tabAlignment: UIComponent.isSystemFontMax(context)
                          ? TabAlignment.center
                          : TabAlignment.fill,
                      indicatorColor: AppColors.colorPrimary,
                      tabs: widget.tabsList,
                    ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: widget.tabBarViewsList,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
