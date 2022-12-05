import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

StreamSubscription<DatabaseEvent>? accountListener;
StreamSubscription<DatabaseEvent>? euwSummonersListener;
StreamSubscription<DatabaseEvent>? euneSummonersListener;
StreamSubscription<DatabaseEvent>? onlineUserListener;

int convertRank(String rank) {
  int converted;
  switch (rank) {
    case '':
      converted = 0;
      break;
    case 'IRON IV':
      converted = 1;
      break;
    case 'IRON III':
      converted = 2;
      break;
    case 'IRON II':
      converted = 3;
      break;
    case 'IRON I':
      converted = 4;
      break;
    case 'SILVER IV':
      converted = 5;
      break;
    case 'SILVER III':
      converted = 6;
      break;
    case 'SILVER II':
      converted = 7;
      break;
    case 'SILVER I':
      converted = 8;
      break;
    case 'GOLD IV':
      converted = 9;
      break;
    case 'GOLD III':
      converted = 10;
      break;
    case 'GOLD II':
      converted = 11;
      break;
    case 'GOLD I':
      converted = 12;
      break;
    case 'PLATINUM IV':
      converted = 13;
      break;
    case 'PLATINUM III':
      converted = 14;
      break;
    case 'PLATINUM II':
      converted = 15;
      break;
    case 'PLATINUM I':
      converted = 16;
      break;
    case 'DIAMOND IV':
      converted = 17;
      break;
    case 'DIAMOND III':
      converted = 18;
      break;
    case 'DIAMOND II':
      converted = 19;
      break;
    case 'DIAMOND I':
      converted = 20;
      break;
    default:
      converted = 21;
      break;
  }
  return converted;
}
