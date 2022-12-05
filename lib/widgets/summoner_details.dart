import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';

class SummonerDetails extends StatefulWidget {
  final String summonerName;
  final String summonerId;
  final String summonerRegion;
  final String summonerRank;
  const SummonerDetails({Key? key, required this.summonerName, required this.summonerId, required this.summonerRegion, required this.summonerRank}) : super(key: key);

  @override
  State<SummonerDetails> createState() => _SummonerDetailsState();
}

class _SummonerDetailsState extends State<SummonerDetails> {
  var size = 50.0.obs;
  var removing = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(bottom: 5),
        height: size.value,
        width: 270,
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(10)),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Tooltip(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover.withOpacity(0.8)),
                                    waitDuration: const Duration(milliseconds: 300),
                                    message: widget.summonerName,
                                    child: SizedBox(
                                        width: 150,
                                        child: Text(
                                          widget.summonerName,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: false,
                                          style: TextStyle(color: primary, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                                        )),
                                  ),
                                  CustomText(text: widget.summonerRank != '' ? widget.summonerRank : 'UNRANKED', weight: FontWeight.bold, size: 12, color: Colors.lightBlueAccent),
                                ],
                              ),
                            )
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: CustomText(
                                text: 'Confirm Removing Summoner?',
                                weight: FontWeight.bold,
                                size: 13,
                              ),
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
                          decoration: BoxDecoration(color: hover, borderRadius: BorderRadius.circular(2)),
                          child: CustomText(
                            text: widget.summonerRegion,
                            weight: FontWeight.bold,
                          ),
                        )
                      : Tooltip(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover.withOpacity(0.8)),
                          waitDuration: const Duration(milliseconds: 200),
                          message: 'Confirm',
                          child: IconButton(
                            onPressed: () async {
                              await userController.removeSummoner(widget.summonerName, widget.summonerRegion)
                                  ? [
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        removing.value = false;
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
                          ),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  Tooltip(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover.withOpacity(0.8)),
                    waitDuration: const Duration(milliseconds: 200),
                    message: removing.value == false ? 'Remove' : 'Cancel',
                    child: IconButton(
                      onPressed: () {
                        removing.value == false ? removing.value = true : removing.value = false;
                      },
                      icon: removing.value == false ? const Icon(Icons.remove_circle_outline) : const Icon(Icons.close_sharp),
                      iconSize: removing.value == false ? 15 : 20,
                      color: Colors.redAccent,
                      padding: EdgeInsets.zero,
                      splashRadius: 1,
                      constraints: const BoxConstraints(),
                    ),
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
