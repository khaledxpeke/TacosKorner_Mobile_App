// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/categoriesProvider.dart';
import 'package:takos_korner/screens/package_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/widgets/totalAndItems.dart';
import '../provider/sauceProvider.dart';
import '../widgets/Error_popup.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/category.dart';
import '../widgets/sideItem.dart';
import '../widgets/topSide.dart';

class SauceScreen extends StatefulWidget {
  const SauceScreen({Key? key}) : super(key: key);

  static const routeName = "/SauceScreen";

  @override
  State<SauceScreen> createState() => _SauceScreenState();
}

class _SauceScreenState extends State<SauceScreen> {
  List<dynamic> sauce = [];
  double total = 0;
  double nbSauces = 0;
  late ScrollController _scrollController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    loadData();
  }

  void loadData() async {
    await context.read<Sauces>().getSauces();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> category = Provider.of<Categories>(context).category;
    // total += category['price'];
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
                          double.parse(
                              (total + category['price']).toStringAsFixed(2)),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TopSide(category['name'], 1, "Je choisir mes sauces"),
                          _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : Expanded(
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 95.h),
                                      child: GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: context
                                            .watch<Sauces>()
                                            .sauces
                                            .length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 10.h,
                                          crossAxisSpacing: 23.w,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          List<dynamic> sauceData =
                                              context.watch<Sauces>().sauces;
                                          return CategoryItem(
                                              sauceData[index]['image'],
                                              sauceData[index]['name'],
                                              sauceData[index]['price'],
                                              sauceData[index]['currency'], () {
                                            setState(() {
                                              if (sauce
                                                  .contains(sauceData[index])) {
                                                nbSauces -= 1;
                                                total -=
                                                    sauceData[index]['price'];
                                                sauce.remove(sauceData[index]);
                                              } else {
                                                if (nbSauces < 2) {
                                                  nbSauces += 1;
                                                  total +=
                                                      sauceData[index]['price'];
                                                  sauce.add(sauceData[index]);
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: ((context) {
                                                        return ErrorMessage(
                                                            "Alert",
                                                            "Il faut choisir que 2 sauces au maximum");
                                                      }));
                                                }
                                              }
                                            });
                                          }, sauce.contains(sauceData[index]));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
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
        Provider.of<Sauces>(context, listen: false).setSauce(sauce);
        Provider.of<Categories>(context, listen: false)
            .setTotal(total + category['price']);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PackageScreen()));
      }, () {
        Provider.of<Categories>(context, listen: false)
            .setTotal(total - category['price']);
        Navigator.of(context).pop();
      }),
    );
  }
}
