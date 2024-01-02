import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

import '../../constants/strings.dart';
import '../../data/local/hive_service.dart';
import '../../di/components/service_locator.dart';
import '../../models/keyword_search.dart';

class SearchSuggestionList extends StatefulWidget {
  final Function(String) onItemTap;
  final String searchQuery;

  SearchSuggestionList({required this.onItemTap, this.searchQuery = ""});

  @override
  _SearchSuggestionListState createState() => _SearchSuggestionListState();
}

class _SearchSuggestionListState extends State<SearchSuggestionList> {
  late http.Client client;
  final HiveService hiveService = getIt<HiveService>();
  List<String> _historySearch = [];

  @override
  void initState() {
    client = http.Client();
    _getHistorySearch();
    super.initState();
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _suggestionSearch())
        ]);
  }

  _getHistorySearch() async {
    _historySearch.clear();
    final listKeywordSearch =
        await hiveService.getBoxes<KeywordSearch>(Strings.keywordBoxName);
    final length = listKeywordSearch.length;
    if (length > 5) await hiveService.deleteItem<KeywordSearch>(0, Strings.keywordBoxName);
    for (int i = length -1; i >= 0; i--) {
      _historySearch.add(listKeywordSearch[i].keyword);
    }
    setState(() {});
  }

  Widget _suggestionSearch() {
    List<String> suggestionsList = [];
    List<String> finalList = [];
    return FutureBuilder(
      future: widget.searchQuery != ""
          ? client.get(
              Uri.parse(
                  'http://suggestqueries.google.com/complete/search?client=youtube&ds=yt&client=firefox&q=${widget.searchQuery}'),
              headers: {
                  'user-agent':
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
                          '(KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36',
                  'accept-language': 'en-US,en;q=1.0',
                })
          : null,
      builder: (context, AsyncSnapshot<http.Response> suggestions) {
        suggestionsList.clear();
        if (suggestions.hasData && widget.searchQuery != "") {
          var map = jsonDecode(suggestions.data!.body);
          var mapList = map[1];
          mapList.forEach((result) {
            suggestionsList.add(result);
          });
        }
        finalList = widget.searchQuery.isNotEmpty ? suggestionsList : _historySearch;
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: finalList.length,
          itemBuilder: (context, index) {
            String item = finalList[index];
            return InkWell(
              onTap: () {
                widget.onItemTap(item);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    widget.searchQuery.isEmpty ? Icon(Iconsax.timer_14, color: Colors.white)
                        : Icon(Iconsax.search_normal_1, color: Colors.white),
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16, right: 12),
                          child: Text(
                            "$item",
                            style: TextStyle(color: Colors.white, fontSize: 16)
                          ),
                        )
                    )
                  ],
                ),
              ),
            );
          });
      },
    );
  }
}
