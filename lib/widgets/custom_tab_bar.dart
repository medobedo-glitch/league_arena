import 'package:flutter/material.dart';
import 'package:league_arena/constants/style.dart';
import 'package:routemaster/routemaster.dart';

class CustomTabBarPrimary extends StatelessWidget {
  final TabPageState controller;
  final List<Widget> tabs;
  final Color indiColor;
  const CustomTabBarPrimary({
    Key? key,
    required this.controller,
    required this.tabs,
    required this.indiColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabs,
      padding: EdgeInsets.zero,
      controller: controller.controller,
      isScrollable: true,
      indicatorColor: indiColor,
      //indicator: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/pngwing.com.png'))),
      indicatorSize: TabBarIndicatorSize.label,
      //indicatorPadding: EdgeInsets.only(top: 15),
      unselectedLabelColor: secondary,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
    );
  }
}

class CustomTabBarSecondary extends StatelessWidget {
  final TabPageState controller;
  final List<Widget> tabs;
  final Color indiColor;
  const CustomTabBarSecondary({
    Key? key,
    required this.controller,
    required this.tabs,
    required this.indiColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabs,
      controller: controller.controller,
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.tab,
      unselectedLabelColor: secondary,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Colors.blue.shade600, Colors.purple],
          ),
          borderRadius: BorderRadius.circular(5)),
      indicatorPadding: const EdgeInsets.only(top: 12, right: 0, left: 0, bottom: 7),
    );
  }
}
