import 'package:flutter/material.dart';

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
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
        ),
      ),
    );
  }
}

class CustomTab2 extends StatelessWidget {
  final String title;
  final double width;
  const CustomTab2({Key? key, required this.title, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Tab(
        height: 35,
        child: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
        ),
      ),
    );
  }
}
