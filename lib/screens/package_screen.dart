// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/categoriesProvider.dart';
import 'package:takos_korner/provider/sauceProvider.dart';
import 'package:takos_korner/screens/dessert_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:takos_korner/widgets/bottomsheet.dart';
import 'package:takos_korner/widgets/category.dart';
import 'package:takos_korner/widgets/topSide.dart';
import 'package:takos_korner/widgets/totalAndItems.dart';

import '../widgets/Error_popup.dart';
import '../widgets/appbar.dart';
import '../widgets/sideItem.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  Map<String, dynamic> selectedPackage = {};
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> category = Provider.of<Categories>(context).category;
    List<dynamic> sauce = Provider.of<Sauces>(context).sauce;
    double total = Provider.of<Categories>(context).total;
    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),
            appBar(context),
            SizedBox(height: 26.h),
            Expanded(
              child: Row(
                children: [
                  Column(
                    children: [
                      SideItem(
                        category['image'],
                        category['name'],
                        () {},
                        true,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 82.w,
                          child: Scrollbar(
                            thickness: 4.w,
                            radius: Radius.circular(10.r),
                            controller: _scrollController,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: sauce.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SideItem(
                                  sauce[index]['image'],
                                  sauce[index]['name'],
                                  () {},
                                  false,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      TotalAndItems(
                          double.parse((total +
                                  (selectedPackage != {}
                                      ? selectedPackage['price'] ?? 0.0
                                      : 0.0))
                              .toStringAsFixed(2)),
                          sauce.length),
                      SizedBox(
                        height: 85.h,
                      )
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        children: [
                          TopSide(category['name'], 2, ""),
                          SizedBox(height: 100.h),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Je choisi ma formule",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w800,
                                    color: textColor),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CategoryItem("assets/images/pepsi.png",
                                      "Menu", 2.5, 'DT', () {
                                    if (selectedPackage['_id'] == 1) {
                                      setState(() {
                                        sauce.remove(selectedPackage);
                                        selectedPackage = {};
                                      });
                                    } else {
                                      if (sauce.contains(selectedPackage)) {
                                        sauce.remove(selectedPackage);
                                      }
                                      setState(() {
                                        selectedPackage = {
                                          '_id': 1,
                                          'name': 'Menu',
                                          'image': 'assets/images/pepsi.png',
                                          'price': 2.5,
                                          'currency': 'DT'
                                        };
                                        sauce.add(selectedPackage);
                                      });
                                    }
                                  }, selectedPackage['_id'] == 1),
                                  SizedBox(width: 15.w),
                                  CategoryItem("assets/images/fries.png",
                                      "FRITE", 1.0, "DT", () {
                                    if (selectedPackage['_id'] == 2) {
                                      setState(() {
                                        sauce.remove(selectedPackage);
                                        selectedPackage = {};
                                      });
                                    } else {
                                      if (sauce.contains(selectedPackage)) {
                                        sauce.remove(selectedPackage);
                                      }
                                      setState(() {
                                        selectedPackage = {
                                          '_id': 2,
                                          'image': 'assets/images/fries.png',
                                          'name': 'FRITE',
                                          'price': 1,
                                          'currency': 'DT'
                                        };
                                        sauce.add(selectedPackage);
                                      });
                                    }
                                  }, selectedPackage['_id'] == 2),
                                  SizedBox(width: 15.w),
                                  CategoryItem("", "SEUL", null, null, () {
                                    if (selectedPackage['_id'] == 3) {
                                      setState(() {
                                        sauce.remove(selectedPackage);
                                        selectedPackage = {};
                                      });
                                    } else {
                                      if (sauce.contains(selectedPackage)) {
                                        sauce.remove(selectedPackage);
                                      }
                                      setState(() {
                                        selectedPackage = {
                                          '_id': 3,
                                          'name': 'SEUL',
                                          'image': '',
                                          'price': null,
                                          'currency': null
                                        };
                                        sauce.add(selectedPackage);
                                      });
                                    }
                                  }, selectedPackage['_id'] == 3)
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: bottomsheet(context, () {
        if (selectedPackage.isEmpty) {
          showDialog(
              context: context,
              builder: ((context) {
                return ErrorMessage(
                    "Alert", "Veuillez sélectionner une formule");
              }));
        } else {
          Provider.of<Sauces>(context, listen: false).setSauce(sauce);
          Provider.of<Categories>(context, listen: false)
              .setTotal(total + selectedPackage['price']);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DessertScreen()));
        }
      }, () {
        Provider.of<Categories>(context, listen: false).setTotal(total -
            (selectedPackage != {} ? selectedPackage['price'] ?? 0.0 : 0.0));
        setState(() {
          if (sauce.contains(selectedPackage)) {
            sauce.remove(selectedPackage);
          }
          selectedPackage = {};
        });
        Navigator.of(context).pop();
      }),
    );
  }
}
