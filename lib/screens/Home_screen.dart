// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/screens/category_screen.dart';
import 'package:takos_korner/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 105.h,
                width: 100.w,
              ),
              SizedBox(
                height: 34.h,
              ),
              Text(
                "Bonjour! vous préferez?",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: textColor,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 11.h,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryScreen()));
                    },
                    child: Container(
                        height: 97.h,
                        width: 82.w,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: darkColor.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: Offset(0, 4.h),
                              )
                            ]),
                        child: Column(
                          children: [
                            SizedBox(height: 6.h),
                            Image.asset(
                              "assets/images/menu.png",
                              height: 59.h,
                              width: 82.6.w,
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              "SUR PLACE",
                              style: TextStyle(
                                  fontSize: 9.sp,
                                  color: lightColor,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(width: 38.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryScreen()));
                    },
                    child: Container(
                        height: 97.h,
                        width: 82.w,
                        decoration: BoxDecoration(
                            color: lSilverColor,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: darkColor.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: Offset(0, 4.h),
                              )
                            ]),
                        child: Column(
                          children: [
                            SizedBox(height: 13.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Image.asset(
                                "assets/images/bag.png",
                                height: 51.h,
                                width: 51.w,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              "IMPORTER",
                              style: TextStyle(
                                  fontSize: 9.sp,
                                  color: textColor,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
