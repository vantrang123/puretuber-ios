import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/colors.dart';


class SearchBarLogo extends StatelessWidget {
  final VoidCallback onClickSearchLogo;

  SearchBarLogo(this.onClickSearchLogo);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClickSearchLogo(),
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            const SizedBox(width: 6),
            Image.asset(
              'assets/images/ic_launcher_round.png',
              width: 32,
              height: 32
            ),
            const SizedBox(width: 12),
            Icon(Iconsax.search_normal, size: 18, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: IgnorePointer(
                ignoring: true,
                child: Text('Search anything',
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
