import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:league_arena/constants/controllers.dart';
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
    //await eventController.getEvents('EUNE', 'UPCOMING');
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
    double height = MediaQuery.of(context).size.height;
    ScrollController sc1 = ScrollController();

    return Obx(
      () => Container(
          alignment: Alignment.topLeft,
          height: height,
          padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.transparent),
          child: SmoothScroll(
            controller: sc1,
            child: GridView.count(
              controller: sc1,
              shrinkWrap: false,
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              crossAxisSpacing: 0,
              mainAxisSpacing: 5,
              childAspectRatio: 1.9,
              children: <Widget>[
                for (var item in eventController.euwEvents)
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: TournamentDetails(
                      id: item['id'],
                      name: item['name'],
                      region: item['region'],
                      type: item['type'],
                      capacity: item['capacity'],
                      fee: item['fee'].toDouble(),
                      prize: item['prize'].toDouble(),
                      date: DateFormat("yyyy-MM-dd").format(DateTime.parse(item['start_date'])),
                      hour: item['start_hour'],
                      status: item['status'],
                      eventbanner: item['event_banner'],
                    ),
                  )
              ],
            ),
          )),
    );
  }
}
