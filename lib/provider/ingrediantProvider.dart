// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class Ingredients with ChangeNotifier {
  // List<dynamic> selectedIngrediants = [];
  int size = 0;
  List<dynamic> types = [];
  Map<String, dynamic> type = {};
  List<dynamic> ingrediants = [];
  List<dynamic> selectedExtras = [];
  int index = 0;

  setSelectedExtras(List<dynamic> selectedExtras1) {
    selectedExtras = selectedExtras1;
    notifyListeners();
  }

  // setSelectedIngrediants(List<dynamic> selectedIngrediants1) {
  //   selectedIngrediants = selectedIngrediants1;
  //   notifyListeners();
  // }

  setAddonsSize(int nb) {
    size = nb;
    notifyListeners();
  }

  setTypes(List<dynamic> types1) {
    types = types1;
    notifyListeners();
  }

  setType(Map<String, dynamic> type1, int indx) {
    type = type1;
    index = indx;
    notifyListeners();
  }

  setIngrediants(List<dynamic> ingrediants1) {
    ingrediants = ingrediants1;
    notifyListeners();
  }
}
