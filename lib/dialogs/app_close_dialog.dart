import 'dart:io';
import 'package:flutter/material.dart';
import 'package:league_arena/constants/routes.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/main.dart';
import 'package:league_arena/widgets/custom_text.dart';

class AppCloseDialog extends StatefulWidget {
  const AppCloseDialog({Key? key}) : super(key: key);

  @override
  State<AppCloseDialog> createState() => _AppCloseDialogState();
}

class _AppCloseDialogState extends State<AppCloseDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: card,
      child: Container(
        height: 190,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'EXIT CLIENT',
                  size: 25,
                  weight: FontWeight.bold,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: CustomText(
                    text: "Choose whether you would like to exit or sign out",
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text(
                      'Exit Client',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      exit(0);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
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
