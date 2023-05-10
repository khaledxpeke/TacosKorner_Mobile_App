// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Categories with ChangeNotifier {
  List<dynamic> categories = [];
  Map<String, dynamic> category = {};
  int selectedCategory = -1;
  String formule = "";
  double total = 0;
  List<dynamic> products = [];
  int nbSteps = 4;
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
      return "Une erreur s'est produite";
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
    lastProduct=products.last;
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
