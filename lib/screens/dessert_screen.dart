// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/categoriesProvider.dart';
import 'package:takos_korner/provider/dessertProvider.dart';
import 'package:takos_korner/screens/confiramtion_screen.dart';
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
  List<dynamic> extras = [];
  double newTotal = 0;
  double lastTotal = 0;
  int size = 0;
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
    desserts = Provider.of<Ingredients>(context).selectedExtras;
    extras = Provider.of<Ingredients>(context).selectedExtras;
    size = Provider.of<Ingredients>(context).size;
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
                          category['image'], category['name'], () {}, true, 0),
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
                                final dynamic currentItem = desserts[index];
                                final int count = desserts
                                    .where(
                                        (element) => element == desserts[index])
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
                                              final int count = selectedDessert
                                                  .where((element) =>
                                                      element ==
                                                      dessertsData[index])
                                                  .length;
                                              return CategoryItem(
                                                  dessertsData[index]['image'],
                                                  dessertsData[index]['name'],
                                                  double.parse(
                                                      dessertsData[index]
                                                              ['price']
                                                          .toString()),
                                                  category['currency'],
                                                  () {
                                                    if (category['maxDessert']>
                                                        selectedDessert.length) {
                                                      setState(() {
                                                        newTotal +=
                                                            dessertsData[index]
                                                                ['price'];
                                                        selectedDessert.add(
                                                            dessertsData[
                                                                index]);
                                                        desserts.add(
                                                            dessertsData[
                                                                index]);
                                                      });
                                                    }
                                                  },
                                                  desserts.contains(
                                                      dessertsData[index]),
                                                  desserts.contains(
                                                      dessertsData[index]),
                                                  () {
                                                    setState(() {
                                                      newTotal -=
                                                          dessertsData[index]
                                                              ['price'];
                                                      selectedDessert.remove(
                                                          dessertsData[index]);
                                                      desserts.remove(
                                                          dessertsData[index]);
                                                    });
                                                  },
                                                  count);
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
            .setSelectedExtras(desserts);
        Provider.of<Categories>(context, listen: false)
            .setTotal(total + newTotal);
        List<dynamic> ingrediants = desserts.sublist(0,size);
        List<dynamic> extras = desserts.sublist(size,desserts.length);
        Provider.of<Categories>(context, listen: false).setProducts({
          "plat": category,
          "addons": ingrediants,
          "extras":  extras,
          "total": total + newTotal
        });
        setState(() {
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
            .setSelectedExtras(desserts);
        Provider.of<Categories>(context, listen: false)
            .setStepIndex(stepIndex - 1);
        Navigator.of(context).pop();
      }, false),
    );
  }
}
