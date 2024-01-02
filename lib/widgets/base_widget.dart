import 'package:flutter/material.dart';
import 'package:free_tuber/widgets/collapsed_panel.dart';
import 'package:provider/provider.dart';

import '../provider/update_app_provider.dart';
import 'app_update.dart';

class BaseWidget extends StatelessWidget {
  final Widget child;

  const BaseWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(child: Consumer<AppUpdateProvider>(builder: (context, data, _) {
          return Stack(
            children: [
              IgnorePointer(
                ignoring: data.isShow,
                child: child,
              ),
              data.isShow
                  ? AppUpgradeWidget(newVersion: data.newVersion)
                  : SizedBox.shrink()
            ],
          );
        }))
      ]),
    );
  }
}
