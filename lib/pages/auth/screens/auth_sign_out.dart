import 'dart:async';

import 'package:flutter/material.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/widgets/custom_text.dart';

class AuthSignOutScreen extends StatefulWidget {
  const AuthSignOutScreen({Key? key}) : super(key: key);

  @override
  State<AuthSignOutScreen> createState() => _AuthSignOutScreenState();
}

class _AuthSignOutScreenState extends State<AuthSignOutScreen> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      authController.signOut();
      timer.cancel();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CustomText(text: 'Signing you out, you will be redirected soon ....', size: 18, weight: FontWeight.bold,),
      ),
    );
  }
}
