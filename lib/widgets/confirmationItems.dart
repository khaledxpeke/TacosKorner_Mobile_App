// ignore_for_file: must_be_immutable, file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors.dart';

class ConfirmationItem extends StatelessWidget {
  String plat;
  int platNumber;
  String currency;
  double price;
  List<dynamic> items;

  ConfirmationItem(
      this.plat, this.platNumber, this.price, this.currency, this.items);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "plat principale ${platNumber == 1 ? '' : platNumber}",
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 11.sp, color: textColor),
          ),
          SizedBox(height: 5.h),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              plat,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  color: textColor),
            ),
            Text(
              "$price$currency",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  color: textColor),
            ),
          ]),
          SizedBox(height: 5.h),
          Text(
            'Addons',
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 11.sp, color: textColor),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Column(
              children: items.map((item) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                            color: textColor),
                      ),
                      Text(
                        "${item['price']}${item['currency']}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                            color: textColor),
                      ),
                    ]);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
