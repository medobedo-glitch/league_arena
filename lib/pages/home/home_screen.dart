import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/routes/routes.dart';
import 'package:league_arena/utils/content_view.dart';
import 'package:league_arena/widgets/custom_tab.dart';
import 'package:league_arena/widgets/custom_tab_bar.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:league_arena/widgets/top_navigation_bar.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var upcomingTabString = "UPCOMING";
    Size upcomingTabSize = calcTextSize(upcomingTabString, GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)));

    var ongoingTabString = "STARTED";
    Size ongoingTabSize = calcTextSize(ongoingTabString, GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)));

    List<ContentView> contentViews = [
      ContentView(
          tab: CustomTab(
            width: upcomingTabSize.width + 5,
            title: upcomingTabString,
          ),
          content: upcomingScreenRoute,
          index: 0),
      ContentView(
          tab: CustomTab(
            width: ongoingTabSize.width + 5,
            title: ongoingTabString,
          ),
          content: ongoingScreenRoute,
          index: 1)
    ];

    final tabPage2 = TabPage.of(context);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight + 5, right: 0, left: 0, bottom: 0),
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 0),
        width: _width - 305,
        height: _height - kToolbarHeight,
        decoration: BoxDecoration(
          color: background,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                height: 35,
                width: 270,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CustomText(
                      text: 'EVENTS & TOURNAMENTS',
                      size: 18,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10,),
              Container(width: 1, height: 25, color: secondary,),
              const SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: CustomTabBarSecondary(controller: tabPage2, tabs: contentViews.map((e) => e.tab).toList(), indiColor: primary,),
              )
            ],
          ),
          SizedBox(
            width: _width - 290,
            height: _height - kToolbarHeight - 70,
            child: TabBarView(
              controller: tabPage2.controller,
              children: [
                for (final stack in tabPage2.stacks) PageStackNavigator(stack: stack),
              ],
            ),
          ),
        ]),
      ),
    ));
  }
}
