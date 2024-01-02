import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';

class CenterPlayButton extends StatelessWidget {
  const CenterPlayButton({
    Key? key,
    this.iconColor,
    required this.show,
    required this.isPlaying,
    required this.isFinished,
    this.onPressed,
  }) : super(key: key);

  final Color? iconColor;
  final bool show;
  final bool isPlaying;
  final bool isFinished;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: isFinished
            ? Icon(Iconsax.play)
            : isPlaying
            ? Icon(Iconsax.pause)
            : Icon(Iconsax.play)
      ),
      onTap: onPressed,
    );
    return IconButton(
      iconSize: 42,
      icon: isFinished
          ? Icon(Iconsax.play)
          : isPlaying
              ? Icon(Iconsax.pause)
              : Icon(Iconsax.play),
      onPressed: onPressed,
    );
  }
}
