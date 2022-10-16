import 'dart:convert';

import 'package:http/http.dart' as http;

Future postRequest(String webUrl, Map webBody) async {
  final response = await http.post(Uri.parse(webUrl), body: webBody);

  //final Map<String, dynamic> user = json.decode(response.body);
  
  // If server returns an OK response, parse the JSON.
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to proccess data');
  }
}
