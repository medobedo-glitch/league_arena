import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/routes.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/main.dart';
import 'package:league_arena/pages/main/side_panel.dart';
import 'package:league_arena/widgets/custom_tab_bar.dart';
import 'package:league_arena/utils/content_view.dart';
import 'package:league_arena/widgets/custom_tab.dart';
import 'package:routemaster/routemaster.dart';

var nowDetector = 0.obs;


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Size calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var one = 10.0.obs;

    var homeTabString = "HOME";
    Size homeTabSize = calcTextSize(homeTabString, const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'));

    var sponsorsTabString = "COMMUNITY";
    Size sponsorsTabSize = calcTextSize(sponsorsTabString, const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'));

    List<ContentView> contentViews = [
      ContentView(
          tab: CustomTab(
            width: homeTabSize.width + 5,
            title: homeTabString,
          ),
          content: homeScreenRoute,
          index: 0),
      ContentView(
          tab: CustomTab(
            width: sponsorsTabSize.width + 5,
            title: sponsorsTabString,
          ),
          content: sponsorsScreenRoute,
          index: 1)
    ];

    final tabPage = TabPage.of(context);

    return Obx(() => Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: const [
              SidePanel(),
            ],
          ),
          Expanded(child: Container()),
          SizedBox(
            width: width - 310,
            height: height,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: one.value),
                  child: Container(
                    decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CustomTabBarPrimary(
                            controller: tabPage,
                            tabs: contentViews.map((e) => e.tab).toList(),
                            indiColor: Colors.lightBlueAccent,
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        if (userController.uID.value != '')
                          Tooltip(
                            waitDuration: const Duration(milliseconds: 500),
                            message: 'Sign Out',
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
                              child: IconButton(
                                onPressed: () {
                                  routemaster.replace(signOutScreenRoute);
                                },
                                icon: const Icon(Icons.logout),
                                padding: const EdgeInsets.all(5),
                                constraints: const BoxConstraints(),
                                color: primary,
                                iconSize: 25,
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Row(
                //   children: [
                //     Expanded(child: Container()),
                //     SizedBox(
                //       width: width - 305,
                //       height: 0.5,
                //       child: Container(
                //         color: secondary,
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: height - 70,
                  width: width - 330,
                  child: TabBarView(
                    controller: tabPage.controller,
                    children: [
                      for (final stack in tabPage.stacks) PageStackNavigator(stack: stack),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
