import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:league_arena/constants/routes.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/pages/main/app_portal.dart';

class AppCloseDialogue extends StatefulWidget {
  const AppCloseDialogue({Key? key}) : super(key: key);

  @override
  State<AppCloseDialogue> createState() => _AppCloseDialogueState();
}

class _AppCloseDialogueState extends State<AppCloseDialogue> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: card,
      // actions: [
      //   TextButton(
      //     child: const Text('Stay'),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      //   TextButton(
      //     child: const Text('Sign out'),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //       routemaster.replace(signOutScreenRoute);
      //     },
      //   ),
      //   TextButton(
      //     child: const Text('Exit'),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //       exit(0);
      //     },
      //   ),
      // ],
      child: Container(
        height: 170,
        width: 400,
        decoration: BoxDecoration(
          border: /*Border(
                top: BorderSide(color: primary),
                bottom: BorderSide(color: primary)),*/
              Border.all(color: hover, width: 0.5),
          //borderRadius: BorderRadius.circular(30.0),
          color: card,
        ),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Do you want to exit League Arena or Sign out from your account?", style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 16))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text(
                      'Exit',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      exit(0);
                    },
                  ),
                  const SizedBox(width: 10,),
                  TextButton(
                    child: const Text(
                      'Sign out',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      routemaster.replace(signOutScreenRoute);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
