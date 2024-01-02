import 'package:hive/hive.dart';
part 'keyword_search.g.dart';

@HiveType(typeId: 0)
class KeywordSearch {

  @HiveField(0)
  String? keyword;

  KeywordSearch({this.keyword});

  Map<String, dynamic> toMap() => {
    "keyword": keyword,
  };
}
