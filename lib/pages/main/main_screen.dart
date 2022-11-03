import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/routes.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/pages/main/side_panel.dart';
import 'package:league_arena/widgets/windows_buttons.dart';
import 'package:league_arena/widgets/custom_tab_bar.dart';
import 'package:league_arena/utils/content_view.dart';
import 'package:league_arena/widgets/custom_tab.dart';
import 'package:routemaster/routemaster.dart';
import 'package:window_manager/window_manager.dart';

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
    userController.doInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var one = 0.5.obs;

    var homeTabString = "HOME";
    Size homeTabSize = calcTextSize(homeTabString, GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)));

    var sponsorsTabString = "UNNAMED_TAB";
    Size sponsorsTabSize = calcTextSize(sponsorsTabString, GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)));

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

    return Obx(
      () => Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                const SidePanel(),
                Container(
                  color: secondary,
                  height: one.value,
                  width: 290,
                ),
                Container(
                  width: 290,
                  height: 42,
                  decoration: BoxDecoration(
                    color: card,
                  ),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(text: "© 2022 League Arena.", style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            SizedBox(
              width: width - 290,
              height: height,
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onPanStart: (details) {
                      windowManager.startDragging();
                    },
                    child: Container(
                      color: background,
                      child: Row(
                        children: [
                          CustomTabBarPrimary(
                            controller: tabPage,
                            tabs: contentViews.map((e) => e.tab).toList(),
                            indiColor: Colors.lightBlueAccent,
                          ),
                          // Expanded(
                          //   child: SizedBox(
                          //       height: kToolbarHeight - one.value,
                          //       child: WindowTitleBarBox(
                          //         child: DragToMoveArea(child: Container(),),
                          //       )),
                          // ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topRight,
                              height: 54,
                              color: background,
                              child: WindowTitleBarBox(
                                child: const WindowsButtons(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      SizedBox(
                        width: width - 305,
                        height: 0.5,
                        child: Container(
                          color: secondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height - 60,
                    width: width - 320,
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
      ),
    );
  }
}
