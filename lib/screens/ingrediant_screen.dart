// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/categoriesProvider.dart';
import 'package:takos_korner/screens/extra_screen.dart';
import 'package:takos_korner/screens/supplements_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/widgets/totalAndItems.dart';
import '../provider/ingrediantProvider.dart';
import '../widgets/Error_popup.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/category.dart';
import '../widgets/sideItem.dart';
import '../widgets/topSide.dart';

class IngrediantScreen extends StatefulWidget {
  const IngrediantScreen({Key? key}) : super(key: key);

  static const routeName = "/IngrediantScreen";

  @override
  State<IngrediantScreen> createState() => _IngrediantScreenState();
}

class _IngrediantScreenState extends State<IngrediantScreen> {
  List<dynamic> selectedIngrediants = [];
  late ScrollController _scrollController;
  double newTotal = 0;
  List<double> tot = [0.0];

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
    Map<String, dynamic> type = Provider.of<Ingredients>(context).type;
    List<dynamic> ingrediants = Provider.of<Ingredients>(context).ingrediants;
    List<dynamic> types = Provider.of<Ingredients>(context).types;
    int ingredIndex = Provider.of<Ingredients>(context).index;
    int stepIndex = Provider.of<Categories>(context).stepIndex;
    double total = Provider.of<Categories>(context).total;
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
                              itemCount: selectedIngrediants.length,
                              itemBuilder: (BuildContext context, int index) {
                                final dynamic currentItem =
                                    selectedIngrediants[index];
                                final int count = selectedIngrediants
                                    .where((element) =>
                                        element == selectedIngrediants[index])
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
                      TotalAndItems(
                          total + newTotal, selectedIngrediants.length),
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
                          Consumer<Categories>(
                              builder: (context, categories, _) => TopSide(
                                  category['name'],
                                  categories.stepIndex,
                                  type['type']['message'])),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 95.h),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: context
                                      .watch<Ingredients>()
                                      .ingrediants
                                      .where((ingrediant) =>
                                          ingrediant['type']['name'] ==
                                          type['type']['name'])
                                      .length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10.h,
                                    crossAxisSpacing: 23.w,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    List<dynamic> ingrediantsData = ingrediants
                                        .where((ingredient) =>
                                            ingredient['type']['name'] ==
                                            type['type']['name'])
                                        .toList();
                                    int count = selectedIngrediants
                                        .where((element) =>
                                            element == ingrediantsData[index])
                                        .length;
                                    int count2 = selectedIngrediants
                                        .where((element) =>
                                            element['type']?['name'] ==
                                            ingrediantsData[index]['type']
                                                ?['name'])
                                        .length;
                                    return CategoryItem(
                                        ingrediantsData[index]['image'],
                                        ingrediantsData[index]['name'],
                                        (type['quantity'] > 1 &&
                                                    count2 >= type['free']) ||
                                                type['free'] == 0
                                            ? double.parse(
                                                ingrediantsData[index]['price']
                                                    .toString())
                                            : null,
                                        (type['quantity'] > 1 &&
                                                    count2 >= type['free']) ||
                                                type['free'] == 0
                                            ? category['currency']
                                            : null,
                                        () {
                                          if (type['quantity'] > 1) {
                                            if (count2 >= type['quantity']) {
                                              showDialog(
                                                  context: context,
                                                  builder: ((context) {
                                                    return ErrorPopUp("Alert",
                                                        "Il faut choisir que ${type['quantity']} ${type['type']['name']} au maximum");
                                                  }));
                                            }
                                            if (count2 < type['quantity']) {
                                              setState(() {
                                                if (count2 >= type['free']) {
                                                  newTotal +=
                                                      ingrediantsData[index]
                                                          ['price'];
                                                  tot[ingredIndex] +=
                                                      ingrediantsData[index]
                                                          ['price'];
                                                }
                                                selectedIngrediants.add(
                                                    ingrediantsData[index]);
                                              });
                                            }
                                          } else if (selectedIngrediants
                                              .contains(
                                                  ingrediantsData[index])) {
                                            if (type['free'] == 0) {
                                              newTotal -= ingrediantsData[index]
                                                  ['price'];
                                              tot[ingredIndex] -=
                                                  ingrediantsData[index]
                                                      ['price'];
                                            }
                                            setState(() {
                                              selectedIngrediants.remove(
                                                  ingrediantsData[index]);
                                            });
                                          } else {
                                            if (type['free'] == 0) {
                                              if (count2 >= type['quantity']) {
                                                showDialog(
                                                    context: context,
                                                    builder: ((context) {
                                                      return ErrorPopUp("Alert",
                                                          "Il faut choisir que ${type['quantity']} ${type['type']['name']} au maximum");
                                                    }));
                                              } else if (count2 <
                                                  type['quantity']) {
                                                setState(() {
                                                  newTotal +=
                                                      ingrediantsData[index]
                                                          ['price'];
                                                  tot[ingredIndex] +=
                                                      ingrediantsData[index]
                                                          ['price'];
                                                  selectedIngrediants.add(
                                                      ingrediantsData[index]);
                                                });
                                              }
                                            } else if (count2 >= type['free']) {
                                              showDialog(
                                                  context: context,
                                                  builder: ((context) {
                                                    return ErrorPopUp("Alert",
                                                        "Il faut choisir que ${type['free']} ${type['type']['name']} au maximum");
                                                  }));
                                            } else {
                                              setState(() {
                                                selectedIngrediants.add(
                                                    ingrediantsData[index]);
                                              });
                                            }
                                          }
                                        },
                                        selectedIngrediants
                                            .contains(ingrediantsData[index]),
                                        type['quantity'] > 1 &&
                                            selectedIngrediants.contains(
                                                ingrediantsData[index]),
                                        () {
                                          setState(() {
                                            selectedIngrediants
                                                .remove(ingrediantsData[index]);
                                            if (count2 > type['free']) {
                                              String typeName =
                                                  ingrediantsData[index]['type']
                                                      ['name'];
                                              List list = selectedIngrediants
                                                  .where((element) =>
                                                      element['type']['name'] ==
                                                      typeName)
                                                  .toList();
                                              int startIndex = type['free'];
                                              List sublist =
                                                  list.sublist(startIndex);
                                              newTotal -= tot[ingredIndex];
                                              tot[ingredIndex] = sublist.fold(
                                                  0,
                                                  (double sum, item) =>
                                                      sum +
                                                      (item['price'] ?? 0));
                                              newTotal += tot[ingredIndex];
                                            }
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
        bool hasSelectedIngredients = selectedIngrediants.any((element) {
          return element['type']['name'] == type['type']['name'];
        });
        if (type['type']['isRequired'] && !hasSelectedIngredients) {
          showDialog(
              context: context,
              builder: ((context) {
                return ErrorPopUp(
                  "Alert",
                  "Il faut choisir au moins un ${type['type']['name']}",
                );
              }));
        } else {
          Provider.of<Categories>(context, listen: false)
              .setStepIndex(stepIndex + 1);
          if (types.length - 1 > ingredIndex) {
            Provider.of<Ingredients>(context, listen: false)
                .setType(types[ingredIndex + 1], ingredIndex + 1);
            setState(() {
              tot.add(0);
            });
          } else {
            Provider.of<Ingredients>(context, listen: false)
                .setSelectedExtras(selectedIngrediants);
            Provider.of<Categories>(context, listen: false)
                .setTotal(total + newTotal);
            setState(() {
              newTotal = 0;
            });
            if (category['supplements'].isNotEmpty) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SupplementsScreen()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ExtraScreen()));
            }
          }
        }
      }, () {
        Provider.of<Categories>(context, listen: false)
            .setStepIndex(stepIndex - 1);
        if (ingredIndex > 0) {
          setState(() {
            selectedIngrediants.removeWhere((ingrediant) =>
                ingrediant['type']['name'] == type['type']['name']);
            newTotal -= tot[ingredIndex];
            tot.removeLast();
          });
          Provider.of<Ingredients>(context, listen: false)
              .setType(types[ingredIndex - 1], ingredIndex - 1);
        } else {
          Navigator.of(context).pop();
        }
      }, false),
    );
  }
}
