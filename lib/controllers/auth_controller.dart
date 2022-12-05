import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/constants.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/routes.dart';
import 'package:league_arena/main.dart';
import 'package:league_arena/pages/main/side_panel.dart';
import 'package:league_arena/widgets/snack_bar/custom_snack_bar.dart';
import 'package:league_arena/widgets/snack_bar/top_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  var auth = FirebaseAuth.instance;
  User? currentUser;
  BuildContext? context;

  var isLoading = true.obs;

  Future<User?> getCurrentUser() async {
    auth.userChanges().listen((user) {
      if (user != null) {
        currentUser = user;
      }
    });
    return currentUser;
  }

  Future<bool> checkVerification() async {
    auth.currentUser?.reload();
    bool verified = auth.currentUser!.emailVerified;
    return verified;
  }

  Future<bool> createUser(String email, String password, BuildContext context) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password).then((_) async {
        DatabaseReference ref = database.ref('/users/${auth.currentUser?.uid}');
        final data = <String, dynamic>{"email": email, "tokens": 0, "balance": 0, "displayname": '', "profile_pic": '', "locked_event": '', 'presence': false};
        ref.set(data);
        await login(email, password, context);
        sendVerification();
      });
      return true;
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: '${e.message}',
        ),
      );
    }
    return false;
  }

  Future<bool> login(String email, String password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password).then((_) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userUid', auth.currentUser!.uid);
        await internalLogin(auth.currentUser!.uid);
        await auth.setPersistence(Persistence.LOCAL);
      });
      return true;
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: '${e.message}',
        ),
      );
    }
    return false;
  }

  Future<bool> internalLogin(String uid, [bool clean = false]) async {
    DatabaseReference userRef = database.ref('/users/$uid');

    var isOfflineForDatabase = {
      'presence': false,
    };

    var isOnlineForDatabase = {
      'presence': true,
    };

    if (clean) {
      await userRef.update(isOfflineForDatabase);
      userController.uID.value = '';
      userController.email.value = '';
      userController.tokens.value = 0.0;
      userController.balance.value = 0.0;
      userController.displayname.value = '';
      userController.profilePic.value = '';
      userController.lockedEvent.value = '';
      //isLoading.value = false;
    } else {
      try {
        accountListener = userRef.onValue.listen((DatabaseEvent event) {
          final data = event.snapshot.value as Map<String, dynamic>;
          userController.uID.value = uid;
          userController.email.value = data['email'];
          userController.tokens.value = data['tokens'];
          userController.balance.value = data['balance'];
          userController.displayname.value = data['displayname'];
          userController.profilePic.value = data['profile_pic'];
          userController.lockedEvent.value = data['locked_event'];
        });

        await userRef.update(isOnlineForDatabase);
        await userRef.onDisconnect().update(isOfflineForDatabase);
        await checkVerification2();
        await userController.getSummonerLinked(uid);
        await userController.getCommunityUsers().then((value) {
          isLoading.value = false;
        });
      } on Exception catch (_) {}
    }

    return true;
  }

  Future<bool> sendVerification() async {
    try {
      await auth.currentUser!.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        context!,
        CustomSnackBar.error(
          message: '${e.message}',
        ),
      );
    }
    return false;
  }

  Future<bool> passwordReset(String email, BuildContext context) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: '${e.message}',
        ),
      );
    }
    return false;
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountListener?.cancel();
    euwSummonersListener?.cancel();
    euneSummonersListener?.cancel();
    onlineUserListener?.cancel();
    userController.summonersLoadEUW.value = [];
    userController.summonersLoadEUNE.value = [];
    userController.leagues.value = [];
    userController.communityUsers.value = [];
    userController.emailVerified.value = true;
    await internalLogin('${prefs.getString('userUid')}', true);
    await prefs.remove('userUid');
    await auth.signOut();
    routemaster.replace(homeScreenRoute);
  }
}
