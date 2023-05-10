// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmationMessage extends StatelessWidget {
  String title;
  String errorMsg;
  VoidCallback onPressed;
  ConfirmationMessage(this.title, this.errorMsg, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Text(title,
          style: TextStyle(
            fontSize: 16.sp,
            color: redColor,
            fontWeight: FontWeight.w800,
          )),
      content: Text(errorMsg,
          style: TextStyle(
              fontSize: 14.sp, fontWeight: FontWeight.w500, color: textColor)),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  lightColor,
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: BorderSide(
                      color: dSilverColor,
                      width: 2.w,
                    ),
                  ),
                )),
            child: Text(
              "Non",
              style: TextStyle(
                  color: textColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800),
            )),
        TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  primaryColor,
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                )),
            child: Text(
              "Oui",
              style: TextStyle(
                  color: lightColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800),
            ))
      ],
    );
  }
}
