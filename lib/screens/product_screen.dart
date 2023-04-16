// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/dishCategories.dart';
import 'package:takos_korner/screens/ingrediant_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:takos_korner/widgets/Error_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/category.dart';
import '../widgets/sideItem.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  static const routeName = "/ProductScreen";

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedProduct = -1;
  late int selectedCategory;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    selectedCategory =
        Provider.of<Categories>(context, listen: false).selectedCategory;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> categories = Provider.of<Categories>(context).categories;
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
                  SizedBox(
                    width: 82.w,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 95.h),
                      child: Scrollbar(
                        thickness: 4.w,
                        radius: Radius.circular(10.r),
                        controller: _scrollController,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SideItem(
                              categories[index]['image'],
                              categories[index]['name'],
                              () {
                                setState(() {
                                  selectedCategory = index;
                                  selectedProduct = -1;
                                });
                              },
                              index == selectedCategory,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categories[selectedCategory]['name'],
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                                color: textColor),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            height: 4.h,
                            width: 48.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: primaryColor,
                            ),
                            child: Divider(),
                          ),
                          SizedBox(height: 25.h),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 95.h),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: categories[selectedCategory]
                                          ['products']
                                      .length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10.h,
                                    crossAxisSpacing: 23.w,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CategoryItem(
                                      categories[selectedCategory]['products']
                                          [index]['image'],
                                      categories[selectedCategory]['products']
                                          [index]['name'],
                                      categories[selectedCategory]['products']
                                          [index]['price'],
                                      categories[selectedCategory]['products']
                                          [index]['currency'],
                                      () {
                                        setState(() {
                                          if (selectedProduct == index) {
                                            selectedProduct = -1;
                                          } else {
                                            selectedProduct = index;
                                          }
                                        });
                                      },
                                      index == selectedProduct,
                                    );
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
        if (selectedProduct == -1) {
          showDialog(
              context: context,
              builder: ((context) {
                return ErrorMessage(
                    "Alert", "Il faut choisir votre produit pour continuer");
              }));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => IngrediantScreen()));
        }
      }),
    );
  }
}
