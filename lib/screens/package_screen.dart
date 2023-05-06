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
import '../widgets/error_meesage.dart';
import '../widgets/loading.dart';
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
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    loadData();
  }

  void loadData() async {
    String result = await context.read<Package>().getPackage();
    setState(() {
      _isLoading = false;
      if (result != "success") {
        errorMessage = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> category = Provider.of<Categories>(context).category;
    List<dynamic> ingrediants =
        Provider.of<Ingredients>(context).selectedIngrediants;
    total = Provider.of<Categories>(context).total;
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
                              itemCount: ingrediants.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (ingrediants[index]['name'] != "Seul") {
                                  return SideItem(
                                    ingrediants[index]['image'],
                                    ingrediants[index]['name'],
                                    () {},
                                    false,
                                  );
                                }
                                return Container();
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
                          TopSide(category['name'], stepIndex, ""),
                          SizedBox(height: 100.h),
                          _isLoading
                              ? LoadingWidget()
                              : errorMessage != ""
                                  ? ErrorMessage(errorMessage)
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                  package['name'] == "Seul"
                                                      ? ""
                                                      : package['image'],
                                                  package['name'],
                                                  package['name'] == "Seul"
                                                      ? null
                                                      : double.parse(
                                                          package['price']
                                                              .toString()),
                                                  package['name'] == "Seul"
                                                      ? null
                                                      : package['currency'],
                                                  () {
                                                    setState(() {
                                                      if (isSelected) {
                                                        final packagePrice =
                                                            package['price'];
                                                        Provider.of<Categories>(
                                                                context,
                                                                listen: false)
                                                            .setTotal(total -
                                                                packagePrice);
                                                        ingrediants
                                                            .remove(package);
                                                        selectedPackage = {};
                                                        lastselectedPackage =
                                                            {};
                                                      } else {
                                                        final newPrice =
                                                            package['price'];
                                                        Provider.of<Categories>(
                                                                context,
                                                                listen: false)
                                                            .setTotal(total +
                                                                newPrice -
                                                                (lastselectedPackage[
                                                                        'price'] ??
                                                                    0));
                                                        ingrediants.remove(
                                                            lastselectedPackage);
                                                        ingrediants
                                                            .add(package);
                                                        lastselectedPackage =
                                                            package;
                                                        selectedPackage =
                                                            package;
                                                      }
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
                return ErrorPopUp("Alert", "Veuillez sélectionner une formule");
              }));
        } else {
          Provider.of<Categories>(context, listen: false)
              .setStepIndex(stepIndex + 1);
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
        Provider.of<Categories>(context, listen: false)
            .setStepIndex(stepIndex - 1);
        Navigator.of(context).pop();
      },false),
    );
  }
}
