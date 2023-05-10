// ignore_for_file: prefer_const_constructors, file_names, no_leading_underscores_for_local_identifiers, unused_element
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/screens/category_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import '../provider/categoriesProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = "/HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Timer? timer;
  bool isInactive = false;
  void _startTimer() {
    timer = Timer(Duration(seconds: 60), () {
      setState(() {
        isInactive = true;
      });
    });
  }

  void _cancelTimer() {
    timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _resetTimer() {
    if (isInactive) {
      setState(() {
        isInactive = false;
      });
      _cancelTimer();
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _resetTimer,
      onPanDown: (details) => _resetTimer(),
      child: Scaffold(
        backgroundColor: lightColor,
        body: isInactive
            ? Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          "assets/images/notTouched.gif",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 80.h,
                    left: (MediaQuery.of(context).size.width - 180.w) / 2,
                    right: (MediaQuery.of(context).size.width - 180.w) / 2,
                    child: Container(
                      width: 180.w,
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
                      child: Padding(
                        padding: EdgeInsets.all(10.h),
                        child: Text(
                          "Touchez l'écran pour commander",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: lightColor),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : SafeArea(
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
                              Provider.of<Categories>(context, listen: false)
                                  .setFormule("Sur place");
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
                              Provider.of<Categories>(context, listen: false)
                                  .setFormule("Importer");
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
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
      ),
    );
  }
}
