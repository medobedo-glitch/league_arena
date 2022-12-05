import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/routes.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/dialogs/event_join_dialog.dart';
import 'package:league_arena/main.dart';
import 'package:league_arena/utils/content_view.dart';
import 'package:league_arena/widgets/custom_tab.dart';
import 'package:league_arena/widgets/custom_tab_bar.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:routemaster/routemaster.dart';

class EventInfo extends StatefulWidget {
  final String? id;
  const EventInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<EventInfo> createState() => _EventInfoState();
}

var scrollAmount = 0.0.obs;
var scrolled = false.obs;

class _EventInfoState extends State<EventInfo> {
  var db = FirebaseFirestore.instance;
  var mar = 10.0.obs;
  var organizer = ''.obs;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? listener;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? listener2;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? listener3;

  @override
  void initState() {
    final docRef = db.collection("events").doc(widget.id);
    listener = docRef.snapshots().listen((event) {
      eventController.eventInfo.value = {};
      final data = event.data() as Map<String, dynamic>;
      eventController.eventInfo.value = data;
    });

    final docRef2 = db.collection('events').doc(widget.id).collection('participants').orderBy('summoner_rank');
    listener2 = docRef2.snapshots().listen((event2) {
      eventController.eventParticipant.value = [];
      for (var doc2 in event2.docs) {
        Map<String, dynamic> data2 = doc2.data();
        eventController.eventParticipant.add(data2);
      }
    });

    final docRef3 = db.collection('events').doc(widget.id).collection('matches');
    listener3 = docRef3.snapshots().listen((event) {
      eventController.eventMatches.value = [];
      for (var doc in event.docs) {
        Map<String, dynamic> data = doc.data();
        eventController.eventMatches.add(data);
      }
    });

    getOrganizer(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    listener?.cancel();
    listener2?.cancel();
    listener3?.cancel();
    super.dispose();
  }

  DateTime convertDate(String time) {
    var dateTime2 = DateFormat("yyyy-MM-dd HH:mm").parse(eventController.eventInfo['start_date'], true);
    var dateLocal = dateTime2.toLocal();
    return dateLocal;
  }

  Future<void> getOrganizer(String? id) async {
    organizer.value = await eventController.getEventOrganizer(id);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    var eventOverviewTabString = "OVERVIEW";
    Size eventOverviewTabSize = calcTextSize(eventOverviewTabString, const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'));

    var eventRulesTabString = "RULES";
    Size eventRulesTabSize = calcTextSize(eventRulesTabString, const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'));

    var eventParticipantsTabString = "PARTICIPANTS";
    Size eventParticipantsTabSize = calcTextSize(eventParticipantsTabString, const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'));

    var eventBracketsTabString = "BRACKETS";
    Size eventBracketsTabSize = calcTextSize(eventBracketsTabString, const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'));

    List<ContentView2> contentViews = [
      ContentView2(
          tab: CustomTab2(
            width: eventOverviewTabSize.width + 5,
            title: eventOverviewTabString,
          ),
          content: eventOverviewScreenRoute,
          index: 0),
      ContentView2(
          tab: CustomTab2(
            width: eventRulesTabSize.width + 5,
            title: eventRulesTabString,
          ),
          content: eventRulesScreenRoute,
          index: 1),
      ContentView2(
          tab: CustomTab2(
            width: eventParticipantsTabSize.width + 5,
            title: eventParticipantsTabString,
          ),
          content: eventParticipantsScreenRoute,
          index: 2),
      ContentView2(
          tab: CustomTab2(
            width: eventBracketsTabSize.width + 5,
            title: eventBracketsTabString,
          ),
          content: eventBracketsScreenRoute,
          index: 3)
    ];

    final tabPage3 = TabPage.of(context);

    double width = MediaQuery.of(context).size.width;

    return Obx(() => (eventController.eventInfo.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Listener(
              onPointerSignal: (pointerSignal) {
                if (pointerSignal is PointerScrollEvent) {
                  if (pointerSignal.scrollDelta.dy > 0 && scrollAmount.value > 0) {
                    //scrolled.value = true;
                  } else if (pointerSignal.scrollDelta.dy < 0 && scrollAmount.value == 0) {
                    //scrolled.value = false;
                  }
                }
              },
              child: Container(
                color: card,
                child: Column(
                  children: [
                    if (scrolled.value == false)
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
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.medium)),
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
                                  if (organizer.value != '')
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: background.withOpacity(0.8),
                                        ),
                                        padding: const EdgeInsets.only(right: 15, left: 15, top: 5, bottom: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CustomText(
                                                  text: 'BY ',
                                                  size: 15,
                                                  weight: FontWeight.bold,
                                                  color: primary,
                                                ),
                                                CustomText(
                                                  text: organizer.value.toUpperCase(),
                                                  size: 15,
                                                  weight: FontWeight.bold,
                                                  color: Colors.lightBlueAccent,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const Icon(
                                                  Icons.verified,
                                                  color: Colors.lightBlue,
                                                  size: 15,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
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
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
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
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: background.withOpacity(0.8),
                                          ),
                                          padding: const EdgeInsets.only(right: 15, left: 15, top: 5, bottom: 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: '${eventController.eventInfo['name']}'.toUpperCase(),
                                                size: 25,
                                                weight: FontWeight.bold,
                                                color: Colors.lightBlueAccent,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        Container(
                                          //width: 150,
                                          alignment: Alignment.centerRight,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: background.withOpacity(0.7), width: 0.5),
                                            borderRadius: BorderRadius.circular(30.0),
                                            gradient: LinearGradient(
                                              colors: userController.uID.value != ''
                                                  ? userController.emailVerified.value == true
                                                      ? userController.lockedEvent.value == ''
                                                          ? <Color>[Colors.blue.shade600, Colors.purple]
                                                          : <Color>[Colors.grey, Colors.grey]
                                                      : <Color>[Colors.grey, Colors.grey]
                                                  : <Color>[Colors.grey, Colors.grey],
                                            ),
                                          ),
                                          child: OutlinedButton(
                                            onPressed: userController.uID.value != ''
                                                ? userController.emailVerified.value == true
                                                    ? userController.lockedEvent.value == ''
                                                        ? () {
                                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                                              setState(() {
                                                                showDialog(
                                                                    barrierDismissible: false,
                                                                    context: context,
                                                                    builder: (BuildContext context) => EventJoinDialog(
                                                                          eventId: widget.id,
                                                                          eventFee: eventController.eventInfo['fee'],
                                                                          eventRegion: eventController.eventInfo['region'],
                                                                          eventPrize: eventController.eventInfo['prize'],
                                                                          eventCapacity: eventController.eventInfo['capacity'],
                                                                        ));
                                                              });
                                                            });
                                                          }
                                                        : null
                                                    : null
                                                : null,
                                            style: OutlinedButton.styleFrom(
                                                foregroundColor: background,
                                                //primary: Colors.transparent,
                                                //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                                //fixedSize: const Size(250, 40),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                              child: CustomText(
                                                text: userController.uID.value != ''
                                                    ? userController.emailVerified.value == true
                                                        ? userController.lockedEvent.value == eventController.eventInfo['id']
                                                            ? 'REGISTERED'
                                                            : userController.lockedEvent.value != ''
                                                                ? 'REGISTERED TO ANOTHER EVENT'
                                                                : 'REGISTER'
                                                        : 'VERIFICATION REQUIRED'
                                                    : 'SIGN IN TO REGISTER',
                                                color: userController.uID.value != ''
                                                    ? userController.emailVerified.value == true
                                                        ? userController.lockedEvent.value == ''
                                                            ? primary
                                                            : background
                                                        : background
                                                    : background,
                                                size: 15,
                                                weight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   //width: 150,
                                        //   alignment: Alignment.centerRight,
                                        //   decoration: BoxDecoration(
                                        //     border: Border.all(color: background.withOpacity(0.7), width: 0.5),
                                        //     borderRadius: BorderRadius.circular(30.0),
                                        //     gradient: LinearGradient(colors: <Color>[Colors.blue.shade600, Colors.purple]),
                                        //   ),
                                        //   child: OutlinedButton(
                                        //     onPressed: () {
                                        //       eventController.createMatches(eventController.eventInfo['id'], eventController.eventParticipant.length);
                                        //     },
                                        //     style: OutlinedButton.styleFrom(
                                        //         foregroundColor: background,
                                        //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                        //         textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
                                        //     child: Padding(
                                        //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                        //       child: CustomText(
                                        //         text: 'Add Matches',
                                        //         color: primary,
                                        //         size: 15,
                                        //         weight: FontWeight.bold,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
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
                                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(child: Container()),
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
                                                      Icons.schedule_outlined,
                                                      size: 20,
                                                      color: primary,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    CountDownText(
                                                      due: convertDate(eventController.eventInfo['start_date']),
                                                      finishedText: "TOURNAMENT STARTED",
                                                      showLabel: true,
                                                      longDateName: true,
                                                      daysTextLong: " DAYS ",
                                                      hoursTextLong: " HOURS ",
                                                      minutesTextLong: " MINUTES ",
                                                      secondsTextLong: " SECONDS ",
                                                      style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
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
                                                    Tooltip(
                                                      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primary, fontFamily: 'Ubuntu'),
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
                                                      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primary, fontFamily: 'Ubuntu'),
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
                                                      text: '${eventController.eventParticipant.length}' '/' '${eventController.eventInfo['capacity']}',
                                                      size: 15,
                                                      weight: FontWeight.bold,
                                                    ),
                                                  ],
                                                ),
                                                Expanded(child: Container()),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Container()),
                          // if (scrolled.value == true)
                          //   Container(
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(5),
                          //       color: hover.withOpacity(0.8),
                          //     ),
                          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          //     child: CustomText(
                          //       text: '${eventController.eventInfo['name']}'.toUpperCase(),
                          //       size: 20,
                          //       weight: FontWeight.bold,
                          //       color: Colors.lightBlueAccent,
                          //     ),
                          //   ),
                          // if (scrolled.value == true)
                          //   Padding(
                          //     padding: const EdgeInsets.symmetric(horizontal: 8),
                          //     child: Container(
                          //       height: 20,
                          //       width: 1,
                          //       color: secondary,
                          //     ),
                          //   ),
                          Container(
                            padding: const EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 4),
                            decoration: BoxDecoration(border: Border.all(color: secondary, width: 0.5), borderRadius: BorderRadius.circular(30)),
                            child: CustomTabBarSecondary2(
                              controller: tabPage3,
                              tabs: contentViews.map((e) => e.tab).toList(),
                              indiColor: primary,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3), color: background.withOpacity(0.8), border: Border.all(width: 0.5, color: background.withOpacity(0.7))),
                            child: IconButton(
                              onPressed: () {
                                scrolled.value == true ? scrolled.value = false : scrolled.value = true;
                              },
                              icon: scrolled.value == true ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
                              padding: const EdgeInsets.all(5),
                              constraints: const BoxConstraints(),
                              color: primary,
                              iconSize: 20,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: scrolled.value == true ? height - 152 : height - 402,
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
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              color: card,
              child: Column(
                children: [
                  Expanded(child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GlowingProgressIndicator(
                              child: Image.asset(
                            'assets/icon/logo2.png',
                            scale: 10,
                          )),
                        ],
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ));
  }
}
