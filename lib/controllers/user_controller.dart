import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:league_arena/constants/constants.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/env/env.dart';
import 'package:league_arena/helpers/post_helper.dart';
import 'package:league_arena/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/snack_bar/custom_snack_bar.dart';
import '../widgets/snack_bar/top_snack_bar.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  var db = FirebaseFirestore.instance;
  var crypto = Encryption.instance;
  var id = 0.obs;
  var uID = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var tokens = 0.0.obs;
  var balance = 0.0.obs;
  var displayname = ''.obs;
  var profilePic = ''.obs;
  var lockedEvent = ''.obs;
  var emailVerified = true.obs;

  var summonerId = ''.obs;

  var summonersLoadEUW = [].obs;
  var summonersLoadEUNE = [].obs;
  var leagues = [].obs;

  var communityUsers = [].obs;
  var onlineUserCount = 0.obs;

  var iconPicked = 0.obs;
  var iconList = [6, 7, 9, 10, 18, 20, 23, 28].obs;

  var eventRegion = ''.obs;
  var eventStatus = ''.obs;

  var extensions = ['jpg', 'jpeg', 'png', 'gif'];

  var uploadingPic = false.obs;

  Future<void> doInit(bool signIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('selectedRegion') != null ? userController.eventRegion.value = prefs.getString('selectedRegion')! : userController.eventRegion.value = 'EUNE';

    if (prefs.getString('userUid') != null) {
      userController.uID.value = prefs.getString('userUid')!;

      if (!signIn) {
        //await getSummonerLinked(prefs.getString('userUid'));
        //await getCommunityUsers();
      }
      if (signIn == true) {
        authController.isLoading.value = true;
        if (await authController.internalLogin('${prefs.getString('userUid')}') == false) {
          authController.signOut();
        }
      }
    } else {
      authController.isLoading.value = false;
    }
  }

  Future<String> uplaodPic(BuildContext context) async {
    final storage = FirebaseStorage.instanceFor(bucket: "gs://league-arena-f4875.appspot.com");
    final storageRef = storage.ref('profile_images/${userController.uID.value}.png');
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: extensions,
      lockParentWindow: true,
    );

    if (result != null) {
      if (result.files.first.size < 10485760) {
        if (extensions.contains(result.files.first.extension)) {
          uploadingPic.value = true;
          Uint8List? fileBytes = result.files.first.bytes;
          await storageRef.putData(fileBytes!);
          final imageUrl = await storageRef.getDownloadURL();
          uploadingPic.value = false;
          return imageUrl;
        } else {
          // ignore: use_build_context_synchronously
          showTopSnackBar(
              context,
              const CustomSnackBar.error(
                message: "File extension isn't allowed, Allowed extensions are (jpg, png, gif).",
              ));
        }
      } else {
        // ignore: use_build_context_synchronously
        showTopSnackBar(
            context,
            const CustomSnackBar.error(
              message: "File size is too large, Maximum allowed file size is (10 MB).",
            ));
      }
    }
    return userController.profilePic.value;
  }

  Future<String> getUserProfilePic(String uID) async {
    String url = '';
    try {
      final snapshot = await database.ref('/users/$uID/profile_pic').get();
      if (snapshot.exists) {
        url = snapshot.value as String;
      }
    } on Exception catch (_) {}
    return url;
  }

  Future<bool> updateDisplayName(String name) async {
    if (name == displayname.value) {
      return true;
    }

    try {
      final userRef = database.ref('/users/${uID.value}');
      final data1 = <String, dynamic>{"displayname": name};
      userRef.update(data1);
      return true;
    } on Exception catch (_) {}
    return false;
  }

  Future<bool> updateProfilePic(String url) async {
    if (url == profilePic.value) {
      return true;
    }

    try {
      final userRef = database.ref('/users/${uID.value}');
      final data1 = <String, dynamic>{"profile_pic": url};
      userRef.update(data1);
      return true;
    } on Exception catch (_) {}
    return false;
  }

  Future<int> getSummonerId(String summonerName, String region) async {
    int response = 3;
    final snapshot = await database.ref('/summoners/$region/$summonerName').get();
    if (!snapshot.exists) {
      final Map<String, dynamic> data = await postRequest('${Env.HOST}${Uri.encodeComponent(crypto.encrypt('${generateR()}' 'g' '${generateR()}' 's' '${generateR()}' 'i'))}', {crypto.encrypt('summoner_name'): crypto.encrypt(summonerName), crypto.encrypt('region'): crypto.encrypt(region.toLowerCase())});
      if (data['response_code'] == 200) {
        summonerId.value = data['id'];
        response = 1;
      } else if (data['response_code'] == 404) {
        response = 2;
      }
    } else {
      response = 0;
    }
    return response;
  }

  Future<bool> getThirdParty(String id, String region, int iconId, [bool checkFirst = false]) async {
    final Map<String, dynamic> data = await postRequest('${Env.HOST}${Uri.encodeComponent(crypto.encrypt('${generateR()}' 'g' '${generateR()}' 't' '${generateR()}' 'p'))}', {crypto.encrypt('id'): crypto.encrypt(id), crypto.encrypt('region'): crypto.encrypt(region.toLowerCase())});

    if (data['response_code'] == 200) {
      if (checkFirst) {
        if (data['profileIcon'] == iconId) {
          iconList.remove(iconId);
          return false;
        } else {
          return true;
        }
      }

      if (data['profileIcon'] == iconId) {
        return true;
      }
    }
    return false;
  }

  Future<bool> saveSummonerInfo(String summonerName, String summonerId, String region) async {
    try {
      final userRef = database.ref('/summoners/$region/$summonerName');
      final data1 = <String, dynamic>{'uId': uID.value, "name": summonerName, "summoner_id": summonerId, "region": region};
      userRef.set(data1);
      return true;
    } on Exception catch (_) {}

    return false;
  }

  Future<void> getSummonerLinked(String? uId) async {
    try {
      final userRefEUNE = database.ref('/summoners/EUNE').orderByChild('uId').equalTo(uId);
      final userRefEUW = database.ref('/summoners/EUW').orderByChild('uId').equalTo(uId);

      euneSummonersListener = userRefEUNE.onValue.listen((event) async {
        summonersLoadEUNE.value = [];
        for (final child in event.snapshot.children) {
          final data = child.value as Map<String, dynamic>;
          Map<String, dynamic> finalData = {};
          finalData.addAll({'rank': await userController.getSummonerLeague(data['summoner_id'], data['region'])});
          finalData.addAll(data);
          summonersLoadEUNE.add(finalData);
        }
      });

      euwSummonersListener = userRefEUW.onValue.listen((event) async {
        summonersLoadEUW.value = [];
        for (final child in event.snapshot.children) {
          final data = child.value as Map<String, dynamic>;
          Map<String, dynamic> finalData = {};
          finalData.addAll({'rank': await userController.getSummonerLeague(data['summoner_id'], data['region'])});
          finalData.addAll(data);
          summonersLoadEUW.add(finalData);
        }
      });
    } on Exception catch (_) {}
  }

  Future<void> getCommunityUsers() async {
    try {
      int onlineCount = 0;
      final userRef = database.ref('/users');
      final snapshot = await userRef.get();
      final data = snapshot.value as Map<String, dynamic>;

      data.forEach((key, value) {
        Map<String, dynamic> data2 = {};
        if (value['displayname'] != '') {
          data2.addAll({'uid': key});
          data2.addAll(value);
          if (value['presence'] == true) {
            communityUsers.insert(0, data2);
          } else {
            communityUsers.add(data2);
          }
        }
      });

      onlineUserListener = userRef.onChildChanged.listen((DatabaseEvent event) async {
        Map<String, dynamic> finalData = {};
        final data = event.snapshot.value as Map<String, dynamic>;
        if (data['displayname'] != '') {
          finalData.addAll({'uid': event.snapshot.key});
          finalData.addAll(data);
          if (data['presence'] == true) {
            communityUsers.removeWhere((item) => item['uid'] == event.snapshot.key);
            communityUsers.insert(0, finalData);
          } else {
            communityUsers.removeWhere((item) => item['uid'] == event.snapshot.key);
            communityUsers.add(finalData);
          }

          int onlineCount = 0;
          for (var item in userController.communityUsers) {
            if (item['presence'] == true) {
              onlineCount++;
            }
          }
          onlineUserCount.value = onlineCount;
        }
      });

      for (var item in userController.communityUsers) {
        if (item['presence'] == true) {
          onlineCount++;
        }
      }
      onlineUserCount.value = onlineCount;
    } on Exception catch (_) {}
  }

  Future<String> getSummonerLeague(String summonerId, String region) async {
    final Map<String, dynamic> data = await postRequest(
        '${Env.HOST}${Uri.encodeComponent(crypto.encrypt('${generateR()}' 'g' '${generateR()}' 'l' '${generateR()}' 'e'))}',
        {crypto.encrypt('summoner_id'): crypto.encrypt(summonerId), crypto.encrypt('region'): crypto.encrypt(region.toLowerCase())});

    if (((data['rank'])) != null) {
      final List<dynamic> data2 = data['rank'];
      if (data2.isNotEmpty) {
        for (var item in data2) {
          if (item['queueType'] == "RANKED_SOLO_5x5") {
            return item['tier'] + ' ' + item['rank'];
          }
        }
      }
    }
    return '';
  }

  Future<bool> removeSummoner(String summonerName, String region) async {
    try {
      final ref = database.ref('/summoners/$region/$summonerName');
      await ref.remove();
      return true;
    } on Exception catch (_) {}

    return false;
  }
}
