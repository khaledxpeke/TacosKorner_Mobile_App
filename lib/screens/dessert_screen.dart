// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/categoriesProvider.dart';
import 'package:takos_korner/provider/dessertProvider.dart';
import 'package:takos_korner/screens/confiramtion_screen.dart';
import 'package:takos_korner/screens/package_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/widgets/totalAndItems.dart';
import '../provider/ingrediantProvider.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/category.dart';
import '../widgets/error_meesage.dart';
import '../widgets/loading.dart';
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
  List<dynamic> selectedDessert = [];
  List<dynamic> desserts = [];
  double newTotal = 0;
  double lastTotal = 0;
  bool _isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    loadData();
  }

  void loadData() async {
    String result = await context.read<Deserts>().getDeserts();
    setState(() {
      _isLoading = false;
      if (result != "success") {
        errorMessage = result;
      }
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
    desserts = Provider.of<Ingredients>(context).selectedIngrediants;
    double total = Provider.of<Categories>(context).total;
    int stepIndex = Provider.of<Categories>(context).stepIndex;
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
                              itemCount: desserts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SideItem(
                                  desserts[index]['image'],
                                  desserts[index]['name'],
                                  () {},
                                  false,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      TotalAndItems(newTotal + total, desserts.length),
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
                              "Oh il vous manque que le dessert!"),
                          _isLoading
                              ? LoadingWidget()
                              : errorMessage != ""
                                  ? ErrorMessage(errorMessage)
                                  : Expanded(
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 95.h),
                                          child: GridView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
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
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              List<dynamic> dessertsData =
                                                  context
                                                      .watch<Deserts>()
                                                      .deserts;
                                              return CategoryItem(
                                                  dessertsData[index]['image'],
                                                  dessertsData[index]['name'],
                                                  dessertsData[index]['price'],
                                                  dessertsData[index]
                                                      ['currency'], () {
                                                setState(() {
                                                  if (selectedDessert.contains(
                                                      dessertsData[index])) {
                                                    newTotal -=
                                                        dessertsData[index]
                                                            ['price'];
                                                    selectedDessert.remove(
                                                        dessertsData[index]);
                                                    desserts.remove(
                                                        dessertsData[index]);
                                                  } else {
                                                    newTotal +=
                                                        dessertsData[index]
                                                            ['price'];
                                                    selectedDessert.add(
                                                        dessertsData[index]);
                                                    desserts.add(
                                                        dessertsData[index]);
                                                  }
                                                });
                                              },
                                                  desserts.contains(
                                                      dessertsData[index]));
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
            .setSelectedIngrediants(desserts);
        Provider.of<Categories>(context, listen: false)
            .setTotal(total + newTotal);
        Provider.of<Categories>(context, listen: false).setProducts(
            {"plat": category, "addons": desserts, "total": total + newTotal});
        setState(() {
          // desserts.removeWhere((item) => selectedDessert.contains(item));
          lastTotal = newTotal;
          newTotal = 0;
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ConfirmationScreen()));
      }, () {
        Provider.of<Categories>(context, listen: false)
            .setTotal(total - lastTotal);
        setState(() {
          desserts.removeWhere((item) => selectedDessert.contains(item));
        });
        Provider.of<Ingredients>(context, listen: false)
            .setSelectedIngrediants(desserts);
        Provider.of<Categories>(context, listen: false)
            .setStepIndex(stepIndex - 1);
        Navigator.of(context).pop();
      }),
    );
  }
}
