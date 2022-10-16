import 'package:get/get.dart';
import 'package:league_arena/constants/constants.dart';
import 'package:league_arena/helpers/post_helper.dart';

class EventController extends GetxController {
  static EventController instance = Get.find();
  var euwEvents = [].obs;
  var euneEvents = [].obs;
  var eventInfo = {}.obs;
  var currentActiveEventInfoId = ''.obs;

  Future getEvents(String region, String status) async {
    final List<dynamic> data = await postRequest(getEventsByRegion, {'region': region, 'status': status});

    switch (region) {
      case 'EUW':
        euwEvents.value = data;
        break;

      case 'EUNE':
        euneEvents.value = data;
        break;
    }
  }

  Future getEventInfoById(String? id) async {
    final Map<String, dynamic> data = await postRequest(getEventById, {'id': id});

    if (data.isNotEmpty) {
      eventInfo.value = data;
    }
  }
}
