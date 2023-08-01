// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/categoriesProvider.dart';
import 'package:takos_korner/provider/ingrediantProvider.dart';
import 'package:takos_korner/provider/extraProvider.dart';
import 'package:takos_korner/screens/drinks_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:takos_korner/widgets/bottomsheet.dart';
import 'package:takos_korner/widgets/category.dart';
import 'package:takos_korner/widgets/topSide.dart';
import 'package:takos_korner/widgets/totalAndItems.dart';
import '../widgets/appbar.dart';
import '../widgets/error_meesage.dart';
import '../widgets/loading.dart';
import '../widgets/sideItem.dart';

class ExtraScreen extends StatefulWidget {
  const ExtraScreen({super.key});
  static const routeName = "/ExtraScreen";

  @override
  State<ExtraScreen> createState() => _ExtraScreenState();
}

class _ExtraScreenState extends State<ExtraScreen> {
  late ScrollController _scrollController;
  List<dynamic> selectedExtra = [];
  List<dynamic> extras = [];
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
    String result = await context.read<Extra>().getExtra();
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
    extras = Provider.of<Ingredients>(context).selectedIngrediants;
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
                              itemCount: extras.length,
                              itemBuilder: (BuildContext context, int index) {
                                final dynamic currentItem = extras[index];
                                final int count = selectedExtra
                                    .where(
                                        (element) => element == extras[index])
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
                      TotalAndItems(newTotal + total, extras.length),
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
                              "Je choisir mes extra"),
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
                                                .watch<Extra>()
                                                .extras
                                                .length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 10.h,
                                              crossAxisSpacing: 23.w,
                                            ),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              List<dynamic> extrasData =
                                                  context.watch<Extra>().extras;
                                              final int count = selectedExtra
                                                  .where((element) =>
                                                      element ==
                                                      extrasData[index])
                                                  .length;
                                              return CategoryItem(
                                                  extrasData[index]['image'],
                                                  extrasData[index]['name'],
                                                  double.parse(extrasData[index]
                                                          ['price']
                                                      .toString()),
                                                  extrasData[index]['currency'],
                                                  () {
                                                    if (extrasData[index]
                                                            ['max'] >
                                                        count) {
                                                      setState(() {
                                                        newTotal +=
                                                            extrasData[index]
                                                                ['price'];
                                                        selectedExtra.add(
                                                            extrasData[index]);
                                                        extras.add(
                                                            extrasData[index]);
                                                      });
                                                    }
                                                  },
                                                  extras.contains(
                                                      extrasData[index]),
                                                  extras.contains(
                                                      extrasData[index]),
                                                  () {
                                                    setState(() {
                                                      newTotal -=
                                                          extrasData[index]
                                                              ['price'];
                                                      selectedExtra.remove(
                                                          extrasData[index]);
                                                      extras.remove(
                                                          extrasData[index]);
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
            .setSelectedIngrediants(extras);
        Provider.of<Categories>(context, listen: false)
            .setTotal(total + newTotal);
        setState(() {
          lastTotal = newTotal;
          newTotal = 0;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DrinkScreen()));
      }, () {
        Provider.of<Categories>(context, listen: false)
            .setTotal(total - lastTotal);
        setState(() {
          extras.removeWhere((item) => selectedExtra.contains(item));
        });
        Provider.of<Ingredients>(context, listen: false)
            .setSelectedIngrediants(extras);
        Provider.of<Categories>(context, listen: false)
            .setStepIndex(stepIndex - 1);
        Navigator.of(context).pop();
      }, false),
    );
  }
}
