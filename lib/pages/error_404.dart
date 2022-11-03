import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/routes.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:routemaster/routemaster.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //setPageTitle(notFoundDisplyName, context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/image/error.png",
            width: 350,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CustomText(
                text: "Page Not Found!",
                size: 24,
                weight: FontWeight.bold,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "RETURN TO HOME SCREEN",
                    style: GoogleFonts.ubuntu(textStyle: const TextStyle(color: Colors.blue)),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Routemaster.of(context).push(rootRoute);
                      }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
