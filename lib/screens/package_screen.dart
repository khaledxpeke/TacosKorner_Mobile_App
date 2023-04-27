// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/categoriesProvider.dart';
import 'package:takos_korner/provider/ingrediantProvider.dart';
import 'package:takos_korner/provider/packageProvider.dart';
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
  static const routeName = "/PackageScreen";

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  Map<String, dynamic> selectedPackage = {};
  Map<String, dynamic> lastselectedPackage = {};
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
    await context.read<Package>().getPackage();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> category = Provider.of<Categories>(context).category;
    List<dynamic> ingrediants =
        Provider.of<Ingredients>(context).selectedIngrediants;
    total = Provider.of<Categories>(context).total;
    int nbSteps = ((category['supplements'].isEmpty ? 0 : 1) +
            (category['type'].isEmpty ? 0 : category['type'].length) +
            2)
        .toInt();
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
                              itemCount: ingrediants.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (selectedPackage['price'] == 0) {
                                  return Container();
                                }
                                return SideItem(
                                  ingrediants[index]['image'],
                                  ingrediants[index]['name'],
                                  () {},
                                  false,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Consumer<Categories>(
                        builder: (context, categories, _) =>
                            TotalAndItems(categories.total, ingrediants.length),
                      ),
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
                          TopSide(category['name'], nbSteps, ""),
                          SizedBox(height: 100.h),
                          _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : Column(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: context
                                          .watch<Package>()
                                          .packages
                                          .map((package) {
                                        final isSelected =
                                            selectedPackage != {} &&
                                                selectedPackage['name'] ==
                                                    package['name'];
                                        return Row(
                                          children: [
                                            CategoryItem(
                                              package['name'] == "seul"
                                                  ? ""
                                                  : package['image'],
                                              package['name'],
                                              package['name'] == "seul"
                                                  ? null
                                                  : package['price'],
                                              package['name'] == "seul"
                                                  ? null
                                                  : package['currency'],
                                              () {
                                                setState(() {
                                                  if (isSelected) {
                                                    final packagePrice =
                                                        package['price'];
                                                    print(
                                                        "Selected package: ${package['name']}, price: $packagePrice");
                                                    Provider.of<Categories>(
                                                            context,
                                                            listen: false)
                                                        .setTotal(total -
                                                            packagePrice);
                                                    ingrediants.remove(package);
                                                    selectedPackage = {};
                                                    lastselectedPackage = {};
                                                  } else {
                                                    // if (selectedPackage
                                                    //     .isNotEmpty) {
                                                    //   final selectedPrice =
                                                    //       selectedPackage[
                                                    //           'price'];
                                                    //   print(
                                                    //       "Deselected package: ${selectedPackage['name']}, price: $selectedPrice");
                                                    //   Provider.of<Categories>(
                                                    //           context,
                                                    //           listen: false)
                                                    //       .setTotal(total -
                                                    //           selectedPrice);
                                                    //   ingrediants.remove(
                                                    //       selectedPackage);
                                                    // }

                                                    final newPrice =
                                                        package['price'];
                                                    print(
                                                        "Selected new package: ${package['name']}, price: $newPrice");
                                                    Provider.of<Categories>(
                                                            context,
                                                            listen: false)
                                                        .setTotal(total +
                                                            newPrice -
                                                            (lastselectedPackage[
                                                                    'price'] ?? 0));
                                                      ingrediants.remove(
                                                          lastselectedPackage);
                                                    ingrediants.add(package);
                                                    lastselectedPackage =
                                                        package;
                                                    selectedPackage = package;
                                                  }
                                                  print("Total: $total");
                                                });
                                              },
                                              isSelected,
                                            ),
                                            context
                                                        .watch<Package>()
                                                        .packages
                                                        .last ==
                                                    true
                                                ? Container()
                                                : SizedBox(
                                                    width: 15.w,
                                                  )
                                          ],
                                        );
                                      }).toList(),
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
          Provider.of<Ingredients>(context, listen: false)
              .setSelectedIngrediants(ingrediants);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DessertScreen()));
        }
      }, () {
        Provider.of<Categories>(context, listen: false).setTotal(total -
            (selectedPackage != {} ? selectedPackage['price'] ?? 0.0 : 0.0));
        setState(() {
          if (ingrediants.contains(selectedPackage)) {
            ingrediants.remove(selectedPackage);
          }
          selectedPackage = {};
        });
        Navigator.of(context).pop();
      }),
    );
  }
}
