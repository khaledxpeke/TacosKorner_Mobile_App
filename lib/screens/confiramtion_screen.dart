// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/screens/category_screen.dart';
import 'package:takos_korner/screens/paiement_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:takos_korner/widgets/appbar.dart';
import 'package:takos_korner/widgets/topSide.dart';
import '../provider/categoriesProvider.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/confirmationItems.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});
  static const routeName = "/ConfirmationScreen";

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  double confirmationTotal = 0;
  String currency = "DT";

  @override
  Widget build(BuildContext context) {
    int stepIndex = Provider.of<Categories>(context).stepIndex;
    confirmationTotal = Provider.of<Categories>(context).total;
    List<dynamic> products = Provider.of<Categories>(context).products;
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
            child: TopSide("Confirmation", stepIndex, ""),
          ),
          SizedBox(height: 15.h),
          Center(
            child: Container(
              width: 183.w,
              constraints: BoxConstraints(
                maxHeight: 280.h,
              ),
              decoration: BoxDecoration(
                  color: lSilverColor,
                  borderRadius: BorderRadius.circular(20.r)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                            children: products.map((product) {
                          // final int index = int.parse(entry.key);
                          // final Map<String, dynamic> product = entry.value;
                          return ConfirmationItem(
                              product['plat']['name'],
                              1,
                              product['plat']['price'],
                              product['plat']['currency'],
                              product['addons']
                                  .map((addons) => {
                                        "name": addons['name'],
                                        "price": addons['price'] ?? "Free",
                                        "currency": addons['currency'] ?? ""
                                      })
                                  .toList());
                        }).toList()),
                      ),
                    ),
                    Divider(
                      thickness: 2.h,
                      indent: 10.w,
                      endIndent: 10.w,
                      color: darkColor,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Total: $confirmationTotal$currency",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 11.sp,
                          color: textColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CategoryScreen()));
              },
              child: Container(
                width: 100.w,
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Text(
                    'Ajouter un autre produit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: lightColor),
                  ),
                ),
              ),
            ),
          )
        ],
      )),
      bottomSheet: bottomsheet(context, () {
        Provider.of<Categories>(context, listen: false)
            .setStepIndex(0);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PaiementScreen()));
      }, () {
        Provider.of<Categories>(context, listen: false)
            .setStepIndex(stepIndex - 1);
        Navigator.of(context).pop();
      }),
    );
  }
}
