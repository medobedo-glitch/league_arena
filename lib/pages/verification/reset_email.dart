import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class ResetEmail extends StatefulWidget {
  const ResetEmail({Key? key}) : super(key: key);

  @override
  _ResetEmailState createState() => _ResetEmailState();
}

class _ResetEmailState extends State<ResetEmail> {
  @override
  Widget build(BuildContext context) {
    var data = RouteData.of(context).queryParameters;
    double _height = MediaQuery.of(context).size.height;
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
                                          ? "Please follow the email sent to (${data['email']}) in order to reset you League Arena account password."
                                          : "Invalid Request!\n there was no password reset upon user request.",
                                      style: GoogleFonts.ubuntu(textStyle: TextStyle(
                                          color: primary, fontSize: 20))),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "RETURN TO HOME SCREEN",
                                      style:
                                          GoogleFonts.ubuntu(textStyle: const TextStyle(color: Colors.blue)),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Routemaster.of(context)
                                              .push(homeScreenRoute);
                                        }),
                                ],
                              ),
                            ),
                            const SizedBox(
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
