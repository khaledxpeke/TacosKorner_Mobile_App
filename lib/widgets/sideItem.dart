// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/utils/colors.dart';

class SideItem extends StatelessWidget {
  final String? image;
  final String name;
  final VoidCallback onTap;
  final bool selected;
  const SideItem(
    this.image,
    this.name,
    this.onTap,
    this.selected,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 61.h,
        width: 82.w,
        decoration: BoxDecoration(
          color: selected ? primaryColor : null,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.r),
            bottomRight: Radius.circular(15.r),
          ),
        ),
        child: Column(children: [
          SizedBox(height: 4.h),
          Expanded(
            child: image == ""
                ? Container()
                : image!.startsWith("assets/images/")
                    ? Image.asset(
                        image!,
                        fit: BoxFit.cover,
                      )
                    :Image.network(
              image!,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            name,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 9.sp,
                color: selected ? lightColor : textColor),
          ),
          SizedBox(height: 4.h),
        ]),
      ),
    );
  }
}
