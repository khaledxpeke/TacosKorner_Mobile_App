// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/history.dart';
import 'package:takos_korner/screens/category_screen.dart';
import 'package:takos_korner/screens/paiement_screen.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:takos_korner/widgets/appbar.dart';
import 'package:takos_korner/widgets/topSide.dart';
import '../provider/categoriesProvider.dart';
import '../widgets/Error_popup.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/confirmationItems.dart';
import '../widgets/confirmationMessage.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});
  static const routeName = "/ConfirmationScreen";

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  double confirmationTotal = 0.0;
  String currency = "DT";
  late ScrollController _scrollController;
  bool isLoading = false;
  String errorMessage = "";

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
    int stepIndex = Provider.of<Categories>(context).stepIndex;
    List<dynamic> products = Provider.of<Categories>(context).products;
    Map<String, dynamic> lastProduct =
        Provider.of<Categories>(context).lastProduct;
    String formule = Provider.of<Categories>(context).formule;
    setState(() {
      confirmationTotal = 0.0;
    });
    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),
            appBar(context),
            SizedBox(height: 26.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: TopSide("Confirmation", stepIndex, ""),
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: Center(
                child: Container(
                  width: 183.w,
                  decoration: BoxDecoration(
                    color: lSilverColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Scrollbar(
                            thickness: 4.w,
                            radius: Radius.circular(10.r),
                            controller: _scrollController,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  if (products.isEmpty)
                                    Center(
                                      child: Text(
                                        "Il n'y a pas de produits sélectionnés pour le moment",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.sp,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ...products.asMap().entries.map((entry) {
                                    final int index = entry.key;
                                    final Map<String, dynamic> product =
                                        entry.value;
                                    setState(() {
                                      confirmationTotal += product['total'];
                                      currency = product['plat']['currency'];
                                    });
                                    return ConfirmationItem(
                                      product['plat']['name'],
                                      products.length > 1 ? index + 1 : 0,
                                      double.parse(
                                          product['plat']['price'].toString()),
                                      product['plat']['currency'],
                                      product['addons']
                                          .map((addons) => {
                                                "name": addons['name'],
                                                "price":
                                                    addons['price'] == null ||
                                                            addons['price'] == 0
                                                        ? "Free"
                                                        : addons['price'],
                                                "currency":
                                                    addons['price'] == null ||
                                                            addons['price'] == 0
                                                        ? ""
                                                        : addons['currency'],
                                              })
                                          .toList(),
                                      () {
                                        showDialog(
                                          context: context,
                                          builder: ((context) {
                                            return ConfirmationMessage(
                                              "Alert",
                                              "Vous êtes sûr que vous voulez retirer ce produit!",
                                              () {
                                                setState(() {
                                                  confirmationTotal -=
                                                      product['total'];
                                                  Provider.of<Categories>(
                                                          context,
                                                          listen: false)
                                                      .removeProduct(product);
                                                  products.remove(product);
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          }),
                                        );
                                      },
                                      () {
                                        showDialog(
                                          context: context,
                                          builder: ((context) {
                                            return ConfirmationMessage(
                                              "Alert",
                                              "Vous êtes sûr que vous voulez retirer ce addons!",
                                              () {
                                                setState(() {
                                                  confirmationTotal -=
                                                      product['total'];
                                                  Provider.of<Categories>(
                                                          context,
                                                          listen: false)
                                                      .removeProduct(product);
                                                  products.remove(product);
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          }),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2.h,
                          indent: 10.w,
                          endIndent: 10.w,
                          color: darkColor,
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: Text(
                            "Total: $confirmationTotal$currency",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 11.sp,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    confirmationTotal = 0;
                  });
                  Provider.of<Categories>(context, listen: false)
                      .setLastStepIndex(stepIndex);
                  Provider.of<Categories>(context, listen: false)
                      .setStepIndex(0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryScreen()));
                },
                child: Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: darkColor.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 4.h),
                      )
                    ],
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Text(
                      'Ajouter un autre produit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: lightColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 92.h),
          ],
        ),
      ),
      bottomSheet: bottomsheet(context, () async {
        if (confirmationTotal == 0) {
          showDialog(
              context: context,
              builder: ((context) {
                return ErrorPopUp(
                    "Alert", "veuillez sélectionner un produit d'abord");
              }));
        } else {
          List<dynamic> productsHistory = products
              .map((product) =>
                  {'plat': product['plat']['_id'], 'addons': product['addons']})
              .toList();
          setState(() {
            isLoading = true;
          });
          Histories histories = Histories();
          errorMessage = await histories
              .addHistory(productsHistory, formule,
                  confirmationTotal.toString() + currency)
              .whenComplete(() => setState(() {
                    isLoading = false;
                  }));
          if (errorMessage == "success") {
            Provider.of<Categories>(context, listen: false).setStepIndex(0);
            Provider.of<Categories>(context, listen: false).setLastStepIndex(0);
            Provider.of<Categories>(context, listen: false).setNbSteps(5);
            Provider.of<Categories>(context, listen: false).removeAllProducts();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PaiementScreen()));
          } else {
            showDialog(
                context: context,
                builder: ((context) {
                  return ErrorPopUp("Alert", errorMessage);
                }));
          }
        }
      }, () {
        if (products.isEmpty) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CategoryScreen()));
          Provider.of<Categories>(context, listen: false).setStepIndex(0);
        } else if (lastProduct == products.last) {
          Provider.of<Categories>(context, listen: false).removeLastProduct();

          Provider.of<Categories>(context, listen: false)
              .setStepIndex(stepIndex - 1);
          Navigator.of(context).pop();
        }
      }, isLoading),
    );
  }
}
