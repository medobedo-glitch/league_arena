import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:league_arena/widgets/snack_bar/custom_snack_bar.dart';
import 'package:league_arena/widgets/snack_bar/top_snack_bar.dart';

class EventJoinDialog extends StatefulWidget {
  final String? eventId;
  final double eventFee;
  final double eventPrize;
  final String eventRegion;
  final int eventCapacity;
  const EventJoinDialog({Key? key, required this.eventId, required this.eventFee, required this.eventRegion, required this.eventPrize, required this.eventCapacity})
      : super(key: key);

  @override
  State<EventJoinDialog> createState() => _EventJoinDialogState();
}

class _EventJoinDialogState extends State<EventJoinDialog> {
  List<String> summoners = [];
  var botpadd = 1.0.obs;
  var dropdownValue = ''.obs;

  var hasBalance = false.obs;
  var hasSummoners = false.obs;

  var buttonPressed = false.obs;

  var summonerId = ''.obs;

  @override
  void initState() {
    if (widget.eventRegion == 'EUNE') {
      for (var item in userController.summonersLoadEUNE) {
        summoners.add(item['name']);
        hasSummoners.value = true;
      }
    }

    if (widget.eventRegion == 'EUW') {
      for (var item in userController.summonersLoadEUW) {
        summoners.add(item['name']);
        hasSummoners.value = true;
      }
    }

    checkEligibility();
    dropdownValue.value = summoners[0];
    super.initState();
  }

  Future<void> checkEligibility() async {
    if (summoners.isEmpty) {
      summoners.add('NO SUMMONERS WERE FOUND');
      hasSummoners.value = false;
    }
    userController.tokens.value >= widget.eventFee ? hasBalance.value = true : null;
  }

  String getSummonerId(String summonerName) {
    if (widget.eventRegion == 'EUW') {
      for (var item in userController.summonersLoadEUW) {
        if (item['name'] == summonerName) {
          return item['summoner_id'];
        }
      }
    }

    if (widget.eventRegion == 'EUNE') {
      for (var item in userController.summonersLoadEUNE) {
        if (item['name'] == summonerName) {
          return item['summoner_id'];
        }
      }
    }
    return '';
  }

    String getSummonerRank(String summonerName) {
    if (widget.eventRegion == 'EUW') {
      for (var item in userController.summonersLoadEUW) {
        if (item['name'] == summonerName) {
          return item['rank'];
        }
      }
    }

    if (widget.eventRegion == 'EUNE') {
      for (var item in userController.summonersLoadEUNE) {
        if (item['name'] == summonerName) {
          return item['rank'];
        }
      }
    }
    return '';
  }

