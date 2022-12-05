import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:league_arena/constants/constants.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventController extends GetxController {
  static EventController instance = Get.find();
  var db = FirebaseFirestore.instance;

  var euwEvents = [].obs;
  var euneEvents = [].obs;

  var eventInfo = {}.obs;

  var eventParticipant = [].obs;

  var eventMatches = [].obs;

  var isLoading = false.obs;

  Future getEvents(String region, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedRegion', region);
    isLoading.value = true;

    switch (region) {
      case 'EUW':
        db.collection('events').where('region', isEqualTo: region).where('status', isEqualTo: status.toLowerCase()).snapshots().listen((event) {
          euwEvents.value = [];
          for (var doc in event.docs) {
            Map<String, dynamic> data = doc.data();
            euwEvents.add(data);
          }
          isLoading.value = false;
        });
        break;
      case 'EUNE':
        db.collection('events').where('region', isEqualTo: region).where('status', isEqualTo: status.toLowerCase()).snapshots().listen((event) {
          euneEvents.value = [];
          for (var doc in event.docs) {
            Map<String, dynamic> data = doc.data();
            euneEvents.add(data);
          }
          isLoading.value = false;
        });
        break;
      default:
        break;
    }
  }

  Future<String> getEventOrganizer(String? id) async {
    String organizer = '';
    try {
      final docRef = db.collection("events").doc(id);
      await docRef.get().then((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        if (data['organizer'] != null) {
          final docRef2 = db.collection("organizers").doc(data['organizer']);
          await docRef2.get().then((doc2) async {
            final data2 = doc2.data() as Map<String, dynamic>;
            organizer = data2['name'];
          });
        }
      });
    } on Exception catch (_) {}
    return organizer;
  }

  Future<bool> register(String? eventId, String pName, String pUID, String sName, String sID, String sRank) async {
    int rank = convertRank(sRank);

    try {
      final participants = db.collection("events").doc(eventId).collection('participants');
      final user = db.collection("users").doc(pUID);
      final data1 = <String, dynamic>{
        "event_id": eventId,
        "participant_name": pName,
        "participant_uID": pUID,
        "summoner_name": sName,
        "summoner_id": sID,
        "summoner_rank": rank,
        'player_status': 'waiting'
      };
      participants.add(data1);
      user.update({'locked_event': eventId});
      return true;
    } on Exception catch (_) {}

    return false;
  }

  Future<void> createMatches(String? eventId, int capacity) async {
    try {
      final participants = db.collection("events").doc(eventId).collection('matches');
      int i = 0;
      for (int n = 1; n <= capacity - 1; n++) {
        if (n <= capacity / 2 - 1) {
          participants.doc('$n').set({
            'id': n,
            'parent': [n + n, n + n + 1]
          });
        } else {
          participants.doc('$n').set({
            'id': n,
            'players': [eventController.eventParticipant[i]['summoner_name'], eventController.eventParticipant[i + 1]['summoner_name']]
          });
          i++;
          i++;
        }
      }
    } on Exception catch (_) {}
  }
}
