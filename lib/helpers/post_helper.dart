import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:league_arena/env/env.dart';

// String decrypt(String encrypted) {
//   final key = Key.fromUtf8("1245714587458888"); //hardcode combination of 16 character
//   final iv = IV.fromUtf8("e16ce888a20dadb8"); //hardcode combination of 16 character

//   final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
//   Encrypted enBase64 = Encrypted.from64(encrypted);
//   final decrypted = encrypter.decrypt(enBase64, iv: iv);
//   return decrypted;
// }

class Encryption {
  static final Encryption instance = Encryption._();
  
  late IV _iv;
  late Encrypter _encrypter;

  Encryption._() {
    final mykey = Env.KEY;
    final myiv = Env.IV;
    final keyUtf8 = utf8.encode(mykey);
    final ivUtf8 = utf8.encode(myiv);
    final key = sha256.convert(keyUtf8).toString().substring(0, 32);
    final iv = sha256.convert(ivUtf8).toString().substring(0, 16);
    _iv = IV.fromUtf8(iv);

    _encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
  }

  String encrypt(String value) {
    return _encrypter.encrypt(value, iv: _iv).base64;
  }

  String decrypt(String base64value) {
    final encrypted = Encrypted.fromBase64(base64value);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}

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
