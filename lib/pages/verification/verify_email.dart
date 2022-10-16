import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  Timer? timer;

  void checkVerification(String? user) {}

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      var user = RouteData.of(context).queryParameters;
      if (user['email'] != null) {
        if (await authController.checkVerification()) {
          Routemaster.of(context).replace(rootRoute);
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
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
    //setPageTitle(verifyEmailDisplyName, context);
    var data = RouteData.of(context).queryParameters;
    double _height = MediaQuery.of(context).size.height;
    //checkVerification(data['email']);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/image/bg3.jpg",
                ),
                fit: BoxFit.cover)),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(15),
                      color: card,
                    ),
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(24),
                    margin: EdgeInsets.only(top: _height / 7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: _height / 30),
                              child: Image.asset(
                                "assets/icon/logo2.png",
                                scale: 6,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            Icon(
                              data['email'] != null
                                  ? EvaIcons.checkmarkCircle2
                                  : EvaIcons.closeCircle,
                              color: data['email'] != null
                                  ? Colors.green
                                  : Colors.red,
                              size: 70,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: data['email'] != null
                                          ? "A verification email has been sent to (${data['email']}), Please verify your email to continue."
                                          : "Invalid Request!\n there was no verification requested upon user registeration.",
                                      style: GoogleFonts.ubuntu(textStyle: TextStyle(
                                          color: primary, fontSize: 20))),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            data['email'] == null
                                ? RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "RETURN TO HOME SCREEN",
                                            style: GoogleFonts.ubuntu(textStyle: const TextStyle(
                                                color: Colors.blue)),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                //Get.offAllNamed(authPageLoginRoute);
                                                Routemaster.of(context)
                                                    .push(rootRoute);
                                              }),
                                      ],
                                    ),
                                  )
                                : const SizedBox(
                                    height: 5,
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      "League Arena was created under Riot Games ''Legal Jibber Jabber'' policy using assets owned by Riot Games.\nRiot Games does not endorse or sponsor this project.",
                                  style: GoogleFonts.ubuntu(textStyle: TextStyle(color: secondary))),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "© 2021 League Arena.",
                                  style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
