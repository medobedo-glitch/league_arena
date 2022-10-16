import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:league_arena/widgets/smooth_scroll.dart';
import 'package:league_arena/widgets/tournament_details.dart';

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({Key? key}) : super(key: key);

  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  Timer? timer;

  Future getEvents() async {
    await eventController.getEvents('EUW', 'UPCOMING');
    await eventController.getEvents('EUNE', 'UPCOMING');
  }

  @override
  void initState() {
    getEvents();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      getEvents();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    ScrollController sc1 = ScrollController();
    ScrollController sc2 = ScrollController();

    return Obx(
      () => Scaffold(
        body: Container(
            alignment: Alignment.topLeft,
            height: _height,
            padding: const EdgeInsets.only(top: 0, right: 0, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), /*color: card*/
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  width: (_width > 1280 && _width < 1400)
                      ? (_width * 0.36) + 15
                      : (_width > 1400 && _width < 1500)
                          ? (_width * 0.36) + 30
                          : (_width > 1500)
                              ? (_width * 0.36) + 50
                              : (_width * 0.36) + 10,
                  height: _height,
                  decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 35,
                            width: 120,
                            decoration: BoxDecoration(color: hover, border: Border(bottom: BorderSide(color: secondary, width: 1))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CustomText(
                                  text: 'EUNE',
                                  size: 20,
                                  weight: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Flexible(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: SmoothScroll(
                            controller: sc1,
                            child: ListView(
                              controller: sc1,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 0, right: 15, left: 0),
                              children: <Widget>[
                                for (var item in eventController.euneEvents)
                                  TournamentDetails(
                                      id: item['event_id'],
                                      name: item['event_name'],
                                      region: item['event_region'],
                                      type: item['event_type'],
                                      capacity: item['event_capacity'],
                                      fee: item['event_fee'].toDouble(),
                                      prize: item['event_prize'].toDouble(),
                                      date: item['event_date'],
                                      hour: item['event_hour'],
                                      status: item['event_status'],
                                      eventbanner: item['event_banner'],)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  width: (_width > 1280 && _width < 1400)
                      ? (_width * 0.36) + 15
                      : (_width > 1400 && _width < 1500)
                          ? (_width * 0.36) + 30
                          : (_width > 1500)
                              ? (_width * 0.36) + 50
                              : (_width * 0.36) + 10,
                  height: _height,
                  decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 35,
                            width: 120,
                            decoration: BoxDecoration(color: hover, border: Border(bottom: BorderSide(color: secondary, width: 1))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CustomText(
                                  text: 'EUW',
                                  size: 20,
                                  weight: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Flexible(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: SmoothScroll(
                            controller: sc2,
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: sc2,
                              padding: const EdgeInsets.only(bottom: 0, right: 15, left: 0),
                              children: <Widget>[
                                for (var item in eventController.euwEvents)
                                  TournamentDetails(
                                      id: item['event_id'],
                                      name: item['event_name'],
                                      region: item['event_region'],
                                      type: item['event_type'],
                                      capacity: item['event_capacity'],
                                      fee: item['event_fee'].toDouble(),
                                      prize: item['event_prize'].toDouble(),
                                      date: item['event_date'],
                                      hour: item['event_hour'],
                                      status: item['event_status'],
                                      eventbanner: item['event_banner'],)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
