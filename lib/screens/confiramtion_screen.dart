// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/history.dart';
import 'package:takos_korner/provider/printerProvider.dart';
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
  String currency = "€";
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
    confirmationTotal =
        products.fold(0.0, (sum, product) => sum + product['total']);
    currency = products.isNotEmpty ? products.first['plat']['currency'] : "€";
    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
          child: Stack(children: [
        Column(
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
                  width: 230.w,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                                color: textColor,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'PU',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Text(
                                  'TOT',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(
                          thickness: 2.h,
                          color: darkColor,
                        ),
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
                                    return ConfirmationItem(
                                        product,
                                        products.length > 1 ? index + 1 : 0,
                                        product['addons'] ?? [],
                                        product['extras'] ?? [], () {
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
                                                Provider.of<Categories>(context,
                                                        listen: false)
                                                    .removeProduct(product);
                                                products.remove(product);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        }),
                                      );
                                    }, (selectedAddon, price) {
                                      showDialog(
                                        context: context,
                                        builder: ((context) {
                                          return ConfirmationMessage(
                                            "Alert",
                                            "Vous êtes sûr que vous voulez retirer ce addon!",
                                            () {
                                              setState(() {
                                                if (selectedAddon['price'] !=
                                                    "Gratuit") {
                                                  confirmationTotal -=
                                                      selectedAddon['price'] ??
                                                          0.0;
                                                }
                                                Provider.of<Categories>(context,
                                                        listen: false)
                                                    .removeAddon(index,
                                                        selectedAddon, price);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        }),
                                      );
                                    }, (selectedExtra) {
                                      showDialog(
                                        context: context,
                                        builder: ((context) {
                                          return ConfirmationMessage(
                                            "Alert",
                                            "Vous êtes sûr que vous voulez retirer ce extra!",
                                            () {
                                              setState(() {
                                                if (selectedExtra['price'] !=
                                                    "Gratuit") {
                                                  confirmationTotal -=
                                                      selectedExtra['price'];
                                                }
                                                Provider.of<Categories>(context,
                                                        listen: false)
                                                    .removeExtra(
                                                        index, selectedExtra);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        }),
                                      );
                                    });
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
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: bottomsheet(context, () async {
            if (confirmationTotal == 0) {
              showDialog(
                  context: context,
                  builder: ((context) {
                    return ErrorPopUp(
                        "Alert", "veuillez sélectionner un produit d'abord");
                  }));
            } else {
              setState(() {
                isLoading = true;
              });
              List<Map<String, dynamic>> addons = [];
              List<Map<String, dynamic>> extras = [];
              for (var product in products) {
                product['addons'].asMap().entries.forEach((entry) {
                  final Map<String, dynamic> currentItem = entry.value;
                  final int count = product['addons']
                      .where((element) =>
                          element['name'] == currentItem['name'] &&
                          element['price'] == currentItem['price'])
                      .length;
                  final itemType = currentItem['type'];
                  double totalPrice = 0.0;

                  if (itemType != null) {
                    final startIndex = product['plat']['rules'].firstWhere(
                        (type) => type['type']['name'] == itemType['name'],
                        orElse: () => null);
                    List filteredItems = product['addons']
                        .where((element) =>
                            element['type'] != null &&
                            element['type']['name'] ==
                                currentItem['type']['name'])
                        .toList();

                    if (startIndex != null &&
                        startIndex['free'] >= 0 &&
                        startIndex['free'] < filteredItems.length) {
                      List sublist2 = filteredItems.sublist(startIndex['free']);
                      totalPrice = sublist2
                          .where((item) => item['name'] == currentItem['name'])
                          .fold(0.0,
                              (double sum, item) => sum + (item['price'] ?? 0));
                    } else {
                      totalPrice = 0;
                    }
                  } else if (currentItem['price'] != null) {
                    totalPrice = currentItem['price'].toDouble() ?? 0;
                  } else {
                    totalPrice = 0;
                  }

                  Map<String, dynamic> addonInfo = {
                    "_id": currentItem['_id'],
                    "name": currentItem['name'],
                    "total": totalPrice,
                    "count": count,
                    "pu": currentItem['price'] ?? 0,
                  };
                  bool entryExists = addons.any((element) =>
                      element['name'] == currentItem['name'] &&
                      element['total'] == totalPrice);
                  if (!entryExists) {
                    addons.add(addonInfo);
                  }
                });
                product['extras'].asMap().entries.forEach((entry) {
                  final int index = entry.key;
                  final Map<String, dynamic> currentItem = entry.value;
                  final int count = product['extras']
                      .where((element) => element == product['extras'][index])
                      .length;
                  double price = 0;
                  if (currentItem['price'] != null) {
                    price = currentItem['price'].toDouble();
                  }
                  Map<String, dynamic> extraInfo = {
                    "_id": currentItem['_id'],
                    "name": currentItem['name'],
                    "total": price * count,
                    "count": count,
                    "pu": price,
                  };
                  bool entryExists = extras.any((element) =>
                      element['name'] == currentItem['name'] &&
                      element['total'] == price * count);
                  if (!entryExists) {
                    extras.add(extraInfo);
                  }
                });
                product['addons'] = addons;
                addons = [];
                product['extras'] = extras;
                extras = [];
              }
              List<dynamic> productsHistory = products
                  .map((product) => {
                        'plat': {
                          "_id": product['plat']['_id'],
                          "category": product['plat']['category'],
                          "name": product['plat']['name'],
                          "price": product['plat']['price'],
                          "currency": product['plat']['currency'],
                        },
                        'addons': product['addons'],
                        'extras': product['extras']
                      })
                  .toList();
              String result = await context.read<Printer>().commandNumber();
              if (result != "success") {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return ErrorPopUp("Alert", errorMessage);
                    }));
              } else {
                int commandNumb = Provider.of<Printer>(context,listen: false).commandNumb;
                String transformToJsonToText(List data) {
                  StringBuffer text = StringBuffer();
                  text.write("[align: center][font: a]");
                  text.write(
                      "[image: url https://i.pinimg.com/236x/1c/e4/e7/1ce4e72b3569b59d066d2a69ddbd2934.jpg; width 40%;min-width 25mm]");
                  text.write("[magnify: width 3; height 1]");
                  text.write("[align: middle]Reçu\n\n");
                  text.write("[magnify]");
                  text.write("[magnify: width 3; height 2][font: b]");
                  text.write("Commande N°$commandNumb[font]\n\n");
                  text.write("[magnify]");
                  text.write(formule);
                  text.write("\n\n");
                  text.write(
                      "[bold: on][column: left:  Nom;     right: PU        TOT][bold]");
                  text.write(
                      "------------------------------------------------\n");
                  int entryIndex = 0;
                  int totalEntries = data.length;
                  for (var entry in data) {
                    entryIndex++;
                    text.write(
                        "[bold: on][column: left: ${entry['plat']['name']};     right: ${entry['plat']['price']}][bold]\n");
                    if (entry['addons'].isNotEmpty) {
                      text.write("\n");
                      for (var addon in entry['addons']) {
                        text.write(
                            "[column: left: X${addon['count']} ${addon['name']};      right: ${addon['total'] == 0 ? '' : addon['pu']}        ${addon['total'] == 0 ? '--' : addon['total']}]\n");
                      }
                    }
                    if (entry['extras'].isNotEmpty) {
                      text.write("[align: middle][bold: on]Extras[bold: off]");
                      for (var extra in entry['extras']) {
                        text.write(
                            "[column: left: X${extra['count']} ${extra['name']};      right: ${extra['total'] == 0 ? '' : extra['pu']}        ${extra['total'] == 0 ? '--' : extra['total']}]\n");
                      }
                    }
                    if (entryIndex < totalEntries) {
                      text.write(
                          "\n------------------------------------------------\n");
                    }
                  }
                  text.write("______________________________________________");
                  text.write("\n\n");
                  text.write("[align: center]");
                  text.write("[magnify: width 2; height 1]");
                  text.write(
                      "[bold: on]Total : $confirmationTotal $currency [bold]");
                  text.write("\n\n");
                  text.write("[magnify]");
                  text.write(DateFormat('EEEE y/MM/dd HH:mm').format(DateTime.now()));
                  text.write("\n\n");
                  text.write(
                      "[barcode: type code39; data ABC123 ;module 0;hri]");
                  text.write("[align middle]");
                  text.write("Merci et à la prochaine!");
                  text.write("[cut: feed; partial]");
                  return text.toString();
                }

                String formattedText = transformToJsonToText(productsHistory);
                Printer printer = Printer();
                errorMessage = await printer
                    .billPrinter(formattedText)
                    .whenComplete(() => setState(() {
                          isLoading = false;
                        }));
                if (errorMessage == "success") {
                  Provider.of<Categories>(context, listen: false)
                      .setStepIndex(0);
                  Provider.of<Categories>(context, listen: false)
                      .setLastStepIndex(0);
                  Provider.of<Categories>(context, listen: false).setNbSteps(5);
                  Provider.of<Categories>(context, listen: false)
                      .removeAllProducts();
                  Histories histories = Histories();
                  errorMessage = await histories.addHistory(productsHistory,
                      formule, confirmationTotal.toString() + currency);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaiementScreen()));
                } else {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return ErrorPopUp("Alert", errorMessage);
                      }));
                }
              }
            }
          }, () {
            if (products.isEmpty) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()));
              Provider.of<Categories>(context, listen: false).setStepIndex(0);
            } else if (lastProduct == products.last) {
              Provider.of<Categories>(context, listen: false)
                  .removeLastProduct();
              Provider.of<Categories>(context, listen: false)
                  .setStepIndex(stepIndex - 1);
              Navigator.of(context).pop();
            } else {
              Provider.of<Categories>(context, listen: false)
                  .setStepIndex(stepIndex - 1);
              Navigator.of(context).pop();
            }
          }),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: LoadingAnimationWidget.inkDrop(
                    color: primaryColor, size: 25.w),
              ),
            ),
          ),
      ])),
    );
  }
}
