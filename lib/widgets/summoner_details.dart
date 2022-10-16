import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';

class SummonerDetails extends StatefulWidget {
  final String summonerName;
  final String summonerId;
  final String summonerRegion;
  const SummonerDetails(
      {Key? key,
      required this.summonerName,
      required this.summonerId,
      required this.summonerRegion})
      : super(key: key);

  @override
  _SummonerDetailsState createState() => _SummonerDetailsState();
}

class _SummonerDetailsState extends State<SummonerDetails> {
  @override
  void initState() {
    getRank();
    super.initState();
  }

  Future getRank() async {
    rank.value = await userController.getSummonerLeague(
        widget.summonerId, widget.summonerRegion);
  }

  var size = 50.0.obs;
  var rank = ''.obs;
  var removing = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(bottom: 5),
        height: size.value,
        width: 270,
        decoration: BoxDecoration(
            color: background, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  removing.value == false
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomText(
                              text: widget.summonerName,
                              weight: FontWeight.bold,
                            ),
                            if (rank.value != '')
                              CustomText(
                                  text: rank.value,
                                  weight: FontWeight.bold,
                                  size: 12,
                                  color: Colors.lightBlueAccent),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            CustomText(
                              text: 'Confirm Removing Summoner?',
                              weight: FontWeight.bold,
                              size: 12,
                            ),
                          ],
                        ),
                  Expanded(
                    child: Container(),
                  ),
                  removing.value == false
                      ? Container(
                          alignment: Alignment.center,
                          height: 25,
                          width: 60,
                          decoration: BoxDecoration(
                              color: hover,
                              borderRadius: BorderRadius.circular(2)),
                          child: CustomText(
                            text: widget.summonerRegion,
                            weight: FontWeight.bold,
                          ),
                        )
                      : IconButton(
                          onPressed: () async {
                            await userController
                                    .removeSummoner(widget.summonerId)
                                ? [
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      userController.summoners.value = [];
                                      userController.updateSummoners();
                                    })
                                  ]
                                : null;
                          },
                          icon: const Icon(Icons.done),
                          iconSize: 20,
                          color: Colors.greenAccent,
                          padding: EdgeInsets.zero,
                          splashRadius: 1,
                          constraints: const BoxConstraints(),
                          tooltip: 'Confirm',
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      removing.value == false
                          ? removing.value = true
                          : removing.value = false;
                    },
                    icon: removing.value == false
                        ? const Icon(Icons.remove_circle_outline)
                        : const Icon(Icons.close_sharp),
                    iconSize: removing.value == false ? 15 : 20,
                    color: Colors.redAccent,
                    padding: EdgeInsets.zero,
                    splashRadius: 1,
                    constraints: const BoxConstraints(),
                    tooltip: removing.value == false ? 'Remove' : 'Cancel',
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
