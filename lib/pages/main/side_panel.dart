import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/dialogs/add_summoner_dialog.dart';
import 'package:league_arena/dialogs/display_name_dialog.dart';
import 'package:league_arena/pages/auth/screens/auth_sign_in_panel.dart';
import 'package:league_arena/widgets/community_user.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:league_arena/widgets/smooth_scroll.dart';
import 'package:league_arena/widgets/summoner_details.dart';
import 'package:progress_indicators/progress_indicators.dart';

class SidePanel extends StatefulWidget {
  const SidePanel({Key? key}) : super(key: key);

  @override
  State<SidePanel> createState() => _SidePanelState();
}

Future<void> checkVerification2() async {
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (authController.auth.currentUser != null) {
      userController.emailVerified.value = await authController.checkVerification();
      if (userController.emailVerified.value == true) {
        timer.cancel();
      }
    }
  });
}

Future<String> getRank(String id, String region) async {
  return await userController.getSummonerLeague(id, region);
}

class _SidePanelState extends State<SidePanel> {
  var sendAgain = false.obs;
  var summoners = [].obs;
  ScrollController sc1 = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
        child: Container(
          decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(5)),
          width: 300,
          height: height - 20,
          child: authController.isLoading.value != true
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: userController.uID.value != ''
                              ? 5 // signed-In
                              : height * 0.20 // signed-out
                          ),
                      child: Column(
                        children: [
                          (userController.uID.value != '')
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      userController.profilePic.value != ''
                                          ? Padding(
                                              padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                                              child: Container(
                                                height: 47,
                                                width: 47,
                                                decoration: BoxDecoration(
                                                    //border: Border.all(color: secondary, width: 0),
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: AdvancedNetworkImage(
                                                        userController.profilePic.value,
                                                        useDiskCache: true,
                                                        cacheRule: const CacheRule(maxAge: Duration(days: 30)),
                                                      ),
                                                      filterQuality: FilterQuality.medium,
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 47,
                                                width: 47,
                                                decoration: BoxDecoration(
                                                    //border: Border.all(color: secondary, width: 0),
                                                    shape: BoxShape.circle,
                                                    color: hover),
                                                child: CustomText(
                                                  text: userController.displayname.value != '' ? userController.displayname.value[0].toUpperCase() : 'S',
                                                  weight: FontWeight.bold,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 197,
                                                alignment: Alignment.topLeft,
                                                child: userController.displayname.value != ''
                                                    ? Text(
                                                        userController.displayname.value,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        style: const TextStyle(color: Colors.blue, fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
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
                                                          text: const TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: "SET DISPLAY NAME",
                                                                style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
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
                                              style: TextStyle(color: primary, fontSize: 13, fontFamily: 'Ubuntu'),
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: hover, //background.withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(30)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Tooltip(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover.withOpacity(0.8)),
                                                  waitDuration: const Duration(milliseconds: 200),
                                                  textStyle: TextStyle(color: primary, fontSize: 12, fontFamily: 'Ubuntu'),
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
                                                  textStyle: TextStyle(color: primary, fontSize: 12, fontFamily: 'Ubuntu'),
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
                                                  textStyle: TextStyle(color: primary, fontSize: 12, fontFamily: 'Ubuntu'),
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
                                    ),
                                    if (userController.emailVerified.value == false)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                        child: Container(
                                          //width: 290,
                                          //height: 90,
                                          decoration: BoxDecoration(color: Colors.lightBlue, borderRadius: BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.notification_important_outlined,
                                                  color: background,
                                                  size: 35,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CustomText(
                                                      text: 'Verify Email',
                                                      size: 17,
                                                      weight: FontWeight.bold,
                                                      color: background,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width: 230,
                                                      //decoration: BoxDecoration(border: Border.all(color: background)),
                                                      alignment: Alignment.centerLeft,
                                                      child: RichText(
                                                        textAlign: TextAlign.start,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text: 'Verification email has been sent to ${userController.email.value}',
                                                                style: TextStyle(color: background, fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'Ubuntu')),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    InkWell(
                                                      onTap: sendAgain.value == false
                                                          ? () async {
                                                              sendAgain.value = true;
                                                              await authController.sendVerification();
                                                            }
                                                          : null,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            sendAgain.value == false ? 'SEND AGAIN?' : 'SENT',
                                                            style: TextStyle(
                                                                color: background,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 15,
                                                                decoration: sendAgain.value == false ? TextDecoration.underline : TextDecoration.none,
                                                                fontFamily: 'Ubuntu'),
                                                          ),
                                                          if (sendAgain.value == true) const Icon(Icons.done_all),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      height: userController.emailVerified.value == true ? height - 189 : height - 307,
                                      child: SmoothScroll(
                                        controller: sc1,
                                        child: ListView(
                                          controller: sc1,
                                          physics: const NeverScrollableScrollPhysics(),
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: CustomText(
                                                    text: 'Summoner Details',
                                                    color: primary,
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
                                            userController.summonersLoadEUNE.isNotEmpty || userController.summonersLoadEUW.isNotEmpty
                                                ? Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      for (var item in userController.summonersLoadEUW)
                                                        SummonerDetails(
                                                          summonerName: item['name'],
                                                          summonerId: item['summoner_id'],
                                                          summonerRegion: item['region'],
                                                          summonerRank: item['rank'],
                                                        ),
                                                      for (var item in userController.summonersLoadEUNE)
                                                        SummonerDetails (
                                                          summonerName: item['name'],
                                                          summonerId: item['summoner_id'],
                                                          summonerRegion: item['region'],
                                                          summonerRank: item['rank'],
                                                        )
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: CustomText(
                                                    text: 'Community (${userController.onlineUserCount.value} online)',
                                                    color: primary,
                                                    size: 18,
                                                    weight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                for (var item in userController.communityUsers)
                                                  CommunityUser(
                                                      userDisplayName: item['displayname'],
                                                      userUid: item['uid'],
                                                      userProfilePic: item['profile_pic'],
                                                      userPresence: item['presence'])
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : const AuthLoginScreen(),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      width: 290,
                      height: 0.5,
                      color: hover,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(text: "© 2022 League Arena.", style: TextStyle(color: primary, fontFamily: 'Ubuntu')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  height: height - 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GlowingProgressIndicator(
                          child: Image.asset(
                        'assets/icon/logo2.png',
                        scale: 10,
                      )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
