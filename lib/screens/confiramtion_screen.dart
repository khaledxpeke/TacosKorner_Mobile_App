// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/screens/category_screen.dart';
import 'package:takos_korner/screens/paiement_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:takos_korner/widgets/appbar.dart';
import 'package:takos_korner/widgets/confirmationButton.dart';
import 'package:takos_korner/widgets/topSide.dart';
import '../provider/categoriesProvider.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> category = Provider.of<Categories>(context).category;
    // total = Provider.of<Categories>(context).total;
    // List<dynamic> sauce = Provider.of<Sauces>(context).sauce;
    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6.h),
          appBar(context),
          SizedBox(height: 26.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: TopSide(category['name'], 4, ""),
          ),
          SizedBox(height: 85.h),
          Center(
            child: Column(
              children: [
                Container(
                  height: 136.h,
                  width: 183.w,
                  decoration: BoxDecoration(
                      color: lSilverColor,
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Center(
                    child: Text(
                      'Recap de commande',
                      style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: darkColor),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConfirmationButton(lightColor, greenColor, 'Valider', () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaiementScreen()));
                    }),
                    SizedBox(width: 19.w),
                    ConfirmationButton(lightColor, redColor, 'Catégoris', () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryScreen()));
                    })
                  ],
                ),
                SizedBox(height: 8.h),
                ConfirmationButton(lightColor, primaryColor, 'Retour', () {
                  Navigator.of(context).pop();
                })
              ],
            ),
          )
        ],
      )),
    );
  }
}
