import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget loadSvg(String iconPath, {Color? color}) {
  return SvgPicture.asset(
    iconPath,
    fit: BoxFit.contain,
    color: color,
  );
}