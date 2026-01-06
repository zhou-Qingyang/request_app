import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String assetName;
  final Color color;
  final double iconSize;

  SvgIconButton({
    required this.assetName,
    required this.onPressed,
    required this.color,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      color: color,
      onPressed: onPressed,
      iconSize: iconSize,
      icon: SvgPicture.asset(
        assetName,
        color: color,
        width: iconSize,
        height: iconSize,
      ),
    );
  }
}
