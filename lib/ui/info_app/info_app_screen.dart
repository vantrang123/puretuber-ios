import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../constants/colors.dart';

class InfoAppScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 11, bottom: 11),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset('assets/images/ic_arrow_left.svg'),
                          ),
                        )
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text('App info',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                decoration: TextDecoration.none)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Image.asset(
                    'assets/images/image_banner_app.png',
                  width: MediaQuery.of(context).size.width - 30,
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 44),
                  child: Text(
                    'Pure Tuber – your go-to for seamless video streaming. This app allows you to "watch" videos, enjoy content from various sources, all while running in the background, even with the screen off – and the best part is, it\'s completely free.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textColorGray,
                      decoration: TextDecoration.none,),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 24,
              child: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (snapshot.data is PackageInfo)
                    return Text('Version: ${(snapshot.data as PackageInfo).version}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: AppColors.textColorGray,
                          decoration: TextDecoration.none));
                  return SizedBox.shrink();
                })
            )
        ]
      ),
      ),
    );
  }
}
