import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/routes.dart';
import 'package:league_arena/dialogues/reset_password_dialogue.dart';
import 'package:league_arena/pages/main/app_portal.dart';
import 'package:league_arena/widgets/snack_bar/custom_snack_bar.dart';
import 'package:league_arena/widgets/snack_bar/top_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  var auth = FirebaseAuth.instance;

  Future<bool> createUser(
      String email, String password, BuildContext context) async {
    try {
      await auth.signUp(email, password).then((_) async {
        var user = await auth.getUser();
        if (await userController.register(user.id, email)) {
          sendVerification(context);
        }
      });
      return true;
    } on AuthException catch (e) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: e.message,
        ),
      );
    }
    return false;
  }

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      await auth.signIn(email, password).then((_) async {
        var user = await auth.getUser();
        if (await userController.login(user.id)) {
          routemaster.pop(rootRoute);
        }
      });
      return true;
    } on AuthException catch (e) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: e.message,
        ),
      );
    }
    return false;
  }

  Future<bool> sendVerification(BuildContext context) async {
    try {
      await auth.requestEmailVerification().then((_) async {
        //var user = await auth.getUser();
        //routemaster.push(verifyEmailRoute, queryParameters: {'email': user.email as String});
      });
      return true;
    } on AuthException catch (e) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: e.message,
        ),
      );
    }
    return false;
  }

  Future<bool> passwordReset(String email, BuildContext context) async {
    try {
      await auth.resetPassword(email).then((_) {
       showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => ResetPasswordDialogue(email: email,));
      });
      return true;
    } on AuthException catch (e) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: e.message,
        ),
      );
    }
    return false;
  }

  Future<bool> checkVerification() async {
    var user = await auth.getUser();
    if (user.emailVerified!) {
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    auth.signOut();
    prefs.remove('userId');
    prefs.remove('userUid');
    prefs.remove('userEmail');
    prefs.remove('userTokens');
    prefs.remove('userBalance');
    prefs.remove('userDisplayName');
    userController.doInit();
    routemaster.replace(homeScreenRoute);
  }
}
