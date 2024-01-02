import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';

enum IconType {
  info,
  term,
  rate,
  share
}

class MoreItem extends StatelessWidget {
  final title;
  final iconName;
  final Function() onTap;
  MoreItem({required this.title, required this.iconName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon;
    switch (iconName) {
      case IconType.info:
        icon = Icon(Icons.info_outline);
        break;
      case IconType.term:
        icon = Icon(Icons.policy_outlined);
        break;
      case IconType.rate:
        icon = Icon(Icons.star_rate_outlined);
        break;
      case IconType.info:
        icon = Icon(EvaIcons.share);
        break;
      default:
        icon = Icon(Icons.share);
    }
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          icon,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Text(
                title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)
            ),
          )
        ],
      ),
    );
  }
}
