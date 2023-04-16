import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:takos_korner/fakeData.dart/categories.dart';
import 'package:http/http.dart' as http;

import '../models/http_exceptions.dart';

class Categories with ChangeNotifier {
  List<dynamic> categories = [];
  Map<String, dynamic> category = {};
  List<dynamic> dishes = [];
  int selectedCategory = -1;
  int selectedProduct = -1;

  final url = Uri.parse("http://192.168.1.101:3000/api");

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
      print('error $e');
      throw HttpException("il n'y a pas de depot encore, réessayer plus tard");
    }
  }

  setSelectedCategory(int indx) {
    selectedCategory = indx;
    notifyListeners();
  }
}
