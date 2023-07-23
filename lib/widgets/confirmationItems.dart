// ignore_for_file: must_be_immutable, file_names, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../provider/categoriesProvider.dart';
import '../utils/colors.dart';

class ConfirmationItem extends StatelessWidget {
  Map<String, dynamic> plat;
  int platNumber;
  List<dynamic> items;
  VoidCallback deletePlat;
  Function(dynamic selectedAddon) removeAddon;

  ConfirmationItem(
    this.plat,
    this.platNumber,
    this.items,
    this.deletePlat,
    this.removeAddon,
  );

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> lastProduct =
        Provider.of<Categories>(context).lastProduct;
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "plat principale ${platNumber == 0 ? '' : platNumber}",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 11.sp,
                    color: textColor),
              ),
              IconButton(
                onPressed: deletePlat,
                icon: Icon(
                  Icons.close,
                  size: 15.sp,
                ),
              )
            ],
          ),
          SizedBox(height: 5.h),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              plat['plat']['name'],
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  color: textColor),
            ),
            Text(
              "${double.parse(plat['plat']['price'].toString())}${plat['plat']['currency']}",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  color: textColor),
            ),
          ]),
          SizedBox(height: 5.h),
          items.isNotEmpty
              ? Text(
                  'Addons',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 11.sp,
                      color: textColor),
                )
              : Container(),
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
                      Row(
                        children: [
                          Text(
                            "${item['price']}${item['currency']}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              color: textColor,
                            ),
                          ),
                          lastProduct == plat
                              ? Container()
                              : GestureDetector(
                                  onTap: () => removeAddon(item),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4.w),
                                    child: Text(
                                      '-',
                                      style: TextStyle(
                                          color: redColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26),
                                    ),
                                  ),
                                )
                        ],
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
