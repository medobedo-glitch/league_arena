import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTab extends StatelessWidget {
  final String title;
  final double width;
  const CustomTab({Key? key, required this.title, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      width: width,
      child: Tab(
        child: Text(
          title,
          style: GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
