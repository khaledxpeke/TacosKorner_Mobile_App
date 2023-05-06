// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/screens/product_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:takos_korner/widgets/appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/widgets/bottomsheet.dart';
import 'package:takos_korner/widgets/category.dart';

import '../provider/categoriesProvider.dart';
import '../widgets/Error_popup.dart';
import '../widgets/error_meesage.dart';
import '../widgets/loading.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  static const routeName = "/CategoryScreen";
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int selectedCategory = -1;
  bool _isLoading = true;
  List<dynamic> categories = [];
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    String result = await context.read<Categories>().getCategories();
    setState(() {
      _isLoading = false;
      if (result != "success") {
        errorMessage = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int lastStepIndex = Provider.of<Categories>(context).lastStepIndex;
    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 6.h),
            appBar(context),
            SizedBox(height: 44.h),
            Text(
              'CATEGORIES',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: textColor),
            ),
            SizedBox(height: 26.h),
            _isLoading
                ? LoadingWidget()
                : errorMessage != ""
                    ? ErrorMessage(errorMessage)
                    : Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(53.w, 0, 53.w, 95.h),
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  context.watch<Categories>().categories.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10.h,
                                crossAxisSpacing: 23.w,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                categories =
                                    context.watch<Categories>().categories;
                                return CategoryItem(
                                  categories[index]['image'],
                                  categories[index]['name'],
                                  null,
                                  null,
                                  () {
                                    setState(() {
                                      if (selectedCategory == index) {
                                        selectedCategory = -1;
                                      } else {
                                        selectedCategory = index;
                                      }
                                    });
                                  },
                                  index == selectedCategory,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
          ],
        ),
      ),
      bottomSheet: bottomsheet(context, () {
        if (selectedCategory == -1) {
          showDialog(
              context: context,
              builder: ((context) {
                return ErrorPopUp("Alert",
                    "Il faut choisir votre catégorie préférée d'abord");
              }));
        } else {
          Provider.of<Categories>(context, listen: false)
              .setSelectedCategory(selectedCategory);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProductScreen()));
        }
      }, () {
        if (lastStepIndex > 0) {
          Provider.of<Categories>(context, listen: false)
              .setStepIndex(lastStepIndex);
        }
        Navigator.of(context).pop();
      },false),
    );
  }
}
