import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/main.dart';
import 'package:league_arena/pages/home/event_info.dart';
import 'package:league_arena/utils/content_view.dart';
import 'package:league_arena/widgets/custom_tab.dart';
import 'package:league_arena/widgets/custom_tab_bar.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  

  @override
  Widget build(BuildContext context) {
    var upcomingTabString = "UPCOMING";
    Size upcomingTabSize = calcTextSize(upcomingTabString, const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'));

    var ongoingTabString = "STARTED";
    Size ongoingTabSize = calcTextSize(ongoingTabString, const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'));

    List<ContentView> contentViews = [
      ContentView(
          tab: CustomTab(
            width: upcomingTabSize.width + 5,
            title: upcomingTabString,
          ),
          content: 'upcomingScreenRoute',
          index: 0),
      ContentView(
          tab: CustomTab(
            width: ongoingTabSize.width + 5,
            title: ongoingTabString,
          ),
          content: 'ongoingScreenRoute',
          index: 1)
    ];

    final tabPage2 = TabPage.of(context);
    double height = MediaQuery.of(context).size.height;

    return Obx(
      () => Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: [
                Container(
                  height: 35,
                  //width: 270,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: CustomText(
                          text: 'TOURNAMENTS',
                          size: 18,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 1,
                  height: 25,
                  color: secondary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: CustomTabBarSecondary(
                    controller: tabPage2,
                    tabs: contentViews.map((e) => e.tab).toList(),
                    indiColor: primary,
                  ),
                ),
                if (scrolled.value == true)
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Icon(
                          Icons.navigate_next_outlined,
                          color: secondary,
                          size: 35,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: secondary, width: 0.5)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              child: CustomText(
                                text: eventController.eventInfo.isNotEmpty ? '${eventController.eventInfo['name']}'.toUpperCase() : '',
                                weight: FontWeight.bold,
                                color: Colors.lightBlueAccent,
                                size: 18,
                              ),
                            )),
                      ),
                    ],
                  ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 35,
                    width: 90,
                    decoration: BoxDecoration(color: hover, borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            underline: Container(color: Colors.transparent),
                            alignment: AlignmentDirectional.topCenter,
                            iconSize: 25,
                            dropdownColor: hover,
                            iconEnabledColor: primary,
                            isDense: true,
                            isExpanded: true,
                            style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                            value: userController.eventRegion.value,
                            items: <String>['EUNE', 'EUW'].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) async {
                              userController.eventRegion.value = newValue!;
                              await eventController.getEvents(userController.eventRegion.value, userController.eventStatus.value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height - 140,
            child: TabBarView(
              controller: tabPage2.controller,
              children: [
                for (final stack in tabPage2.stacks) PageStackNavigator(stack: stack),
              ],
            ),
          ),
        ]),
      )),
    );
  }
}
