import 'dart:math';

class Strings {
  Strings._();

  //General
  static const String appName = "Pure Tuber";

  static const String appPackageName = "com.fv.musictuber";

  static const String appleID = "6471274198";

  static const String keywordBoxName = "HistoryKeyword";

  static const List<String> listApikey = [
    "AIzaSyCkBFPI4b7VhcmwGp6jCBaBD0BamsqDps8"
  ];

  static String apikey = listApikey.elementAt(Random().nextInt(listApikey.length));

  static const String categoryCodeFilm = '30';
  static const String categoryCodeMusic = '10';
  static const String categoryCodeGame = '26';
  static const String categoryCodeEntertainment = '24';
  static const String categoryCodeSport = '17';
  static const String none = 'none';
  static const String watchLater = "Watch Later";
  static const String recently = "Recently";
}
