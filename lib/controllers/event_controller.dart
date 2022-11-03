import 'package:get/get.dart';
import 'package:league_arena/controllers/user_controller.dart';

class EventController extends GetxController {
  static EventController instance = Get.find();
  var euwEventsLoad = [].obs;
  var euwEvents = [].obs;
  var euneEvents = [].obs;

  var eventInfo = {}.obs;

  var currentActiveEventInfoId = ''.obs;

  Future getEvents(String region, String status) async {
    //final List<dynamic> data = await postRequest(getEventsByRegion, {'region': region, 'status': status});

    var stmt = await pool.prepare(
      "SELECT id, name, region, type, capacity, fee, prize, start_date, start_hour, status, event_banner FROM events WHERE region = ? AND status = ? ORDER BY start_date ASC, start_hour ASC",
    );

    var result = await stmt.execute([region, status]);

    if (result.numOfRows > 0) {
      euwEventsLoad.value = [];
      for (final row in result.rows) {
        switch (region) {
          case 'EUW':
            euwEventsLoad.add(row.typedAssoc());
            euwEvents.value = euwEventsLoad;
            break;

          case 'EUNE':
            euneEvents.add(row.typedAssoc());
            break;
        }
      }
    }
    await stmt.deallocate();
  }

  Future getEventInfoById(String? id) async {
    //final Map<String, dynamic> data = await postRequest(getEventById, {'id': id});

    var stmt = await pool.prepare(
      "SELECT id, name, region, type, capacity, fee, prize, start_date, start_hour, status, event_banner, overview_banner, overview_text, rules_text FROM events WHERE id = ?",
    );

    var result = await stmt.execute([id]);

    if (result.numOfRows > 0) {
      for (final row in result.rows) {
        eventInfo.value = row.typedAssoc();
      }
    }
    await stmt.deallocate();
  }
}
