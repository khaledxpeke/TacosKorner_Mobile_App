// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/http_exceptions.dart';

class Categories with ChangeNotifier {
  List<dynamic> categories = [];
  Map<String, dynamic> category = {};
  int selectedCategory = -1;
  int selectedProduct = -1;
  String formule = "";
  String package = "";
  double total = 0;
  int items = 0;
  int steps = 0;

  final url = Uri.parse("http://192.168.1.24:3000/api");

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

  setPackage(String package1) {
    package = package1;
    notifyListeners();
  }

  setTotal(double total1) {
    total = total1;
    notifyListeners();
  }

  setItems(int items1) {
    items = items1;
    notifyListeners();
  }
}
