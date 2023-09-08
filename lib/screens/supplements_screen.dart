// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/categoriesProvider.dart';
import 'package:takos_korner/provider/suppelementsProvider.dart';
import 'package:takos_korner/screens/extra_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/widgets/totalAndItems.dart';
import '../provider/ingrediantProvider.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/category.dart';
import '../widgets/sideItem.dart';
import '../widgets/topSide.dart';

class SupplementsScreen extends StatefulWidget {
  const SupplementsScreen({Key? key}) : super(key: key);

  static const routeName = "/SupplementsScreen";

  @override
  State<SupplementsScreen> createState() => _SupplementsScreenState();
}

class _SupplementsScreenState extends State<SupplementsScreen> {
  late ScrollController _scrollController;
  List<dynamic> selectedSupplements = [];
  List<dynamic> supplements = [];
  double newTotal = 0;
  double lastTotal = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> category = Provider.of<Categories>(context).category;
    supplements = Provider.of<Ingredients>(context).selectedExtras;
    double total = Provider.of<Categories>(context).total;
    int stepIndex = Provider.of<Categories>(context).stepIndex;
    Set<dynamic> displayedItems = {};
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
                        0
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
                              itemCount: supplements.length,
                              itemBuilder: (BuildContext context, int index) {
                                final dynamic currentItem = supplements[index];
                                final int count = supplements
                                    .where(
                                        (element) => element == supplements[index])
                                    .length;
                                if (displayedItems.contains(currentItem)) {
                                  return Container();
                                } else {
                                  displayedItems.add(currentItem);
                                  return SideItem(
                                    currentItem['image'],
                                    currentItem['name'],
                                    () {},
                                    false,
                                    count,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      TotalAndItems(newTotal + total, supplements.length),
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
                          TopSide(category['name'], stepIndex,
                              "Je choisir mes supplements"),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 95.h),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: context
                                      .watch<Supplements>()
                                      .supplements
                                      .length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10.h,
                                    crossAxisSpacing: 23.w,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    List<dynamic> supplementsData = context
                                        .watch<Supplements>()
                                        .supplements;
                                    return CategoryItem(
                                        supplementsData[index]['image'],
                                        supplementsData[index]['name'],
                                        double.parse(supplementsData[index]['price'].toString()),
                                        category['currency'], () {
                                      setState(() {
                                        if (supplements
                                            .contains(supplementsData[index])) {
                                          newTotal -=
                                              supplementsData[index]['price'];
                                          supplements
                                              .remove(supplementsData[index]);
                                          selectedSupplements
                                              .remove(supplementsData[index]);
                                        } else {
                                          newTotal +=
                                              supplementsData[index]['price'];
                                          supplements
                                              .add(supplementsData[index]);
                                          selectedSupplements
                                              .add(supplementsData[index]);
                                        }
                                      });
                                    },
                                        selectedSupplements
                                            .contains(supplementsData[index]),false,(){},1);
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
        Provider.of<Categories>(context, listen: false)
            .setStepIndex(stepIndex + 1);
        Provider.of<Ingredients>(context, listen: false)
            .setSelectedExtras(supplements);
        Provider.of<Categories>(context, listen: false)
            .setTotal(total + newTotal);
        setState(() {
          lastTotal = newTotal;
          newTotal = 0;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExtraScreen()));
      }, () {
        Provider.of<Categories>(context, listen: false)
            .setTotal(total - lastTotal);
        setState(() {
          supplements.removeWhere((item) => selectedSupplements.contains(item));
        });
        Provider.of<Ingredients>(context, listen: false)
            .setSelectedExtras(supplements);
        Provider.of<Categories>(context, listen: false)
            .setStepIndex(stepIndex - 1);
        Navigator.of(context).pop();
      }),
    );
  }
}
