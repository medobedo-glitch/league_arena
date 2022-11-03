import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/routes.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/main.dart';
import 'package:league_arena/utils/content_view.dart';
import 'package:league_arena/widgets/custom_tab.dart';
import 'package:league_arena/widgets/custom_tab_bar.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:routemaster/routemaster.dart';

class EventInfo extends StatefulWidget {
  final String? id;
  const EventInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  var mar = 10.0.obs;

  Future getEventInfo(String? id) async {
    await eventController.getEventInfoById(id);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var data = RouteData.of(context).pathParameters;
      getEventInfo(data['id']);
    });

    super.initState();
  }

  String convertDate(String time) {
    return DateFormat("yyyy-MM-dd").format(DateTime.parse(time));
  }

  @override
  Widget build(BuildContext context) {
    var eventOverviewTabString = "OVERVIEW";
    Size eventOverviewTabSize = calcTextSize(eventOverviewTabString, GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)));

    var eventRulesTabString = "RULES";
    Size eventRulesTabSize = calcTextSize(eventRulesTabString, GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)));

    var eventParticipantsTabString = "PARTICIPANTS";
    Size eventParticipantsTabSize = calcTextSize(eventParticipantsTabString, GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)));

    List<ContentView> contentViews = [
      ContentView(
          tab: CustomTab(
            width: eventOverviewTabSize.width + 5,
            title: eventOverviewTabString,
          ),
          content: eventOverviewScreenRoute,
          index: 0),
      ContentView(
          tab: CustomTab(
            width: eventRulesTabSize.width + 5,
            title: eventRulesTabString,
          ),
          content: eventRulesScreenRoute,
          index: 1),
      ContentView(
          tab: CustomTab(
            width: eventParticipantsTabSize.width + 5,
            title: eventParticipantsTabString,
          ),
          content: eventParticipantsScreenRoute,
          index: 2)
    ];

    final tabPage3 = TabPage.of(context);

    double width = MediaQuery.of(context).size.width;

    return Obx(
      () => eventController.eventInfo.isNotEmpty
          ? Container(
              color: card,
              child: Column(
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: secondary),
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                        image: DecorationImage(
                            image: AdvancedNetworkImage(
                              eventController.eventInfo['overview_banner'],
                              useDiskCache: true,
                              cacheRule: const CacheRule(maxAge: Duration(days: 1)),
                            ),
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high)),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      //height: 150,
                      width: width,
                      margin: EdgeInsets.only(bottom: mar.value),
                      //decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Container()),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: background.withOpacity(0.8),
                                      border: Border.all(width: 0.5, color: background.withOpacity(0.7))),
                                  child: IconButton(
                                    onPressed: () {
                                      Routemaster.of(context).pop();
                                    },
                                    icon: const Icon(Icons.close_outlined),
                                    padding: const EdgeInsets.all(5),
                                    constraints: const BoxConstraints(),
                                    color: primary,
                                    iconSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: background.withOpacity(0.8),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                      child: CustomText(
                                        text: '${'${eventController.eventInfo['name']}'.toUpperCase()}#${eventController.eventInfo['id']}',
                                        size: 25,
                                        weight: FontWeight.bold,
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Container(
                                      decoration: BoxDecoration(color: background.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.public_outlined,
                                                  size: 20,
                                                  color: primary,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                CustomText(
                                                  text: '${eventController.eventInfo['region']}',
                                                  size: 15,
                                                  weight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                            Expanded(child: Container()),
                                            Container(
                                              width: 1,
                                              height: 25,
                                              color: secondary,
                                            ),
                                            Expanded(child: Container()),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.date_range_outlined,
                                                  size: 20,
                                                  color: primary,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                CustomText(
                                                  text: convertDate(eventController.eventInfo['start_date']),
                                                  size: 15,
                                                  weight: FontWeight.bold,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.schedule_outlined,
                                                  size: 20,
                                                  color: primary,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                CustomText(
                                                  text:
                                                      // ignore: prefer_interpolation_to_compose_strings
                                                      '${DateFormat.jm().format(DateTime.parse('${convertDate(eventController.eventInfo['start_date'])}T' + eventController.eventInfo['start_hour']))} (EET)',
                                                  size: 15,
                                                  weight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                            Expanded(child: Container()),
                                            Container(
                                              width: 1,
                                              height: 25,
                                              color: secondary,
                                            ),
                                            Expanded(child: Container()),
                                            Row(
                                              children: [
                                                Tooltip(
                                                  textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primary),
                                                  decoration: BoxDecoration(color: background.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                                                  message: 'Entry Fee',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.payments_outlined,
                                                        size: 20,
                                                        color: primary,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      CustomText(
                                                        text: eventController.eventInfo['fee'] > 0 ? '${eventController.eventInfo['fee']}' ' USD' : 'FREE',
                                                        size: 15,
                                                        weight: FontWeight.bold,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Tooltip(
                                                  textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primary),
                                                  decoration: BoxDecoration(color: background.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                                                  message: 'Prize Per Winning Game',
                                                  child: Row(children: [
                                                    Icon(
                                                      Icons.emoji_events_outlined,
                                                      size: 20,
                                                      color: primary,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    CustomText(
                                                      text: eventController.eventInfo['fee'] > 0
                                                          ? '${(eventController.eventInfo['fee'] * 3 / 4).toStringAsFixed(2)}' ' USD'
                                                          : '${eventController.eventInfo['prize']}' ' USD',
                                                      size: 15,
                                                      weight: FontWeight.bold,
                                                    ),
                                                  ]),
                                                )
                                              ],
                                            ),
                                            Expanded(child: Container()),
                                            Container(
                                              width: 1,
                                              height: 25,
                                              color: secondary,
                                            ),
                                            Expanded(child: Container()),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.person_outline,
                                                  size: 20,
                                                  color: primary,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                CustomText(
                                                  text: '${eventController.eventInfo['type']}',
                                                  size: 15,
                                                  weight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                            Expanded(child: Container()),
                                            Container(
                                              width: 1,
                                              height: 25,
                                              color: secondary,
                                            ),
                                            Expanded(child: Container()),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.people_outline,
                                                  size: 20,
                                                  color: primary,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                CustomText(
                                                  text: '0' '/' '${eventController.eventInfo['capacity']}',
                                                  size: 15,
                                                  weight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomTabBarPrimary(
                    controller: tabPage3,
                    tabs: contentViews.map((e) => e.tab).toList(),
                    indiColor: primary,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 270,
                    //width: _width,
                    child: TabBarView(
                      controller: tabPage3.controller,
                      children: [
                        for (final stack in tabPage3.stacks) PageStackNavigator(stack: stack),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(),
    );
  }
}
