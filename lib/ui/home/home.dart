import 'package:app_version_update/app_version_update.dart';
import 'package:audio_session/audio_session.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../ads/interstitial_ads.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../data/sharedpref/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../provider/bottom_navigation_provider.dart';
import '../../provider/update_app_provider.dart';
import '../../stores/video/subscribe_channel_store.dart';
import '../../utils/routes/routes.dart';
import '../../widgets/collapsed_panel.dart';
import '../../widgets/search_bar_logo.dart';
import 'page/home_library.dart';
import 'page/home_page.dart';
import 'page/home_subscriptions.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<Widget> pages = [
    HomePage(),
    HomeSubscriptions(),
    HomeLibrary()
  ];
  AppUpdateProvider get readAppUpdateProvider => context.read<AppUpdateProvider>();

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _init() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    Provider.of<SubscribeChannelStore>(context, listen: false).getSubscribeChannelId();

    _checkForUpdate();
    _showPopupConfirmShowAds();
    _checkShowReview();

    getIt<InterstitialAds>().loadAd();
  }

  void _checkShowReview() async {
    final timesOpenApp = await getIt<SharedPreferenceHelper>().timesOpenApp ?? 0;
    if (timesOpenApp > 9) {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
        getIt<SharedPreferenceHelper>().saveTimeOpenApp(0);
      }
    } else {
      getIt<SharedPreferenceHelper>().saveTimeOpenApp(timesOpenApp + 1);
    }
  }

  Future<void> _checkForUpdate() async {
    await AppVersionUpdate.checkForUpdates(
      appleId: '',
      playStoreId: Strings.appPackageName,
    ).then((result) async {
      if (result.canUpdate == true) {
        final newVersion = result.storeVersion;

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String localVersion = packageInfo.version;
        bool isCriticalUpdate = false;
        try {
          int majorNewVersion = int.parse(newVersion!.split('.')[0]);
          int majorLocalVersion = int.parse(localVersion.split('.')[0]);
          if (majorNewVersion > majorLocalVersion) {
            isCriticalUpdate = true;
          }
        } catch(e) {}

        readAppUpdateProvider.showUpdateApp(result.storeVersion!, isCriticalUpdate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: _buildAppBar(),
          body: Consumer<BottomNavigationProvider>(
              builder: (context, data, child) {
                return IndexedStack(
                  index: data.pageSelected.index,
                  children: pages,
                );
              }),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CollapsedPanel(),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
                child: Consumer<BottomNavigationProvider>(
                  builder: (context, data, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _iconHome(data, context),
                        _iconDiscover(data, context),
                        _iconSettings(data, context),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        onWillPop: _onWillPop);
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    _searchBarClick() {
      Navigator.pushNamed(context, Routes.search);
    }

    return PreferredSize(
        child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Container(
              margin: EdgeInsets.only(left: 12, right: 12),
              height: kToolbarHeight * 0.7,
              decoration: BoxDecoration(
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(22)
              ),
              child: SearchBarLogo(_searchBarClick),
            ),
          ),
        ),
        preferredSize: Size(double.infinity, kToolbarHeight));
  }

  Widget _iconHome(BottomNavigationProvider provider, BuildContext context) {
    return InkWell(
      onTap: () {
        provider.onPageChanged(PageSelected.home);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              provider.pageSelected == PageSelected.home ? Icon(Ionicons.home, color: AppColors.accentColor[500]) : Icon(Ionicons.home_outline),
              SizedBox(height: 3),
              Text(
                  'Home',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  )
              )
            ]
        ),
      ),
    );
  }

  Widget _iconDiscover(BottomNavigationProvider provider, BuildContext context) {
    return InkWell(
      onTap: () {
        provider.onPageChanged(PageSelected.discover);
      },
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            provider.pageSelected == PageSelected.discover ? Icon(Icons.subscriptions_outlined, color: AppColors.accentColor[500]) : Icon(Icons.subscriptions_outlined),
            SizedBox(height: 3),
            Text(
                'Subscriptions',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                )
            )
          ]
      ),
    );
  }

  Widget _iconSettings(BottomNavigationProvider provider, BuildContext context) {
    return InkWell(
      onTap: () {
        provider.onPageChanged(PageSelected.settings);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              provider.pageSelected == PageSelected.settings ? Icon(EvaIcons.bookOpen, color: AppColors.accentColor[500]) : Icon(EvaIcons.bookOpenOutline),
              SizedBox(height: 3),
              Text(
                  'Library',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  )
              )
            ]
        ),
      ),
    );
  }

  void _showPopupConfirmShowAds() async {
    /*final chooseDeniedShowAds = await getIt<SharedPreferenceHelper>().isDeniedAds;
    if (chooseDeniedShowAds ?? true == true) {
      await GdprDialog.instance.getConsentStatus().then((value) {
        if (value == ConsentStatus.required) {
          GdprDialog.instance.resetDecision();
          GdprDialog.instance
              .showDialog(isForTest: false, testDeviceId: '')
              .then((onValue) {
            print('GdprDialog result == $onValue');

            if (onValue) {
              // _loadAds();
              getIt<SharedPreferenceHelper>().saveDeniedAds(false);
            } else {
              getIt<SharedPreferenceHelper>().saveDeniedAds(true);
            }
          });
        } else {
          // _loadAds();
        }
      });
    } else {
      // _loadAds();
    }*/
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}
