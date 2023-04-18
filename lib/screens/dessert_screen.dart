// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/dessertProvider.dart';
import 'package:takos_korner/provider/categoriesProvider.dart';
import 'package:takos_korner/provider/sauceProvider.dart';
import 'package:takos_korner/screens/confiramtion_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/widgets/totalAndItems.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/category.dart';
import '../widgets/sideItem.dart';
import '../widgets/topSide.dart';

class DessertScreen extends StatefulWidget {
  const DessertScreen({Key? key}) : super(key: key);

  static const routeName = "/DessertScreen";

  @override
  State<DessertScreen> createState() => _DessertScreenState();
}

class _DessertScreenState extends State<DessertScreen> {
  late ScrollController _scrollController;
  bool _isLoading = true;
  double total = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    loadData();
  }

  void loadData() async {
    await context.read<Deserts>().getDeserts();
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
    // total = Provider.of<Categories>(context).total;
    List<dynamic> sauce = Provider.of<Sauces>(context).sauce;
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
                              (total + Provider.of<Categories>(context).total)
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TopSide(category['name'], 2,
                              "Oh il vous manque que le dessert!"),
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
                                            .watch<Deserts>()
                                            .deserts
                                            .length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 10.h,
                                          crossAxisSpacing: 23.w,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          List<dynamic> desertData =
                                              context.watch<Deserts>().deserts;
                                          return CategoryItem(
                                              desertData[index]['image'],
                                              desertData[index]['name'],
                                              desertData[index]['price'],
                                              desertData[index]['currency'],
                                              () {
                                            setState(() {
                                              if (sauce.contains(
                                                  desertData[index])) {
                                                total -=
                                                    desertData[index]['price'];
                                                sauce.remove(desertData[index]);
                                              } else {
                                                total +=
                                                    desertData[index]['price'];
                                                sauce.add(desertData[index]);
                                              }
                                            });
                                          }, sauce.contains(desertData[index]));
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
        Provider.of<Deserts>(context, listen: false).setDessert(sauce);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ConfirmationScreen()));
      }, () {
        Navigator.of(context).pop();
      }),
    );
  }
}
