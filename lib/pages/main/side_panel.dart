import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/dialogues/add_summoner_dialogue.dart';
import 'package:league_arena/dialogues/display_name_dialogue.dart';
import 'package:league_arena/pages/auth/screens/auth_sign_in_panel.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:league_arena/widgets/summoner_details.dart';

class SidePanel extends StatefulWidget {
  const SidePanel({Key? key}) : super(key: key);

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Obx(
      () => Container(
        decoration: BoxDecoration(color: card),
        width: 290,
        height: height - 43,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: userController.uID.value != ''
                      ? 5 // signed-In
                      : height * 0.20 // signed-out
                  ),
              child: Column(
                children: [
                  userController.uID.value != ''
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              userController.profilePic.value != ''
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 7),
                                      child: Container(
                                        height: 47,
                                        width: 47,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: secondary, width: 0),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: AdvancedNetworkImage(
                                                userController.profilePic.value,
                                                useDiskCache: true,
                                                cacheRule: const CacheRule(maxAge: Duration(days: 1)),
                                              ),
                                              filterQuality: FilterQuality.high,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(right: 2),
                                      child: Icon(
                                        Icons.account_circle,
                                        size: 57,
                                        color: secondary,
                                      ),
                                    ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 190,
                                        alignment: Alignment.topLeft,
                                        child: userController.displayname.value != ''
                                            ? Text(
                                                userController.displayname.value,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: false,
                                                style: GoogleFonts.ubuntu(textStyle: const TextStyle(color: Colors.blue, fontSize: 17, fontWeight: FontWeight.bold)),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                    setState(() {
                                                      showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => const SetDisplayName());
                                                    });
                                                  });
                                                },
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: "SET DISPLAY NAME",
                                                        style: GoogleFonts.ubuntu(textStyle: const TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  SizedBox(
                                    width: 190,
                                    child: Text(
                                      userController.email.value,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 13)),
                                    ),
                                  )
                                ],
                              ),
                              IconButton(
                                padding: const EdgeInsets.only(
                                  bottom: 5,
                                ),
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    setState(() {
                                      showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => const SetDisplayName());
                                    });
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit_note,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 1,
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  userController.uID.value != ''
                      ? Column(
                          children: [
                            Container(
                              color: background.withOpacity(0.8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Tooltip(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover.withOpacity(0.8)),
                                        waitDuration: const Duration(milliseconds: 200),
                                        textStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 12)),
                                        message: 'Account Participation Balance\nValue in USD',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.payments_outlined,
                                              color: secondary,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            CustomText(text: '${userController.tokens.value}'),
                                          ],
                                        )),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Tooltip(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover.withOpacity(0.8)),
                                        waitDuration: const Duration(milliseconds: 200),
                                        textStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 12)),
                                        message: 'Account Prize Balance\nValue in USD',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.emoji_events_outlined,
                                              color: secondary,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            CustomText(text: '${userController.balance.value}'),
                                          ],
                                        )),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Tooltip(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover.withOpacity(0.8)),
                                        waitDuration: const Duration(milliseconds: 200),
                                        textStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 12)),
                                        message: 'Win Rate\nBased on ${userController.balance.value} Games Played',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.calculate_outlined,
                                              color: secondary,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            CustomText(
                                                text: '${userController.balance.value}'
                                                    '%'),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: CustomText(
                                    text: 'Summoner Details',
                                    color: secondary,
                                    size: 18,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    gradient: LinearGradient(
                                      colors: <Color>[Colors.blue.shade600, Colors.purple],
                                    ),
                                  ),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => const AddSummoner());
                                        });
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                        color: primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            userController.summoners.isNotEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      for (var item in userController.summoners)
                                        SummonerDetails(summonerName: item['summoner_name'], summonerId: item['summoner_id'], summonerRegion: item['region'])
                                    ],
                                  )
                                : Column(
                                    children: const [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomText(
                                        text: "You haven't added any accounts yet.",
                                        size: 15,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const AuthLoginScreen(),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
