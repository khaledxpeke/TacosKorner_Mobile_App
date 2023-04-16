// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/utils/colors.dart';

Widget bottomsheet(BuildContext context,VoidCallback onPressed) {
  return Container(
    height: 85.h,
    decoration: BoxDecoration(
        color: mSilverColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.r),
          topLeft: Radius.circular(8.r),
        )),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 9.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "RETOUR",
                style: TextStyle(
                    color: textColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800),
              ),
              style: ButtonStyle(
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
                  ))),
          TextButton(
              onPressed: onPressed,
              child: Text(
                "SUIVANT",
                style: TextStyle(
                    color: lightColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800),
              ),
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
                  )))
        ],
      ),
    ),
  );
}
