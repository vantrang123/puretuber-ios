import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';

import '../constants/strings.dart';
import '../provider/update_app_provider.dart';

class AppUpgradeWidget extends StatelessWidget {
  final String newVersion;
  final VoidCallback? onUpdatePressed;

  AppUpgradeWidget({
    required this.newVersion,
    this.onUpdatePressed,
  });

  @override
  Widget build(BuildContext context) {
    final updateAppProvider = Provider.of<AppUpdateProvider>(context, listen: false);
    return CupertinoAlertDialog(
      title: const Text('Update Require'),
      content: const Text('We have launched a new and improved app. Please update to continue using the app.'),
      actions: <CupertinoDialogAction>[
        if (!updateAppProvider.isCriticalUpdate)
          CupertinoDialogAction(
            onPressed: () {
              updateAppProvider.hideUpdateApp();
            },
            child: const Text('Later'),
          ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            LaunchReview.launch(androidAppId: Strings.appPackageName, iOSAppId: Strings.appleID);
          },
          child: const Text('Update Now'),
        ),
      ],
    );
  }
}
