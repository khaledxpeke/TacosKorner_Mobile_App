// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/http_exceptions.dart';

class Categories with ChangeNotifier {
  List<dynamic> categories = [];
  Map<String, dynamic> category = {};
  int selectedCategory = -1;
  String formule = "";
  double total = 0;
  List<dynamic> products = [];
  int nbSteps = 4;
  int stepIndex = 0;

  final url = dotenv.env['API_URL'];

  Future<void> getCategories() async {
    try {
      final response = await http.get(Uri.parse("$url/category"));
      if (response.statusCode == 200) {
        categories = json.decode(response.body);
        notifyListeners();
      } else {
        throw HttpException(
            "il n'y a pas de depot encore, réessayer plus tard");
      }
    } catch (e) {
      print('error: $e');
      throw HttpException("il n'y a pas de depot encore, réessayer plus tard");
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
}
