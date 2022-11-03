import 'package:flutter/material.dart';

class SponsorsScreen extends StatefulWidget {
  const SponsorsScreen({Key? key}) : super(key: key);

  @override
  State<SponsorsScreen> createState() => _SponsorsScreenState();
}

class _SponsorsScreenState extends State<SponsorsScreen> {

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.red,
      ),
    );
  }
}
