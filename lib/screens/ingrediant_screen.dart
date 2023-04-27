// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/categoriesProvider.dart';
import 'package:takos_korner/screens/package_screen.dart';
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
  int nbsauce = 0;
  late ScrollController _scrollController;

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
    String type = Provider.of<Ingredients>(context).type;
    List<dynamic> ingrediants = Provider.of<Ingredients>(context).ingrediants;
    List<dynamic> types = Provider.of<Ingredients>(context).types;
    int index = Provider.of<Ingredients>(context).index;
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
                              itemCount: selectedIngrediants.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SideItem(
                                  selectedIngrediants[index]['image'],
                                  selectedIngrediants[index]['name'],
                                  () {},
                                  false,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      TotalAndItems(
                          total, selectedIngrediants.length),
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
                          TopSide(
                              category['name'],
                              index+1,
                              type == "sauce"
                                  ? "Je choisir mes sauces"
                                  : type == "meat"
                                      ? "Je choisir mes viande"
                                      : type == "others"
                                          ? "Je choisir mes salades"
                                          : ""),
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
                                          ingrediant['type']['name'] == type)
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
                                            ingredient['type']['name'] == type)
                                        .toList();
                                    return CategoryItem(
                                        ingrediantsData[index]['image'],
                                        ingrediantsData[index]['name'],
                                        null,
                                        null, () {
                                      setState(() {
                                        if (selectedIngrediants
                                            .contains(ingrediantsData[index])) {
                                          if (type == 'sauce') {
                                            nbsauce -= 1;
                                          }
                                          selectedIngrediants
                                              .remove(ingrediantsData[index]);
                                        } else {
                                          selectedIngrediants
                                              .add(ingrediantsData[index]);
                                          if (type == 'sauce') {
                                            if (nbsauce <= 2) {
                                              nbsauce += 1;
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: ((context) {
                                                    return ErrorMessage("Alert",
                                                        "Il faut choisir que 2 selectedIngrediantss au maximum");
                                                  }));
                                            }
                                          }
                                        }
                                      });
                                    },
                                        selectedIngrediants
                                            .contains(ingrediantsData[index]));
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
        if (types.length - 1 > index) {
          Provider.of<Ingredients>(context, listen: false)
              .setType(types[index + 1]['name'], index + 1);
        } else {
          Provider.of<Ingredients>(context, listen: false)
              .setSelectedIngrediants(selectedIngrediants);
          if (category['supplements'].isNotEmpty) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SupplementsScreen()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PackageScreen()));
          }
        }
      }, () {
        Navigator.of(context).pop();
      }),
    );
  }
}
