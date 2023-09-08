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
                      final Map<String, dynamic> currentItem = entry.value;
                      final int count = addons
                          .where((element) =>
                              element['name'] == currentItem['name'] &&
                              element['price'] == currentItem['price'])
                          .length;
                      final itemType = currentItem['type'];
                      double totalPrice = 0.0;
                      if (itemType != null) {
                        final startIndex = plat['plat']['rules'].firstWhere(
                            (type) => type['type']['name'] == itemType['name'],
                            orElse: () => null);
                        List filteredItems = addons
                            .where((element) =>
                                element['type'] != null &&
                                element['type']['name'] ==
                                    currentItem['type']['name'])
                            .toList();
                        if (startIndex != null &&
                            startIndex['free'] >= 0 &&
                            startIndex['free'] < filteredItems.length) {
                          List sublist2 =
                              filteredItems.sublist(startIndex['free']);
                          totalPrice = sublist2
                              .where(
                                  (item) => item['name'] == currentItem['name'])
                              .fold(
                                  0.0,
                                  (double sum, item) =>
                                      sum + (item['price'] ?? 0));
                        } else {
                          totalPrice = 0;
                        }
                      } else if (currentItem['price'] != null) {
                        totalPrice = currentItem['price'].toDouble() ?? 0;
                      } else {
                        totalPrice = 0;
                      }
                      if (displayedItems.contains(currentItem)) {
                        return Container();
                      } else {
                        displayedItems.add(currentItem);
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "X$count ${currentItem['name']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                    color: textColor),
                              ),
                              Row(
                                children: [
                                  currentItem['price'] == null ||
                                          currentItem['price'] == 0 ||
                                          currentItem['price'] > totalPrice
                                      ? Container()
                                      : Text(
                                          "${currentItem['price']}${plat['plat']['currency']}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: textColor,
                                          ),
                                        ),
                                  (currentItem['price'] != null ||
                                              currentItem['price'] != 0) &&
                                          totalPrice == 0
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 3.w),
                                          child: Text(
                                            "Gratuit",
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
                                              currentItem,
                                              (currentItem['price'] != null ||
                                                          currentItem[
                                                                  'price'] !=
                                                              0) &&
                                                      totalPrice == 0
                                                  ? 0.0
                                                  : currentItem['price']
                                                      .toDouble()),
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
                                      "${item['price'] == null || item['price'] == 0 ? "Gratuit" : item['price']}${item['price'] == null || item['price'] == 0 ? "" : plat['plat']['currency']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${item['price'] == null || item['price'] == 0 ? "Gratuit" : item['price'] * count}${item['price'] == null || item['price'] == 0 ? "" : plat['plat']['currency']}",
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
