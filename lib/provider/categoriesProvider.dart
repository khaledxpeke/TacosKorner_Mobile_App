// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Categories with ChangeNotifier {
  List<dynamic> categories = [];
  Map<String, dynamic> category = {};
  Map<String, dynamic> addon = {};
  int selectedCategory = -1;
  String formule = "";
  double total = 0;
  List<dynamic> products = [];
  int nbSteps = 2;
  int stepIndex = 0;
  int lastStepIndex = 0;
  Map<String, dynamic> lastProduct = {};

  final url = dotenv.env['API_URL'];

  Future<String> getCategories() async {
    try {
      final response = await http.get(Uri.parse("$url/category"));
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        categories = body;
        notifyListeners();
        return "success";
      } else {
        return body['message'];
      }
    } on SocketException {
      return "Impossible d'accéder à Internet!";
    } on FormatException {
      return "Une erreur est survenue";
    } catch (exception) {
      return exception.toString();
    }
  }

  setFormule(String formule1) {
    formule = formule1;
    notifyListeners();
  }

  setSelectedCategory(int indx) {
    selectedCategory = indx;
    notifyListeners();
  }

  setCategory(Map<String, dynamic> category1) {
    category = category1;
    notifyListeners();
  }

  setTotal(double total1) {
    total = total1;
    notifyListeners();
  }

  setProducts(Map<String, dynamic> products1) {
    products.add(products1);
    lastProduct = products.last;
    notifyListeners();
  }

  removeLastProduct() {
    if (products.isNotEmpty) {
      products.removeLast();
    }
    notifyListeners();
  }

  removeProduct(Map<String, dynamic> products1) {
    products.remove(products1);
    notifyListeners();
  }

  removeAddon(int productIndex, Map<String, dynamic> addon1, double price) {
    // double removedAddonPrice = 0.0;
    bool removed = false;

    products[productIndex]['addons'].removeWhere((addon) {
      if (!removed && addon['name'] == addon1['name']) {
        // removedAddonPrice = price;
        removed = true;
        return true;
      }
      return false;
    });

    if (removed) {
      products[productIndex]['total'] -= price;
      notifyListeners();
    }
  }

  removeExtra(int productIndex, Map<String, dynamic> addon1) {
    double removedAddonPrice = 0.0;
    bool removed = false;

    products[productIndex]['extras'].removeWhere((addon) {
      if (!removed && addon['name'] == addon1['name']) {
        removedAddonPrice = addon['price']?.toDouble() ?? 0.0;
        removed = true;
        return true;
      }
      return false;
    });

    if (removed) {
      products[productIndex]['total'] -= removedAddonPrice;
      notifyListeners();
    }
  }

  removeAllProducts() {
    products = [];
    notifyListeners();
  }

  setNbSteps(int nbSteps1) {
    nbSteps = nbSteps1;
    notifyListeners();
  }

  setStepIndex(int stepIndex1) {
    stepIndex = stepIndex1;
    notifyListeners();
  }

  setLastStepIndex(int lastStepIndex1) {
    lastStepIndex = lastStepIndex1;
    notifyListeners();
  }
}
