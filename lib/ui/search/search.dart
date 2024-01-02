import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../ads/native_ads.dart';
import '../../constants/strings.dart';
import '../../data/local/hive_service.dart';
import '../../di/components/service_locator.dart';
import '../../models/keyword_search.dart';
import '../../provider/search_provider.dart';
import '../../stores/soundcloud/soundcloud_search_store.dart';
import '../../stores/video/video_store.dart';
import '../../widgets/collapsed_panel.dart';
import '../../widgets/video_large_widget.dart';
import '../components/shimmer_large.dart';
import '../components/search_bar.dart';
import 'search_suggestion_list.dart';

class SearchScreen extends StatefulWidget {
  @override
  _Search createState() => _Search();
}

class _Search extends State<SearchScreen> {
  late VideoStore _videoStore;
  late SoundCloudSearchStore _soundCloudSearchStore;
  final HiveService hiveService = getIt<HiveService>();
  var isFirstLoad = true;
  late ManagerSearchProvider _searchProvider;

  @override
  void initState() {
    _videoStore = Provider.of<VideoStore>(context, listen: false);
    _soundCloudSearchStore = Provider.of<SoundCloudSearchStore>(context, listen: false);
    _videoStore.videoListSearch?.videos?.clear();
    _searchProvider = Provider.of<ManagerSearchProvider>(context, listen: false);
    _searchProvider.searchController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ManagerSearchProvider manager = Provider.of<ManagerSearchProvider>(context, listen: false);
    return SafeArea(
        child: GestureDetector(
          onTap: () => manager.searchBarFocusNode.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _buildAppBar(),
            body: _buildBody(),
          ),
        )
    );
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    ManagerSearchProvider manager = Provider.of<ManagerSearchProvider>(context, listen: false);
    _onFieldSubmittedCallback(String query) {
      _handleKeySearchResponse(query, manager);
    }

    return PreferredSize(
        child: SearchAppBar(_onFieldSubmittedCallback),
        preferredSize: Size(double.infinity, kToolbarHeight));
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Expanded(child: Observer(builder: (context) {
            final listData = _videoStore.videoListSearch?.videos ?? [];
            return _searchProvider.searchController.text.isNotEmpty && !_searchProvider.searchBarFocusNode.hasFocus ?
            listData.isNotEmpty ? NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                double maxScroll = notification.metrics.maxScrollExtent;
                double currentScroll = notification.metrics.pixels;
                double delta = 200.0;
                if (maxScroll - currentScroll <= delta && !_videoStore.loading) {
                  _videoStore.getVideosNextPage();
                }
                return true;
              },
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final video = listData[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            VideoLargeWidget(video: video),
                            if (index == 0)
                              Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: NativeAds(type: "Medium"),
                              ),
                          ],
                        ),
                      );
                    }, childCount: listData.length),
                  )
                ],
              ),
            ) : ShimmerLarge() : _buildSearchSuggestion(_searchProvider);
          })),
          CollapsedPanel()
        ],
      ),
    );
  }

  Widget _buildSearchSuggestion(ManagerSearchProvider manager) {
    return Consumer<ManagerSearchProvider>(builder: (context, manager, _) {
      if (isFirstLoad) isFirstLoad = false;
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: SearchSuggestionList(
          searchQuery: manager.searchController.text,
          onItemTap: (String item) {
            _handleKeySearchResponse(item, manager);
          },
        ),
      );
    });
  }

  _handleKeySearchResponse(String value, ManagerSearchProvider manager) {
    manager.searchController.text = value;
    manager.searchRunning = true;
    manager.youtubeSearchQuery = value;
    FocusScope.of(context).unfocus();
    manager.setState();
    if (value.length > 1) {
      Future.delayed(
          Duration(milliseconds: 100),
          () => {
            _saveKeyWordSearch(value)
          });
      if (!_videoStore.loading) {
        _videoStore.videoListSearch = null;
        _videoStore.getVideos(value, true);
        // _soundCloudSearchStore.getVideos(value, true);
      }
    }
  }

  _saveKeyWordSearch(String value) async {
    hiveService.updateBoxes<KeywordSearch>(KeywordSearch(keyword: value), Strings.keywordBoxName);
  }
}
