import 'package:flutter/material.dart';

import '../../widgets/shimmer_tile.dart';

class ShimmerLarge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: 20,
      padding: const EdgeInsets.only(top: 12),
      itemBuilder: (context, index) {
        return ShimmerTile();
      },
    );
  }
}
