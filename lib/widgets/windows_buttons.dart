import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:league_arena/constants/style.dart';

class WindowsButtons extends StatelessWidget {
  const WindowsButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: MoveWindow()),
          MinimizeWindowButton(
            colors: WindowButtonColors(iconNormal: secondary),
          ),
          MaximizeWindowButton(
            colors: WindowButtonColors(iconNormal: secondary),
          ),
          CloseWindowButton(
            colors: WindowButtonColors(iconNormal: secondary, mouseOver: Colors.red),
          ),
        ],
      ),
    );
  }
}
