// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/utils/colors.dart';

Widget appBar(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.w),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 82.h,
          width: 82.w,
          decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: darkColor.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 4.h),
                )
              ]),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: darkColor.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 0.1.h),
                )
              ]),
          child: Image.asset(
            'assets/images/bilbord.png',
            fit: BoxFit.fill,
            height: 86.h,
            width: 289.w,
          ),
        ),
      ],
    ),
  );
}
