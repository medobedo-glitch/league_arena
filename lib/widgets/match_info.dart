import 'package:flutter/material.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';

class MatchInfo extends StatefulWidget {
  final int id;
  final Size pos;
  const MatchInfo({super.key, required this.id, required this.pos});

  @override
  State<MatchInfo> createState() => _MatchInfoState();
}

class _MatchInfoState extends State<MatchInfo> {
  String p1 = '';
  String p2 = '';

  @override
  void initState() {
    for (var item in eventController.eventMatches) {
      if (item['id'] == widget.id && item['players'] != null) {
        p1 = item['players'][0];
        p2 = item['players'][1];
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //print(widget);
      },
      child: Container(
          width: 200,
          height: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: hover, spreadRadius: 1),
              ],
              border: Border.all(color: secondary, width: 0.2)),
          child: Column(
            children: [
              Expanded(child: Container()),
              Container(alignment: Alignment.center, child: CustomText(text: p1 != '' ? 'Player($p1)' : p1)),
              Expanded(child: Container()),
              Container(
                color: secondary,
                width: 200,
                height: 0.5,
              ),
              Expanded(child: Container()),
              Container(alignment: Alignment.center, child: CustomText(text: p2 != '' ? 'Player($p2)' : p2)),
              Expanded(child: Container()),
            ],
          )),
    );
  }
}
