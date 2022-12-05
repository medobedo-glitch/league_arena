import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/pages/home/event_info.dart';
import 'package:league_arena/widgets/smooth_scroll.dart';

class EventOverview extends StatefulWidget {
  final String? id;
  const EventOverview({Key? key, this.id}) : super(key: key);

  @override
  State<EventOverview> createState() => _EventOverviewState();
}

class _EventOverviewState extends State<EventOverview> {
  ScrollController sc1 = ScrollController();

  String convertNewLine(String content) {
    String line = content.replaceAll(r'[NEW_LINE]', '\n');
    String rule = line.replaceAll(r'[NEW_RULE]', '● ');
    String supRule = rule.replaceAll(r'[NEW_SUP_RULE]', '\n' '        - ');
    return supRule;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                  child: NotificationListener<ScrollUpdateNotification>(
                          onNotification: (notification) {
                            scrollAmount.value = sc1.position.pixels;
                            return true;
                          },
                    child: SmoothScroll(
                      controller: sc1,
                      child: ListView(
                        controller: sc1,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 10, bottom: 10, top: 10),
                            child: SizedBox(
                              //decoration: BoxDecoration(border: Border.all(width: 0.5, color: secondary)),
                              width: width,
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: convertNewLine(eventController.eventInfo['overview_text']), style: TextStyle(color: primary, fontSize: 17, fontFamily: 'Ubuntu')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
