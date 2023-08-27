// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/utils/colors.dart';

import '../provider/categoriesProvider.dart';

class TotalAndItems extends StatelessWidget {
  double total;
  int items;
  TotalAndItems(this.total, this.items);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> category = Provider.of<Categories>(context).category;
    return Container(
      height: 61.h,
      width: 82.w,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.r),
          bottomRight: Radius.circular(15.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
          "Total: ${total.toStringAsFixed(2)} ${category['currency']}",
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 9.sp, color: lightColor),
        ),
        SizedBox(height: 4.h),
        Text(
          "Items: $items",
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 9.sp, color: lightColor),
        ),
      ]),
    );
  }
}
