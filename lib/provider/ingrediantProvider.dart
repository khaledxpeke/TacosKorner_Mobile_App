// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class Ingredients with ChangeNotifier {
  List<dynamic> selectedIngrediants = [];
  List<dynamic> types = [];
  String type = "";
  String message = "";
  int max = 1;
  List<dynamic> ingrediants = [];
  int index = 0;


  setSelectedIngrediants(List<dynamic> selectedIngrediants1) {
    selectedIngrediants = selectedIngrediants1;
    notifyListeners();
  }

  setTypes(List<dynamic> types1) {
    types = types1;
    notifyListeners();
  }

  setType(String type1,String message1,int max1,int indx) {
    type = type1;
    message = message1;
    max = max1;
    index = indx;
    notifyListeners();
  }

  setIngrediants(List<dynamic> ingrediants1) {
    ingrediants = ingrediants1;
    notifyListeners();
  }
}
