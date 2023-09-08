// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/utils/colors.dart';

import '../provider/categoriesProvider.dart';

Widget bottomsheet(
    BuildContext context, VoidCallback onNext, VoidCallback onRetour) {
  int stepIndex = Provider.of<Categories>(context).stepIndex;
  int nbSteps = Provider.of<Categories>(context).nbSteps;
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
              onPressed: onRetour,
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
              onPressed: onNext,
              child: Text(
                stepIndex == nbSteps - 1 ? "PAYER" : "SUIVANT",
                style: TextStyle(
                    color: lightColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    stepIndex == nbSteps - 1 ? greenColor : primaryColor,
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
