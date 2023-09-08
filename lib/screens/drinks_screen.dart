// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/categoriesProvider.dart';
import 'package:takos_korner/provider/drinkProvider.dart';
import 'package:takos_korner/screens/dessert_screen.dart';
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

class DrinkScreen extends StatefulWidget {
  const DrinkScreen({Key? key}) : super(key: key);

  static const routeName = "/DrinksScreen";

  @override
  State<DrinkScreen> createState() => _DrinkScreenState();
}

class _DrinkScreenState extends State<DrinkScreen> {
  late ScrollController _scrollController;
  List<dynamic> selectedDrink = [];
  List<dynamic> drinks = [];
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
    String result = await context.read<Drinks>().getDrinks();
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
    drinks = Provider.of<Ingredients>(context).selectedExtras;
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
                              itemCount: drinks.length,
                              itemBuilder: (BuildContext context, int index) {
                                final dynamic currentItem = drinks[index];
                                final int count = drinks
                                    .where(
                                        (element) => element == drinks[index])
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
                      TotalAndItems(newTotal + total, drinks.length),
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
                              "Je choisir mes boissons"),
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
                                                .watch<Drinks>()
                                                .drinks
                                                .length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 10.h,
                                              crossAxisSpacing: 23.w,
                                            ),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              List<dynamic> drinksData = context
                                                  .watch<Drinks>()
                                                  .drinks;
                                              final int count = selectedDrink
                                                  .where((element) =>
                                                      element ==
                                                      drinksData[index])
                                                  .length;
                                              return CategoryItem(
                                                  drinksData[index]['image'],
                                                  drinksData[index]['name'],
                                                  double.parse(drinksData[index]
                                                          ['price']
                                                      .toString()),
                                                  category['currency'],
                                                  () {
                                                    if (category['maxDrink']>
                                                        selectedDrink.length) {
                                                      setState(() {
                                                        newTotal +=
                                                            drinksData[index]
                                                                ['price'];
                                                        selectedDrink.add(
                                                            drinksData[index]);
                                                        drinks.add(
                                                            drinksData[index]);
                                                      });
                                                    }
                                                  },
                                                  drinks.contains(
                                                      drinksData[index]),
                                                  drinks.contains(
                                                      drinksData[index]),
                                                  () {
                                                    setState(() {
                                                      newTotal -=
                                                          drinksData[index]
                                                              ['price'];
                                                      selectedDrink.remove(
                                                          drinksData[index]);
                                                      drinks.remove(
                                                          drinksData[index]);
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
            .setSelectedExtras(drinks);
        Provider.of<Categories>(context, listen: false)
            .setTotal(total + newTotal);
        setState(() {
          lastTotal = newTotal;
          newTotal = 0;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DessertScreen()));
      }, () {
        Provider.of<Categories>(context, listen: false)
            .setTotal(total - lastTotal);
        setState(() {
          drinks.removeWhere((item) => selectedDrink.contains(item));
        });
        Provider.of<Ingredients>(context, listen: false)
            .setSelectedExtras(drinks);
        Provider.of<Categories>(context, listen: false)
            .setStepIndex(stepIndex - 1);
        Navigator.of(context).pop();
      }),
    );
  }
}
