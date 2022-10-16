import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/routes/routes.dart';
import 'package:league_arena/utils/content_view.dart';
import 'package:league_arena/widgets/custom_tab.dart';
import 'package:league_arena/widgets/custom_tab_bar.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:league_arena/widgets/top_navigation_bar.dart';
import 'package:routemaster/routemaster.dart';

class EventInfo extends StatefulWidget {
  final String? id;
  const EventInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
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

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;


    return Obx(
      () => eventController.eventInfo.isNotEmpty
          ? Scaffold(
              body: Container(
              height: _height - kToolbarHeight,
              width: _width,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: card),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), /*color: background.withOpacity(0.8),*/ border: Border.all(width: 0.5, color: secondary)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: CustomText(
                            text: '${eventController.eventInfo['events']['event_name']}'.toUpperCase() + '#' + '${eventController.eventInfo['events']['event_id']}',
                            size: 25,
                            weight: FontWeight.bold,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), /*color: background.withOpacity(0.8),*/ border: Border.all(width: 0.5, color: secondary)),
                          child: IconButton(
                            onPressed: () {
                              Routemaster.of(context).pop();
                            },
                            icon: const Icon(Icons.close_outlined),
                            padding: const EdgeInsets.all(5),
                            constraints: const BoxConstraints(),
                            color: primary,
                            iconSize: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), /*color: background.withOpacity(0.8),*/ border: Border.all(width: 0.5, color: secondary)),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              // width: 280,
                              child: Row(
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
                                    text: '${eventController.eventInfo['events']['event_region']}',
                                    size: 15,
                                    weight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 1,
                              height: 25,
                              color: secondary,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), /*color: background.withOpacity(0.8),*/ border: Border.all(width: 0.5, color: secondary)),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              // width: 280,
                              child: Row(
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
                                    text: eventController.eventInfo['events']['event_date'],
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
                                    text: DateFormat.jm()
                                            .format(DateTime.parse(eventController.eventInfo['events']['event_date'] + 'T' + eventController.eventInfo['events']['event_hour'])) +
                                        ' (EET)',
                                    size: 15,
                                    weight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 1,
                              height: 25,
                              color: secondary,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), /*color: background.withOpacity(0.8),*/ border: Border.all(width: 0.5, color: secondary)),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              // width: 280,
                              child: Row(
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
                                          text: eventController.eventInfo['events']['event_fee'] > 0 ? '${eventController.eventInfo['events']['event_fee']}' ' USD' : 'FREE',
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
                                        text: eventController.eventInfo['events']['event_fee'] > 0 ? '${(eventController.eventInfo['events']['event_fee'] * 3 / 4).toStringAsFixed(2)}' ' USD' : '${eventController.eventInfo['events']['event_prize']}' ' USD',
                                        size: 15,
                                        weight: FontWeight.bold,
                                      ),
                                    ]),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 1,
                              height: 25,
                              color: secondary,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), /*color: background.withOpacity(0.8),*/ border: Border.all(width: 0.5, color: secondary)),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              // width: 280,
                              child: Row(
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
                                    text: '${eventController.eventInfo['events']['event_type']}',
                                    size: 15,
                                    weight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 1,
                              height: 25,
                              color: secondary,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), /*color: background.withOpacity(0.8),*/ border: Border.all(width: 0.5, color: secondary)),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              // width: 280,
                              child: Row(
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
                                    text: '0' '/' '${eventController.eventInfo['events']['event_capacity']}',
                                    size: 15,
                                    weight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    height: _height - kToolbarHeight - 235,
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
            ))
          : const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            ),
    );
  }
}
