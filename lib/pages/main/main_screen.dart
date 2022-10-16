import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/dialogs/add_summoner_dialog.dart';
import 'package:league_arena/utils/windows_buttons.dart';
import 'package:league_arena/widgets/summoner_details.dart';
import 'package:league_arena/routes/routes.dart';
import 'package:league_arena/utils/content_view.dart';
import 'package:league_arena/widgets/custom_tab.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:league_arena/dialogs/display_name_dialog.dart';
import 'package:league_arena/widgets/top_navigation_bar.dart';
import 'package:routemaster/routemaster.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final _emailValid = false.obs;
  final _passwordValid = false.obs;
  final _buttonPressed = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Size calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }

  @override
  void initState() {
    userController.doInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    if (userController.uID.value != '') {
      emailController.clear();
      passwordController.clear();
      _buttonPressed.value = false;
    }

    //bool _namebuttonPressed = false;
    //final _nameController = TextEditingController();

    //Size _paddingSize = const Size(1, 1);

    var homeTabString = "HOME";
    Size homeTabSize = calcTextSize(homeTabString, GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)));

    var sponsorsTabString = "UNNAMED_TAB";
    Size sponsorsTabSize = calcTextSize(sponsorsTabString, GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)));

    List<ContentView> contentViews = [
      ContentView(
          tab: CustomTab(
            width: homeTabSize.width + 5,
            title: homeTabString,
          ),
          content: homeScreenRoute,
          index: 0),
      ContentView(
          tab: CustomTab(
            width: sponsorsTabSize.width + 5,
            title: sponsorsTabString,
          ),
          content: sponsorsScreenRoute,
          index: 1)
    ];

    // TabController tabController =
    //     TabController(length: contentViews.length, vsync: this);

    final tabPage = TabPage.of(context);

    return Obx(
      () => Row(
        children: [
          SizedBox(
            width: _width - 293,
            height: _height,
            child: Scaffold(
              appBar: topNavigationBar(context, tabPage, contentViews),
              //key: scaffoldKey,
              extendBodyBehindAppBar: true,
              body: TabBarView(
                controller: tabPage.controller,
                children: [
                  for (final stack in tabPage.stacks) PageStackNavigator(stack: stack),
                ],
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            color: secondary,
            thickness: 0.3,
          ),
          //Expanded(child: Container()),
          // const SizedBox(
          //   width: 10,
          // ),

          Column(
            children: [
              Container(
                  //margin: const EdgeInsets.all(5),
                  //padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: card),
                  width: 290,
                  height: _height - 43,
                  child: Scaffold(
                    backgroundColor: card,
                    body: ListView(
                      children: [
                        WindowTitleBarBox(
                          child: const WindowsButtons(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: userController.uID.value != ''
                                  ? 20 // signed-In
                                  : _height * 0.20 // signed-out
                              ),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (userController.uID.value != '')
                                Container(
                                  height: 30,
                                  width: 180,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text: 'Account Details',
                                        color: primary,
                                        weight: FontWeight.bold,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              userController.uID.value != ''
                                  ? const Icon(
                                      Icons.account_circle_outlined,
                                      size: 50,
                                      color: Colors.grey,
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
                                        // RichText(
                                        //   //textAlign: TextAlign.start,
                                        //   text: TextSpan(
                                        //     children: [
                                        //       TextSpan(
                                        //           text: "Account Details",
                                        //           style: GoogleFonts.ubuntu(
                                        //               textStyle: TextStyle(
                                        //                   color: secondary,
                                        //                   fontSize: 20,
                                        //                   fontWeight:
                                        //                       FontWeight
                                        //                           .bold))),
                                        //     ],
                                        //   ),
                                        // ),
                                        // const SizedBox(height: 5,),
                                        // Container(height: 1, width: 270, color: secondary,),
                                        // const SizedBox(height: 10,),
                                        userController.displayname.value != ''
                                            ? RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: '${userController.displayname.value}'
                                                            '#${userController.id.value}',
                                                        style: GoogleFonts.ubuntu(
                                                            textStyle: const TextStyle(color: Colors.lightBlueAccent, fontSize: 20, fontWeight: FontWeight.bold))),
                                                  ],
                                                ),
                                              )
                                            : Tooltip(
                                                textStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 12)),
                                                padding: const EdgeInsets.all(10),
                                                message: 'Set your Display Name.',
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text: "SET DISPLAY NAME",
                                                              style: GoogleFonts.ubuntu(textStyle: const TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold)),
                                                              recognizer: TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                    setState(() {
                                                                      showDialog(
                                                                          barrierDismissible: false, context: context, builder: (BuildContext context) => const SetDisplayName());
                                                                    });
                                                                  });
                                                                }),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                  ],
                                                )),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: userController.email.value,
                                                  style: GoogleFonts.ubuntu(
                                                      textStyle: TextStyle(
                                                    color: primary,
                                                    fontSize: 13,
                                                  ))),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Tooltip(
                                                textStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 12)),
                                                padding: const EdgeInsets.all(10),
                                                message: 'Account Token Balance\nValued by ${userController.tokens.value * 0.60} USD.',
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.account_balance_wallet_outlined,
                                                      color: Colors.greenAccent,
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
                                                textStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 12)),
                                                padding: const EdgeInsets.all(10),
                                                message: 'Account Prize Balance\nUSD.',
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.paid_outlined,
                                                      color: Colors.yellowAccent,
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
                                                textStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 12)),
                                                padding: const EdgeInsets.all(10),
                                                message: 'Win Rate\nBased on ${userController.balance.value} Games Played.',
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.calculate_outlined,
                                                      color: Colors.purpleAccent,
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

                                        // const SizedBox(
                                        //   height: 20,
                                        // ),
                                        // CustomText(
                                        //   text: 'Summoner Details',
                                        //   color: secondary,
                                        //   size: 20,
                                        //   weight: FontWeight.bold,
                                        // ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 1,
                                          width: 270,
                                          color: secondary,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 30,
                                          width: 140,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                CustomText(
                                                  text: 'Summoners',
                                                  color: primary,
                                                  weight: FontWeight.bold,
                                                  size: 20,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        userController.summoners.isNotEmpty
                                            ? Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  for (var item in userController.summoners)
                                                    SummonerDetails(summonerName: item['summoner_name'], summonerId: item['summoner_id'], summonerRegion: item['summoner_region'])
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
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.0),
                                            gradient: LinearGradient(
                                              colors: <Color>[Colors.blue.shade600, Colors.purple],
                                            ),
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                setState(() {
                                                  showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => const AddSummoner());
                                                });
                                              });
                                            },
                                            child: CustomText(
                                              text: "ADD SUMMONER",
                                              color: primary,
                                              size: 15,
                                              weight: FontWeight.bold,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shadowColor: Colors.transparent,
                                              elevation: 0,
                                              primary: Colors.transparent,
                                              //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                              fixedSize: const Size(200, 35),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                              // textStyle: const TextStyle(
                                              //     fontSize: 20, fontWeight: FontWeight.bold)
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 115,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: hover),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              RichText(
                                                //textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: "SIGN IN",
                                                        style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 25, fontWeight: FontWeight.bold))),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                          //textAlign: TextAlign.start,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: "Sign In to your League Arena account.",
                                                  style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 15, fontWeight: FontWeight.bold))),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            // Container(
                                            //   width: 270,
                                            //   height: 1,
                                            //   color: secondary,
                                            // ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 260,
                                              child: TextFormField(
                                                keyboardType: TextInputType.emailAddress,
                                                textInputAction: TextInputAction.next,
                                                autovalidateMode: AutovalidateMode.always,
                                                validator: (value) {
                                                  if (GetUtils.isEmail(emailController.value.text)) {
                                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                      _emailValid.value = true;
                                                    });
                                                  } else {
                                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                      _emailValid.value = false;
                                                    });
                                                  }
                                                  return null;
                                                },
                                                controller: emailController,
                                                style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 15)),
                                                decoration: InputDecoration(
                                                  labelText: "EMAIL",
                                                  hintText: "MUST BE A VALID EMAIL ADDRESS",
                                                  hintStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 10)),
                                                  labelStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary)),
                                                  enabledBorder: OutlineInputBorder(//borderRadius: BorderRadius.circular(10), 
                                                  borderSide: BorderSide(color: primary)),
                                                  focusedBorder: OutlineInputBorder(//borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(color: primary)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 260,
                                              child: TextFormField(
                                                onFieldSubmitted: _emailValid.value == true && _passwordValid.value == true
                                                    ? (_) async {
                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                          setState(() {
                                                            _buttonPressed.value = true;
                                                          });
                                                        });
                                                        await authController.login(emailController.value.text, passwordController.value.text, context)
                                                            ? null
                                                            : WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                setState(() {
                                                                  _buttonPressed.value = false;
                                                                });
                                                              });
                                                      }
                                                    : null,
                                                autovalidateMode: AutovalidateMode.always,
                                                validator: (value) {
                                                  if (GetUtils.isLengthGreaterOrEqual(passwordController.value.text, 6)) {
                                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                      setState(() {
                                                        _passwordValid.value = true;
                                                      });
                                                    });
                                                  } else {
                                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                      setState(() {
                                                        _passwordValid.value = false;
                                                      });
                                                    });
                                                  }
                                                  return null;
                                                },
                                                controller: passwordController,
                                                style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 15)),
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                  labelText: "PASSWORD",
                                                  hintText: "MUST BE 6 CHARACTERS AT LEAST",
                                                  hintStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary, fontSize: 10)),
                                                  labelStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary)),
                                                  enabledBorder: OutlineInputBorder(
                                                    //borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: primary),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(//borderRadius: BorderRadius.circular(10), 
                                                  borderSide: BorderSide(color: primary)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 20),
                                              child: Tooltip(
                                                textStyle: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 12)),
                                                padding: const EdgeInsets.all(10),
                                                message: 'Signed In users are saved and remembered automatically,\nYou will need to sign out manually.',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      EvaIcons.alertCircle,
                                                      color: secondary,
                                                      size: 15,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    const CustomText(
                                                      text: "YOU WILL STAY SIGNED IN",
                                                      size: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30.0),
                                                gradient: LinearGradient(
                                                  colors: <Color>[Colors.blue.shade600, Colors.purple],
                                                ),
                                              ),
                                              width: 260,
                                              height: 40,
                                              child: ElevatedButton(
                                                onPressed: _emailValid.value == true && _passwordValid.value == true
                                                    ? () async {
                                                        // final Map<String, dynamic> data = await postHelper(loginUrl, {"email" : emailController.value.text, "password" : passwordController.value.text});
                                                        // if (data["user"] != null){
                                                        //   print(data["user"]["id"]);
                                                        //   print(data["user"]["email"]);
                                                        // }
                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                          setState(() {
                                                            _buttonPressed.value = true;
                                                          });
                                                        });
                                                        await authController.login(emailController.value.text, passwordController.value.text, context)
                                                            ? null
                                                            : WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                setState(() {
                                                                  _buttonPressed.value = false;
                                                                });
                                                              });
                                                      }
                                                    : null,
                                                child: _buttonPressed.value == true
                                                    ? const SizedBox(
                                                        height: 25,
                                                        width: 25,
                                                        child: CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : CustomText(
                                                        text: "SIGN IN",
                                                        color: _emailValid.value == true && _passwordValid.value == true ? primary : secondary,
                                                        size: 15,
                                                        weight: FontWeight.bold,
                                                      ),
                                                style: ElevatedButton.styleFrom(
                                                    shadowColor: Colors.transparent,
                                                    elevation: 0,
                                                    primary: Colors.transparent,
                                                    //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                                    fixedSize: const Size(350, 50),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                    textStyle: GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            // ElevatedButton(
                                            //   onPressed: () {
                                            //     Routemaster.of(context)
                                            //         .push(authPageLoginRoute);
                                            //   },
                                            //   child: CustomText(
                                            //     text: "SIGN IN",
                                            //     color: primary,
                                            //     size: 20,
                                            //     weight: FontWeight.bold,
                                            //   ),
                                            //   style: ElevatedButton.styleFrom(
                                            //     //primary: Colors.purple,
                                            //     //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                            //     fixedSize:
                                            //         const Size(200, 35),
                                            //     // shape: RoundedRectangleBorder(
                                            //     //     borderRadius: BorderRadius.circular(30)),
                                            //     // textStyle: const TextStyle(
                                            //     //     fontSize: 20, fontWeight: FontWeight.bold)
                                            //   ),
                                            // ),
                                            // const SizedBox(
                                            //   height: 5,
                                            // ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: "CAN'T SIGN IN?",
                                                      style: GoogleFonts.ubuntu(textStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                                      recognizer: TapGestureRecognizer()
                                                        ..onTap = () {
                                                          Routemaster.of(context).push(authForgotPasswordRoute);
                                                        }),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const CustomText(
                                              text: '- OR -',
                                              weight: FontWeight.bold,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30.0),
                                                gradient: LinearGradient(
                                                  colors: <Color>[Colors.blue.shade600, Colors.purple],
                                                ),
                                              ),
                                              width: 260,
                                              height: 40,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Routemaster.of(context).push(authPageRegisterRoute);
                                                },
                                                child: CustomText(
                                                  text: "CREATE ACCOUNT",
                                                  color: primary,
                                                  size: 15,
                                                  weight: FontWeight.bold,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    shadowColor: Colors.transparent,
                                                    elevation: 0,
                                                    primary: Colors.transparent,
                                                    //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                                    fixedSize: const Size(350, 50),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                    textStyle: GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            // RichText(
                                            //   textAlign: TextAlign.center,
                                            //   text: TextSpan(
                                            //     children: [
                                            //       TextSpan(
                                            //           text: "to continue.",
                                            //           style: GoogleFonts.ubuntu(
                                            //               textStyle: TextStyle(
                                            //                   color: primary,
                                            //                   fontSize: 15,
                                            //                   fontWeight:
                                            //                       FontWeight
                                            //                           .bold))),
                                            //     ],
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )),
              Container(
                color: secondary,
                height: 1,
                width: 290,
              ),
              Container(
                width: 290,
                height: 39,
                decoration: BoxDecoration(
                  color: card,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(text: "© 2021 League Arena.", style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
