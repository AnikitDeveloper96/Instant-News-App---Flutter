import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class AppTextStyles {
  commonTextStyle(bool textcolor, bool fontsize, bool fontWeight, bool height) {
    return GoogleFonts.ibmPlexSans(
        color: textcolor ? AppColors.blackColor : AppColors.blueColor,
        fontSize: fontsize ? 16.0 : 14.0,
        fontWeight: fontWeight ? FontWeight.w500 : FontWeight.w400,
        height: height ? 1.5 : 0);
  }
}
