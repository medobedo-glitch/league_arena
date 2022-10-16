import 'dart:async';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:league_arena/constants/constants.dart';
import 'package:league_arena/helpers/post_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  var id = 0.obs;
  var uID = ''.obs;
  var email = ''.obs;
  var tokens = 0.obs;
  var balance = 0.0.obs;
  var displayname = ''.obs;
  var summonerId = ''.obs;
  var thirdPartyCodeIn = ''.obs;
  var thirdPartyCodeOut = ''.obs;
  var summoners = [].obs;
  var leagues = [].obs;

  Future<void> updateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> data =
        await postRequest(loginUrl, {"email": email.value});
    if (data['user'] != null) {
      prefs.setInt('userId', data['user']['id']);
      prefs.setString('userUid', data['user']['uID']);
      prefs.setString('userEmail', data['user']['email']);
      prefs.setInt('userTokens', data['user']['tokens']);
      prefs.setDouble('userBalance', data['user']['balance'].toDouble());
      prefs.setString('userDisplayName', data['user']['displayname']);
      id.value = data['user']['id'];
      uID.value = data['user']['uID'];
      email.value = data['user']['email'];
      tokens.value = data['user']['tokens'];
      balance.value = data['user']['balance'].toDouble();
      displayname.value = data['user']['displayname'];
      //print(data['user']);
    }
  }

  Future<void> doInit() async {
    //print('init');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.getInt('userId') != null
        ? id.value = prefs.getInt('userId')!
        : id.value = 0;
    prefs.getString('userUid') != null
        ? uID.value = prefs.getString('userUid')!
        : uID.value = '';
    prefs.getString('userEmail') != null
        ? email.value = prefs.getString('userEmail')!
        : email.value = '';
    prefs.getInt('userTokens') != null
        ? tokens.value = prefs.getInt('userTokens')!
        : tokens.value = 0;
    prefs.getDouble('userBalance') != null
        ? balance.value = prefs.getDouble('userBalance')!
        : balance.value = 0.0;
    prefs.getString('userDisplayName') != null
        ? displayname.value = prefs.getString('userDisplayName')!
        : displayname.value = '';

    prefs.getString('userEmail') != null ? updateData() : null;
    updateSummoners();
  }

  Future<void> updateSummoners() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('userUid') != null ? getSummonerLinked() : null;
  }

  Future<bool> register(String _uid, String _email, String _password) async {
    final Map<String, dynamic> data = await postRequest(
        registerUrl, {'uid': _uid, 'email': _email, 'password': _password});
    if (!data["error"]) {
      await login(_email);
      return true;
    }
    return false;
  }

  Future<bool> login(String _email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> data =
        await postRequest(loginUrl, {"email": _email});
    if (data["user"] != null) {
      prefs.setInt('userId', data['user']['id']);
      prefs.setString('userUid', data['user']['uID']);
      prefs.setString('userEmail', data['user']['email']);
      prefs.setInt('userTokens', data['user']['tokens']);
      prefs.setDouble('userBalance', data['user']['balance'].toDouble());
      prefs.setString('userDisplayName', data['user']['displayname']);
      doInit();
      return true;
    }
    return false;
  }

  Future<bool> updateDisplayName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> data = await postRequest(
        updateDisplayNameUrl, {"uid": uID.value, 'name': name});
    if (data["displayname"] != null) {
      prefs.setString('userDisplayName', data['displayname']);
      doInit();
      return true;
    }
    return false;
  }

  Future<int> getSummonerId(String summonerName, String region) async {
    final Map<String, dynamic> data = await postRequest(checkLinkedSummoner, {
      'summoner_name': summonerName,
      "uID": uID.value,
      'region': region.toLowerCase()
    });
    if (data['linked'] == false) {
      if (data['response_code'] == 200) {
        summonerId.value = data['id'];
        return 1;
      } else if (data['response_code'] == 404) {
        return 2;
      }
    }
    return 0;
  }

  Future<int> getThirdParty(String id, String region) async {
    final Map<String, dynamic> data = await postRequest(
        getThirdPartyCode, {'id': id, 'region': region.toLowerCase()});

    if (data['response_code'] == 200) {
      thirdPartyCodeOut.value = data['code'];
      return 1;
    }
    return 0;
  }

  Future<bool> saveSummonerInfo(
      String summonerName, String summonerId, String region) async {
    final Map<String, dynamic> data = await postRequest(saveSummoner, {
      'uID': uID.value,
      'summoner_name': summonerName,
      'summoner_id': summonerId,
      'region': region
    });

    if (data['saved'] != null) {
      return data['saved'];
    }
    return false;
  }

  Future getSummonerLinked() async {
    final List<dynamic> data =
        await postRequest(getLinkedSummoner, {'uID': uID.value});

    //print(data);
    summoners.value = data;
  }

  Future<String> getSummonerLeague(String summonerId, String region) async {
    final Map<String, dynamic> data = await postRequest(getLeagueEntries,
        {'summoner_id': summonerId, 'region': region.toLowerCase()});

    if (data['rank'] != null) {
      final List<dynamic> data2 = data['rank'];
      if (data2.isNotEmpty) {
        return data2[0]['tier'] + ' ' + data2[0]['rank'];
      }
    }
    return '';
  }

  Future<bool> removeSummoner(String summonerId) async {
    final Map<String, dynamic> data = await postRequest(
        removeLinkedSummoner, {'uID': uID.value, 'summoner_id': summonerId});

    if (data['deleted'] != null) {
      return data['deleted'];
    }
    return false;
  }
}
