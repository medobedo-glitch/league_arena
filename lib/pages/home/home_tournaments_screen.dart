import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/tournament_details.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../../widgets/custom_text.dart';

class TournamentsScreen extends StatefulWidget {
  const TournamentsScreen({Key? key}) : super(key: key);

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
  Timer? timer;
  var dropdownValue = 'EUNE'.obs;

  Future getEvents() async {
    await eventController.getEvents(userController.eventRegion.value, userController.eventStatus.value);
  }

  @override
  void initState() {
    userController.eventStatus.value = 'UPCOMING';
    getEvents();
    // timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
    //   getEvents();
    // });
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
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          alignment: Alignment.topLeft,
          height: height,
          width: 500,
          padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
          decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(5)),
          child: eventController.isLoading.value == false
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomText(
                                  text: 'TOURNAMENTS',
                                  size: 20,
                                  weight: FontWeight.bold,
                                ),
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
                      height: height - kToolbarHeight - 89,
                      child: ImprovedScrolling(
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
                          verticalGridSpacing: 0, // Vertical space between grid items
                          horizontalGridMargin: 10, // Horizontal space around the grid
                          verticalGridMargin: 0, // Vertical space around the grid
                          minItemWidth: 400, // The minimum item width (can be smaller, if the layout constraints are smaller)
                          minItemsPerRow: 1, // The minimum items to show in a single row. Takes precedence over minItemWidth
                          maxItemsPerRow: userController.eventRegion.value == 'EUW'
                              ? eventController.euwEvents.length > 1
                                  ? 2
                                  : 1
                              : eventController.euneEvents.length > 1
                                  ? 2
                                  : 1, // The maximum items to show in a single row. Can be useful on large screens
                          listViewBuilderOptions: ListViewBuilderOptions(
                              controller: sc1, physics: const NeverScrollableScrollPhysics()), // Options that are getting passed to the ListView.builder() functionfunction
                          children: <Widget>[
                            for (var item in userController.eventRegion.value == 'EUW' ? eventController.euwEvents : eventController.euneEvents)
                              Padding(
                                padding: const EdgeInsets.only(right: 5, left: 5, top: 5),
                                child: TournamentDetails(
                                  id: item['id'],
                                  name: item['name'],
                                  region: item['region'],
                                  type: item['type'],
                                  capacity: item['capacity'],
                                  fee: item['fee'].toDouble(),
                                  prize: item['prize'].toDouble(),
                                  date: DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(item['start_date'])),
                                  status: item['status'],
                                  eventbanner: item['event_banner'],
                                ),
                              )
                          ], // The list of widgets in the list
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
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
        ),
      ),
    );
  }
}
