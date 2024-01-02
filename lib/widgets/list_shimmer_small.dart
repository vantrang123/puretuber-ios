import 'package:flutter/material.dart';

import '../ui/components/shimmer_container.dart';

class ListShimmerSmall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
              left: 12, right: 12, top: index == 0 ? 12 : 0, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerContainer(
                height: 80,
                width: 150,
                borderRadius: BorderRadius.circular(10),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainer(
                      height: 15,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(10),
                      margin:
                          EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
                    ),
                    ShimmerContainer(
                      height: 15,
                      width: 150,
                      borderRadius: BorderRadius.circular(10),
                      margin: EdgeInsets.only(left: 8),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