  int giveExtraHeight() {
    var extra = 0.obs;

    if (hasBalance.value == false) {
      extra.value += 20;
    }

    if (hasSummoners.value == false) {
      extra.value += 20;
    }

    return extra.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Dialog(
          backgroundColor: hover,
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: giveExtraHeight() + 360,
            width: 360,
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(10.0),
              border: /*Border(
                  top: BorderSide(color: primary),
                  bottom: BorderSide(color: primary)),*/
                  Border.all(color: hover, width: 0.5),
              color: card,
            ),
            child: Column(
              children: [
                Container(
                  color: card,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, right: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3), color: background.withOpacity(0.8), border: Border.all(width: 0.5, color: background.withOpacity(0.7))),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: 'CONFIRMATION',
                            size: 25,
                            weight: FontWeight.bold,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: CustomText(
                              text: "Review and confirm registeration to the tournament",
                              size: 14,
                            ),
                          ),
                          Container(
                            width: 320,
                            height: 0.5,
                            color: secondary,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: const [
                            CustomText(
                              text: 'Choose your participation summoner',
                              size: 13,
                              weight: FontWeight.bold,
                            ),
                            //Expanded(child: Container()),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          alignment: Alignment.center,
                          height: 42,
                          width: 350,
                          decoration: BoxDecoration(color: hover, borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: botpadd.value),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton(
                                  underline: Container(color: Colors.transparent),
                                  alignment: AlignmentDirectional.topCenter,
                                  iconSize: 20,
                                  dropdownColor: hover,
                                  iconEnabledColor: primary,
                                  isDense: true,
                                  isExpanded: true,
                                  style: TextStyle(color: primary, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                                  value: dropdownValue.value,
                                  items: summoners.toList().map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: hasSummoners.value == true
                                      ? (String? newValue) {
                                          setState(() {
                                            dropdownValue.value = newValue!;
                                          });
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (hasSummoners.value == false)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 320,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(text: "YOU NEED TO LINK SUMMONERS IN THIS REGION", style: TextStyle(color: Colors.red, fontSize: 13, fontFamily: 'Ubuntu')),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Tooltip(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover.withOpacity(0.8)),
                              waitDuration: const Duration(milliseconds: 200),
                              textStyle: TextStyle(color: primary, fontSize: 12, fontFamily: 'Ubuntu'),
                              message: 'Tournament Region',
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: secondary, width: 0.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.public,
                                      color: secondary,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CustomText(
                                      text: widget.eventRegion,
                                      weight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Tooltip(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover.withOpacity(0.8)),
                              waitDuration: const Duration(milliseconds: 200),
                              textStyle: TextStyle(color: primary, fontSize: 12, fontFamily: 'Ubuntu'),
                              message: 'Tournament Entry Fee',
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: hasBalance.value == true ? secondary : Colors.red, width: 0.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.payments_outlined,
                                      color: hasBalance.value == true ? secondary : Colors.red,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CustomText(
                                      text: widget.eventFee != 0 ? '${widget.eventFee} USD' : 'FREE',
                                      weight: FontWeight.bold,
                                      color: hasBalance.value == true ? primary : Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Tooltip(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover.withOpacity(0.8)),
                              waitDuration: const Duration(milliseconds: 200),
                              textStyle: TextStyle(color: primary, fontSize: 12, fontFamily: 'Ubuntu'),
                              message: 'Tournament Prize Per Win',
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: secondary, width: 0.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      color: secondary,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CustomText(
                                      text: '${widget.eventPrize} USD',
                                      weight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (hasBalance.value == false)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 320,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(text: "YOU DO NOT HAVE ENOUGH BALANCE", style: TextStyle(color: Colors.red, fontSize: 13, fontFamily: 'Ubuntu')),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                            colors: hasBalance.value == true && hasSummoners.value == true ? <Color>[Colors.blue.shade600, Colors.purple] : <Color>[Colors.grey, Colors.grey],
                          ),
                        ),
                        child: OutlinedButton(
                          onPressed: hasBalance.value == true && hasSummoners.value == true
                              ? () async {
                                  buttonPressed.value = true;
                                  eventController.eventParticipant.length < widget.eventCapacity
                                      ? await eventController.register(
                                                  widget.eventId,
                                                  userController.displayname.value,
                                                  userController.uID.value,
                                                  dropdownValue.value,
                                                  getSummonerId(dropdownValue.value),
                                                  getSummonerRank(dropdownValue.value))
                                          ? [Navigator.of(context).pop()]
                                          : [
                                              showTopSnackBar(
                                                context,
                                                const CustomSnackBar.error(
                                                  message: 'Something went wrong, please try again later.',
                                                ),
                                              ),
                                              buttonPressed.value = false
                                            ]
                                      : [
                                          showTopSnackBar(
                                            context,
                                            const CustomSnackBar.info(
                                              message: 'This tournament has reached the maximum number of participants, please register to another tournament.',
                                            ),
                                          ),
                                          buttonPressed.value = false
                                        ];
                                }
                              : null,
                          style: OutlinedButton.styleFrom(
                              //primary: Colors.purple,
                              //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                              foregroundColor: background,
                              elevation: 0,
                              //primary: Colors.transparent,
                              fixedSize: const Size(250, 40),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
                          child: buttonPressed.value == true
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : CustomText(
                                  text: "REGISTER",
                                  color: hasBalance.value == true && hasSummoners.value == true ? primary : background,
                                  size: 20,
                                  weight: FontWeight.bold,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
