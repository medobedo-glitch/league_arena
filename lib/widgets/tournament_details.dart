import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:routemaster/routemaster.dart';

class TournamentDetails extends StatefulWidget {
  final int id;
  final String name;
  final String region;
  final String type;
  final int capacity;
  final double fee;
  final double prize;
  final String date;
  final String hour;
  final String status;
  final String? eventbanner;
  const TournamentDetails(
      {Key? key,
      required this.id,
      required this.name,
      required this.region,
      required this.capacity,
      required this.fee,
      required this.date,
      required this.hour,
      required this.status,
      required this.type,
      this.eventbanner,
      required this.prize})
      : super(key: key);

  @override
  State<TournamentDetails> createState() => _TournamentDetailsState();
}

class _TournamentDetailsState extends State<TournamentDetails> {
  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: BorderRadius.circular(5),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.lightBlue,
      onTap: () {
        Routemaster.of(context).push('/home/upcoming/event/' '${widget.id}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
                image: AdvancedNetworkImage(
                  '${widget.eventbanner}',
                  useDiskCache: true,
                  cacheRule: const CacheRule(maxAge: Duration(days: 1)),
                ),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high)),
        width: 468,
        height: 100,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), /*color: card.withOpacity(0.4),*/ border: Border.all(width: 0.5, color: secondary)),
          width: 468,
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 0, left: 1, top: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                      //width: nameSize.width + 20,
                      alignment: Alignment.center,
                      decoration:
                          BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)), color: background.withOpacity(0.8)),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(text: widget.name, style: GoogleFonts.ubuntu(textStyle: TextStyle(color: primary, fontSize: 17, fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 1, top: 5),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.5),
                      //alignment: Alignment.center,
                      decoration:
                          BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)), color: background.withOpacity(0.8)),
                      height: 30,
                      //width: 280,
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            size: 20,
                            color: primary,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            text: widget.date,
                            size: 15,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.schedule_outlined,
                            size: 20,
                            color: primary,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            text: '${DateFormat.jm().format(DateTime.parse('${widget.date}T${widget.hour}'))} (EET)',
                            size: 15,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 1, top: 5),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.5),
                      //alignment: Alignment.center,
                      decoration:
                          BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)), color: background.withOpacity(0.8)),
                      height: 30,
                      //width: 215,
                      child: Row(
                        children: [
                          Tooltip(
                            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primary),
                            decoration: BoxDecoration(color: background.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                            message: 'Entry Fee',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.payments_outlined,
                                  size: 20,
                                  color: primary,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  text: widget.fee > 0 ? '${widget.fee}' ' USD' : 'FREE',
                                  size: 15,
                                  weight: FontWeight.bold,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          Tooltip(
                            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primary),
                            decoration: BoxDecoration(color: background.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                            message: 'Prize Per Winning Game',
                            child: Row(children: [
                              Icon(
                                Icons.emoji_events_outlined,
                                size: 20,
                                color: primary,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomText(
                                text: widget.fee > 0 ? '${(widget.fee * 3 / 4).toStringAsFixed(2)}' ' USD' : '${widget.prize}' ' USD',
                                size: 15,
                                weight: FontWeight.bold,
                              ),
                            ]),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Container(
                height: 50,
                decoration:
                    BoxDecoration(color: background.withOpacity(0.7), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), /*color: hover,*/ border: Border.all(color: secondary, width: 0.5)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.public_outlined,
                                size: 20,
                                color: primary,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomText(
                                text: widget.region,
                                size: 15,
                                color: primary,
                                weight: FontWeight.bold,
                              ),
                            ],
                          )),
                      Expanded(child: Container()),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), /*color: hover,*/ border: Border.all(color: secondary, width: 0.5)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 20,
                                color: primary,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomText(
                                text: widget.type,
                                size: 15,
                                color: primary,
                                weight: FontWeight.bold,
                              ),
                            ],
                          )),
                      Expanded(child: Container()),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), /*color: hover,*/ border: Border.all(color: secondary, width: 0.5)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 20,
                                color: primary,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomText(
                                text: '0' '/' '${widget.capacity}',
                                size: 15,
                                color: primary,
                                weight: FontWeight.bold,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
