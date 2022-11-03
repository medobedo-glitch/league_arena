import 'dart:async';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:league_arena/constants/constants.dart';
import 'package:league_arena/helpers/post_helper.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final pool = MySQLConnectionPool(
  host: host,
  port: 3306,
  userName: 'root2',
  password: 'password',
  maxConnections: 10,
  secure: false,
  databaseName: 'league_arena', // optional,
);

class UserController extends GetxController {
  static UserController instance = Get.find();
  var id = 0.obs;
  var uID = ''.obs;
  var email = ''.obs;
  var tokens = 0.0.obs;
  var balance = 0.0.obs;
  var displayname = ''.obs;
  var profilePic = ''.obs;

  var summonerId = ''.obs;
  var thirdPartyCodeIn = ''.obs;
  var thirdPartyCodeOut = ''.obs;

  var summonersLoad = [].obs;
  var summoners = [].obs;
  var leagues = [].obs;

  var iconPicked = 0.obs;

  Future<void> updateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //final Map<String, dynamic> data = await postRequest(loginUrl, {"email": email.value});
    var stmt = await pool.prepare(
      "SELECT id, uID, email, tokens, balance, displayname, profile_pic FROM account WHERE uID = ?",
    );

    var result = await stmt.execute([uID.value]);

    if (result.numOfRows > 0) {
      for (final row in result.rows) {
        prefs.setInt('userId', row.typedAssoc()['id']);
        prefs.setString('userUid', row.typedAssoc()['uID']);
        prefs.setString('userEmail', row.typedAssoc()['email']);
        prefs.setDouble('userTokens', row.typedAssoc()['tokens']);
        prefs.setDouble('userBalance', row.typedAssoc()['balance']);
        prefs.setString('userDisplayName', row.typedAssoc()['displayname']);
        prefs.setString('userProfilePic', row.typedAssoc()['profile_pic']);
        id.value = row.typedAssoc()['id'];
        uID.value = row.typedAssoc()['uID'];
        email.value = row.typedAssoc()['email'];
        tokens.value = row.typedAssoc()['tokens'];
        balance.value = row.typedAssoc()['balance'];
        displayname.value = row.typedAssoc()['displayname'];
        profilePic.value = row.typedAssoc()['profile_pic'];
      }
    }
    await stmt.deallocate();
  }

  Future<void> doInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getInt('userId') != null ? id.value = prefs.getInt('userId')! : id.value = 0;
    prefs.getString('userUid') != null ? uID.value = prefs.getString('userUid')! : uID.value = '';
    prefs.getString('userEmail') != null ? email.value = prefs.getString('userEmail')! : email.value = '';
    prefs.getDouble('userTokens') != null ? tokens.value = prefs.getDouble('userTokens')! : tokens.value = 0.0;
    prefs.getDouble('userBalance') != null ? balance.value = prefs.getDouble('userBalance')! : balance.value = 0.0;
    prefs.getString('userDisplayName') != null ? displayname.value = prefs.getString('userDisplayName')! : displayname.value = '';
    prefs.getString('userProfilePic') != null ? profilePic.value = prefs.getString('userProfilePic')! : profilePic.value = '';

    prefs.getString('userUid') != null ? updateData() : null;
    updateSummoners();
  }

  Future<void> updateSummoners() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('userUid') != null ? getSummonerLinked() : null;
  }

  Future<bool> register(String uid, String email) async {
    //final Map<String, dynamic> data = await postRequest(registerUrl, {'uid': uid, 'email': email, 'password': password});
    var stmt = await pool.prepare(
      "INSERT INTO account (uID, email) VALUES (?, ?)",
    );

    var result = await stmt.execute([uid, email]);

    if (result.affectedRows.toInt() > 0) {
      await stmt.deallocate();
      await login(uid);
      return true;
    }
    await stmt.deallocate();
    return false;
  }

  Future<bool> login(String uID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //final Map<String, dynamic> data = await postRequest(loginUrl, {"email": email});
    var stmt = await pool.prepare(
      "SELECT id, uID, email, tokens, balance, displayname, profile_pic FROM account WHERE uID = ?",
    );

    var result = await stmt.execute([uID]);

    if (result.numOfRows > 0) {
      for (final row in result.rows) {
        prefs.setInt('userId', row.typedAssoc()['id']);
        prefs.setString('userUid', row.typedAssoc()['uID']);
        prefs.setString('userEmail', row.typedAssoc()['email']);
        prefs.setDouble('userTokens', row.typedAssoc()['tokens']);
        prefs.setDouble('userBalance', row.typedAssoc()['balance']);
        prefs.setString('userDisplayName', row.typedAssoc()['displayname']);
        prefs.setString('userProfilePic', row.typedAssoc()['profile_pic']);
        doInit();
        return true;
      }
      await stmt.deallocate();
    }
    await stmt.deallocate();
    return false;
  }

  Future<bool> updateDisplayName(String name) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //final Map<String, dynamic> data = await postRequest(updateDisplayNameUrl, {"uid": uID.value, 'name': name});
    if (name == displayname.value) {
      return true;
    }

    var stmt = await pool.prepare(
      "UPDATE account SET displayname= ? WHERE uID = ?",
    );

    var result = await stmt.execute([name, uID.value]);

    if (result.affectedRows.toInt() > 0) {
      await stmt.deallocate();
      doInit();
      return true;
    }
    await stmt.deallocate();
    return false;
  }

  Future<bool> updateProfilePic(String url) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //final Map<String, dynamic> data = await postRequest(updateDisplayNameUrl, {"uid": uID.value, 'name': name});
    if (url == profilePic.value) {
      return true;
    }

    var stmt = await pool.prepare(
      "UPDATE account SET profile_pic = ? WHERE uID = ?",
    );

    var result = await stmt.execute([url, uID.value]);

    if (result.affectedRows.toInt() > 0) {
      await stmt.deallocate();
      doInit();
      return true;
    }
    await stmt.deallocate();
    return false;
  }

  Future<int> getSummonerId(String summonerName, String region) async {
    var stmt = await pool.prepare(
      "SELECT id FROM summoner_details WHERE uID = ? AND summoner_name = ? AND region = ?",
    );

    var result = await stmt.execute([uID.value, summonerName, region.toLowerCase()]);

    if (result.numOfRows < 1) {
      final Map<String, dynamic> data = await postRequest(checkLinkedSummoner, {'summoner_name': summonerName, 'region': region.toLowerCase()});
      if (data['response_code'] == 200) {
        summonerId.value = data['id'];
        return 1;
      } else if (data['response_code'] == 404) {
        return 2;
      }
    }
    return 0;
  }

  Future<bool> getThirdParty(String id, String region, int iconId, bool checkFirst) async {
    final Map<String, dynamic> data = await postRequest(getThirdPartyCode, {'id': id, 'region': region.toLowerCase()});

    if (data['response_code'] == 200) {
      if (data['profileIcon'] == iconId || (data['profileIcon'] == iconId && checkFirst)) {
        return true;
      }
    }
    return false;
  }

  Future<bool> saveSummonerInfo(String summonerName, String summonerId, String region) async {
    //final Map<String, dynamic> data = await postRequest(saveSummoner, {'uID': uID.value, 'summoner_name': summonerName, 'summoner_id': summonerId, 'region': region});

    var stmt = await pool.prepare(
      "INSERT INTO summoner_details (uID, summoner_name, summoner_id, region) VALUES (?, ?, ?, ?)",
    );

    var result = await stmt.execute([uID.value, summonerName, summonerId, region]);

    if (result.affectedRows.toInt() > 0) {
      await stmt.deallocate();
      return true;
    }
    await stmt.deallocate();
    return false;
  }

  Future getSummonerLinked() async {
    //final List<dynamic> data = await postRequest(getLinkedSummoner, {'uID': uID.value});
    var stmt = await pool.prepare(
      "SELECT summoner_name, summoner_id, region FROM summoner_details WHERE uID = ?",
    );

    var result = await stmt.execute([uID.value]);

    if (result.numOfRows > 0) {
      summonersLoad.value = [];
      for (final row in result.rows) {
        summonersLoad.add(row.typedAssoc());
        summoners.value = summonersLoad;
      }
    }
    await stmt.deallocate();
  }

  Future<String> getSummonerLeague(String summonerId, String region) async {
    final Map<String, dynamic> data = await postRequest(getLeagueEntries, {'summoner_id': summonerId, 'region': region.toLowerCase()});

    if (data['rank'] != null) {
      final List<dynamic> data2 = data['rank'];
      if (data2.isNotEmpty) {
        return data2[0]['tier'] + ' ' + data2[0]['rank'];
      }
    }
    return '';
  }

  Future<bool> removeSummoner(String summonerId) async {
    //final Map<String, dynamic> data = await postRequest(removeLinkedSummoner, {'uID': uID.value, 'summoner_id': summonerId});

    var stmt = await pool.prepare(
      "DELETE FROM summoner_details WHERE uID = ? AND summoner_id = ?",
    );

    var result = await stmt.execute([uID.value, summonerId]);

    if (result.affectedRows.toInt() > 0) {
      await stmt.deallocate();
      return true;
    }
    await stmt.deallocate();
    return false;
  }
}
