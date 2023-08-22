// ignore_for_file: must_be_immutable, file_names, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../provider/categoriesProvider.dart';
import '../utils/colors.dart';

class ConfirmationItem extends StatelessWidget {
  Map<String, dynamic> plat;
  int platNumber;
  List<dynamic> addons;
  List<dynamic> extras;
  VoidCallback deletePlat;
  Function(dynamic selectedAddon, double price) removeAddon;
  Function(dynamic selectedAddon) removeExtra;

  ConfirmationItem(
    this.plat,
    this.platNumber,
    this.addons,
    this.extras,
    this.deletePlat,
    this.removeAddon,
    this.removeExtra,
  );
  Set<dynamic> displayedItems = {};
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> lastProduct =
        Provider.of<Categories>(context).lastProduct;
    int pointer = 0;
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
                  color: redColor,
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
          addons.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text(
                    'Addons',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: textColor),
                  ),
                )
              : Container(),
          addons.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Column(
                    children: addons.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final Map<String, dynamic> item = entry.value;
                      final dynamic currentItem = addons[index];
                      final int count = addons
                          .where((element) =>
                              element['name'] == currentItem['name'] &&
                              element['price'] == currentItem['price'])
                          .length;
                      double totalPrice = 0.0;
                      if (currentItem['type'] != null && index > 0) {
                        if (addons[index - 1]['type'] != null) {
                          if (currentItem['type']['name'] !=
                              addons[index - 1]['type']['name']) {
                            pointer = 0;
                          }
                        }
                      }
                      for (int idx = 0; idx < addons.length; idx++) {
                        final addon = addons[idx];
                        if (addon['name'] == currentItem['name'] &&
                            addon['price'] == currentItem['price']) {
                          final itemType = currentItem['type'];
                          if (itemType != null && itemType['free'] != null) {
                            if (pointer >= itemType['free']) {
                              totalPrice += addon['price'] ?? 0.0;
                            }
                            pointer += 1;
                          }
                        }
                      }
                      if (currentItem['type'] == null) {
                        totalPrice = currentItem['price'].toDouble();
                      }
                      if (displayedItems.contains(currentItem)) {
                        return Container();
                      } else {
                        displayedItems.add(currentItem);
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "X$count ${item['name']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                    color: textColor),
                              ),
                              Row(
                                children: [
                                  item['price'] == null ||
                                          item['price'] == 0 ||
                                          item['price'] > totalPrice
                                      ? Container()
                                      : Text(
                                          "${item['price']}${plat['plat']['currency']}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: textColor,
                                          ),
                                        ),
                                  (item['price'] != null ||
                                              item['price'] != 0) &&
                                          totalPrice == 0
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 3.w),
                                          child: Text(
                                            "Free",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10.sp,
                                              color: textColor,
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.only(left: 3.w),
                                          child: Text(
                                            "$totalPrice${plat['plat']['currency']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10.sp,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                  lastProduct == plat
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () => removeAddon(
                                              item,
                                              (item['price'] != null ||
                                                          item['price'] != 0) &&
                                                      totalPrice == 0
                                                  ? 0.0
                                                  : item['price'].toDouble()),
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
                      }
                    }).toList(),
                  ),
                )
              : Container(),
          extras.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text(
                    'Extras',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: textColor),
                  ),
                )
              : Container(),
          extras.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Column(
                    children: extras.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final Map<String, dynamic> item = entry.value;
                      final dynamic currentItem = extras[index];
                      final int count = extras
                          .where((element) => element == extras[index])
                          .length;
                      if (displayedItems.contains(currentItem)) {
                        return Container();
                      } else {
                        displayedItems.add(currentItem);
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "X$count ${item['name']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                    color: textColor),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 3.w),
                                    child: Text(
                                      "${item['price'] == null || item['price'] == 0 ? "Free" : item['price']}${item['price'] == null || item['price'] == 0 ? "" : item['currency']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${item['price'] == null || item['price'] == 0 ? "Free" : item['price'] * count}${item['price'] == null || item['price'] == 0 ? "" : item['currency']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10.sp,
                                      color: textColor,
                                    ),
                                  ),
                                  lastProduct == plat
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () => removeExtra(item),
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
                      }
                    }).toList(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
