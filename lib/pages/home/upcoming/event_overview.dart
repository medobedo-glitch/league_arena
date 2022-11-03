import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:league_arena/widgets/smooth_scroll.dart';

class EventOverview extends StatefulWidget {
  const EventOverview({Key? key}) : super(key: key);

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
    return Obx(
      () => Container(
          //height: 50,
          decoration: BoxDecoration(color: card),
          padding: const EdgeInsets.only(bottom: 0),
          child: SmoothScroll(
            controller: sc1,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                controller: sc1,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: const [
                              CustomText(
                                text: 'Event Overview',
                                size: 25,
                                weight: FontWeight.bold,
                                color: Colors.lightBlueAccent,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                          child: SizedBox(
                            //decoration: BoxDecoration(border: Border.all(width: 0.5, color: secondary)),
                            width: width,
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: convertNewLine(eventController.eventInfo['overview_text']),
                                      style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 17))),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
