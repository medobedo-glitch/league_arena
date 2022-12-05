import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/pages/home/event_info.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:league_arena/widgets/participant_info.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class EventParticipants extends StatefulWidget {
  const EventParticipants({Key? key}) : super(key: key);

  @override
  State<EventParticipants> createState() => _EventParticipantsState();
}

class _EventParticipantsState extends State<EventParticipants> {
  ScrollController sc1 = ScrollController();

  String convertNewLine(String content) {
    String line = content.replaceAll(r'[NEW_LINE]', '\n');
    String rule = line.replaceAll(r'[NEW_RULE]', '● ');
    String supRule = rule.replaceAll(r'[NEW_SUP_RULE]', '\n' '        - ');
    return supRule;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Obx(
      () => Container(
          //height: 50,
          decoration: BoxDecoration(color: card),
          padding: const EdgeInsets.only(bottom: 0),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                SizedBox(
                  height: scrolled.value == true ? height - 157 : height - 407,
                  child: eventController.eventParticipant.isNotEmpty
                      ? ImprovedScrolling(
                          scrollController: sc1,
                          enableCustomMouseWheelScrolling: true,
                          enableMMBScrolling: true,
                          customMouseWheelScrollConfig: const CustomMouseWheelScrollConfig(
                            scrollAmountMultiplier: 2.0,
                          ),
                          mmbScrollConfig: const MMBScrollConfig(
                            customScrollCursor: DefaultCustomScrollCursor(),
                          ),
                          child: ResponsiveGridList(
                            horizontalGridSpacing: 0, // Horizontal space between grid items
                            verticalGridSpacing: 16, // Vertical space between grid items
                            horizontalGridMargin: 10, // Horizontal space around the grid
                            verticalGridMargin: 10, // Vertical space around the grid
                            minItemWidth: 150, // The minimum item width (can be smaller, if the layout constraints are smaller)
                            minItemsPerRow: 2, // The minimum items to show in a single row. Takes precedence over minItemWidth
                            maxItemsPerRow: 7, // The maximum items to show in a single row. Can be useful on large screens
                            listViewBuilderOptions: ListViewBuilderOptions(
                                controller: sc1, physics: const NeverScrollableScrollPhysics()), // Options that are getting passed to the ListView.builder() functionfunction
                            children: <Widget>[
                              for (var item in eventController.eventParticipant)
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: ParticipantInfo(
                                    pName: item['participant_name'],
                                    pUID: item['participant_uID'],
                                    sName: item['summoner_name'],
                                    pStatus: item['player_status'],
                                  ),
                                )
                            ],
                          ),
                        )
                      // GridView.count(
                      //   padding: const EdgeInsets.only(left: 15, top: 10, right: 5),
                      //   controller: sc1,
                      //   shrinkWrap: false,
                      //   crossAxisCount: 6,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   scrollDirection: Axis.vertical,
                      //   crossAxisSpacing: 0,
                      //   mainAxisSpacing: 10,
                      //   childAspectRatio: 1.3,
                      //   children: <Widget>[
                      //     for (var item in eventController.eventParticipant)
                      //       Padding(
                      //         padding: const EdgeInsets.only(right: 10),
                      //         child: ParticipantInfo(
                      //           pName: item['participant_name'],
                      //           pUID: item['participant_uID'],
                      //           sName: item['summoner_name'],
                      //           pStatus: item['player_status'],
                      //         ),
                      //       )
                      //   ],
                      // )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              color: primary,
                              size: 70,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              text: 'No participants yet!',
                              size: 20,
                              color: primary,
                              weight: FontWeight.bold,
                            )
                          ],
                        ),
                ),
              ],
            ),
          )),
    );
  }
}
