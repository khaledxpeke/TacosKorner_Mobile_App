// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors.dart';

class ConfirmationButton extends StatelessWidget {
  Color textColor;
  Color buttonColor;
  String text;
  VoidCallback onPressed;
  ConfirmationButton(
      this.textColor, this.buttonColor, this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 49.h,
        width: 82.w,
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: darkColor.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 4.h),
              )
            ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 11.sp, fontWeight: FontWeight.w800, color: textColor),
          ),
        ),
      ),
    );
  }
}
